'' =================================================================================================
''
''   File....... jm_dmxout.spin
''   Purpose.... 
''   Author..... Jon "JonnyMac" McPhalen (aka Jon Williams)
''               Copyright (c) 2009 Jon McPhalen
''               -- see below for terms of use
''   E-mail..... jon@jonmcphalen.com
''   Started.... 05 JUL 2009
''   Updated.... 23 SEP 2009 
''
'' =================================================================================================

{{

               +5v           +5v
                              
                │             │
                             │                   
            4k7 │ ┌─────────┐ │                   
   dmxrx ────┻─┤1°      8├─┘                   
    txrx ──────┳─┤2       7├────────┳──────┳─────── Pin 2 XLR-F 
                ┣─┤3       6├────────┼─┳────┼─┳───── Pin 3 XLR-F    DMX OUT
   dmxtx ──────┼─┤4       5├─┐      │ │    │ │ ┌─── Pin 1 XLR-F 
                │ └─────────┘ │      │ └ ┐  │ │ │               
            4k7    ST485BN   │  120  ┌ ┘  └─┼─┼─── Pin 2 XLR-M
                │             │      │ │      └─┼─── Pin 3 XLR-M    DMX IN
                                   └─┘        ┣─── Pin 1 XLR-M
                                                └ ┐
                                                ┌ ┘
                                                

   ST485BN (Mouser 511-ST485BN) pins

   1  RO   Receive output
   2  /RE  Receive enable  (active low)
   3  DE   Transmit enable (active high)
   4  DI   Transmit input
   5  Vss  ground
   6  A    differential IO
   7  B    differential IO
   8  Vdd  +5v


   Resources

   * http://www.erwinrol.com/index.php?stagecraft/dmx.php
   * http://www.dmx512-online.com/packt.html
   * http://en.wikipedia.org/wiki/DMX512-A
                   
}}                                  


con
 

var

  long  cog

  byte  dmxbuf[513]                                             ' DMX output buffer

 
pub init(tx, ctrl, sbyte, size, b2bt) : okay  

'' Initialize DMX transmitter cog
'' -- tx    is transmit pin
'' -- ctrl  is the control pin; make high to transmit
'' -- sbyte is the system start byte
'' -- size  is the number of frames to transmit (2 to 513)      ' start + frames (at least 1)
'' -- b2bt  is break-to-break timing, 23ms to 44ms 

  finalize

  US_001  := clkfreq / 1_000_000                                ' ticks per 1us
  US_004  := US_001 * 4                                         ' bit timing
  BREAK   := US_001 * 92                                        ' tx break timing
  MAB     := US_001 * 12                                        ' tx MAB timing

  txmask  := |< tx                                              ' mask for tx pin
  txctrl  := |< ctrl                                            ' mask for txe pin

  buf0    := @dmxbuf                                            ' pointer to dmxbuf[0] 
  packet  := size := (2 #> size <# 513)                         ' frames to transmit
  b2bms   := (23 #> b2bt <# 44) * (clkfreq / 1_000)             ' set b-to-b timing (ticks)

  flushbuf                                                      ' initialize buffer to 0s
  write(0, sbyte)                                               ' set device start byte

  okay := cog := cognew(@dmxout, 0) + 1


pub finalize

'' Stops DMX TX driver; frees a cog

  if cog
    cogstop(cog~ - 1)


pub write(ch, level)

'' Writes level to channel ch (0 - 512)
'' -- ch0 is DMX start byte
'' -- ch1 to chN are channel values

  if (ch => 0) & (ch =< 512)                                    ' valid channel?
    dmxbuf[ch] := (0 #> level <# 255)                           ' set it 


pub flushbuf

  '' Flushes DMX buffer to zeroes

  bytefill(@dmxbuf, 0, 513)

pub buffrptr

  return @dmxbuf

dat

                        org     0

dmxout                  or      outa, txmask                    ' set TX to idle
                        or      dira, txmask                    ' make output
                        or      outa, txctrl                    ' set RS-485 to TX mode
                        or      dira, txctrl                    ' make an output

                        mov     tmp1, MAB                       ' let transmitter turn on
                        add     tmp1, cnt
                        waitcnt tmp1, #0                        

                        mov     b2btimer, b2bms                 ' set b2b timing (ms)
                        add     b2btimer, cnt                   ' sync with system cntr

txbreak                 andn    outa, txmask                    ' tx := 0
                        mov     tmp1, BREAK                     ' hold for break
                        add     tmp1, cnt
                        waitcnt tmp1, #0
                        
txmab                   or      outa, txmask                    ' tx := 1
                        mov     tmp1, MAB                       ' hold for mab 
                        add     tmp1, cnt
                        waitcnt tmp1, #0

                        mov     bufpntr, buf0                   ' bufpntr := @dmxbuf[0]
                        mov     count, packet                   ' send N bytes

sendpacket              rdbyte  txwork, bufpntr                 ' get byte from buffer
                        call    #transmit                       ' send it                                               
                        add     bufpntr, #1                     ' update buffer pointer
                        djnz    count, #sendpacket              ' update tx'd count                                                                        

                        waitcnt b2btimer, b2bms                 ' let b-to-b timer expire
                        jmp     #txbreak


' -----------------------------
' True Mode TX UART @ 250K baud
' -----------------------------
'
transmit                or      txwork, STOP_BITS               ' set stop bit(s)
                        shl     txwork, #1                      ' add start bit
                        mov     txcount, #11                    ' 1 start + 8 data + 2 stop
                        mov     txtimer, US_004                 ' load bit timing
                        add     txtimer, cnt                    ' sync with system counter

txbit                   shr     txwork, #1              wc      ' move bit0 to C
                        muxc    outa, txmask                    ' output the bit to tx pin
                        waitcnt txtimer, US_004                 ' let timer expire, reload   
                        djnz    txcount, #txbit                 ' update bit count
                        
transmit_ret            ret

                                              

' --------------------------------------------------------------------------------------------------

STOP_BITS               long    $FFFF_FF00                      ' tx stop bits 

US_001                  long    0-0                             ' ticks in 1us 
US_004                  long    0-0                             ' ticks in 4us 
BREAK                   long    0-0                             ' ticks in Break (92us)  
MAB                     long    0-0                             ' ticks in MAB (12us) 
       
txmask                  long    0-0                             ' mask for TX pin
txctrl                  long    0-0                             ' maks for TXE pin 
       
buf0                    long    0-0                             ' poiner to dmxbuf[0]   
packet                  long    0-0                             ' frames in packet 
b2bms                   long    0-0                             ' break-to-break (23 to 44ms)

bufpntr                 res     1                               ' pointer to byte to tx
count                   res     1                               ' frames to tx
b2btimer                res     1                               ' timer for frame
txwork                  res     1                               ' byte to transmit
txcount                 res     1                               ' bits to transmit
txtimer                 res     1                               ' tx bit timer
tmp1                    res     1
tmp2                    res     1 

                        fit     492
                        

dat

{{

  Copyright (c) 2009 Jon McPhalen (aka Jon Williams)

  Permission is hereby granted, free of charge, to any person obtaining a copy of this
  software and associated documentation files (the "Software"), to deal in the Software
  without restriction, including without limitation the rights to use, copy, modify,
  merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
  permit persons to whom the Software is furnished to do so, subject to the following
  conditions:

  The above copyright notice and this permission notice shall be included in all copies
  or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
  PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

}}                   