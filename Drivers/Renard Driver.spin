'' ****************************************************** 
'' * Renard Driver Object                               *
'' * Copyright Jun 2010 Gregory Bartlett                *
'' * Adaptation : Benjamin Yaroch                       *
'' * See end of file for terms of use                   *
'' * Version 1.0                                        *
'' ******************************************************
'' *
'' * This object drives a Renard chain.
'' * The main object must call the start method with the transmit pin,
'' * baud rate, pointer to the initial intensity buffer, number of
'' * channels as parameters and refresh rate.
'' *
'' * It requires the main object to have single byte oriented buffer.
'' * The number of bytes available in that buffer must be at least equal 
'' * to the number of Renard channels that will be sent.
'' *
'' * To update the driver the main object needs to load the intensity
'' * values into the buffer. Based on teh refresh value when it is time for the event 
'' * data is read from the buffer and sent to the Renard chain.
'' *
'' * NOTE: This code is a modified version of the Helix version of this driver.
'' * Special thanks to Greg for allowing me to adapt this for the PropController
'' *
CON

  baudrate = 57_600
  
VAR
  long  cogon, cog
  
  long  tx_pin                                          'transmit pin
  long  bit_ticks                                       'number of clock cycles per bit
  long  buffer_ptr                                      'pointer to the current intensity buffer
  long  channels                                        'number of channels in the Renard chain
  byte  dataBuffr[512]                                  'Renard output buffer                                                                                

PUB start(_txpin, _chans, _refresh) : okay  | idx

  tx_pin := _txpin                                      'initialize the tx_pin
  bit_ticks := clkfreq / baudrate                       'calculate the number of clock cycles per bit
  buffer_ptr := @dataBuffr                              'initialize the buffer_ptr
  channels := (_chans <# 512)                           'initialize the number of channels (less than 512)
  REFRESH := (25 #> _refresh) * (clkfreq / 1_000)       'tx refresh rate (25ms or more)

  okay := cogon := (cog := cognew(@entry, @tx_pin)) > 0              

PUB stop

        if cogon~
          cogstop(cog)

pub flushbuf

  '' Flushes data buffer to zeroes

  bytefill(@dataBuffr, 0, 512)

pub buffrptr

  return @dataBuffr

DAT
'' Initialize Renard transmitter cog  
                org
                
entry           mov     t1,par                          'get tx_pin
                rdlong  t2,t1
                mov     txmask, #1                      'setup txmask
                shl     txmask,t2

                add     t1,#4                           'get bit_ticks
                rdlong  bitticks,t1

                add     t1,#4                           'get buffer_ptr
                rdlong  pTXbuffptr,t1

                add     t1,#4                           'get channels
                rdlong  txchannels,t1

                or      outa,txmask                     'init tx pin to high output
                or      dira,txmask                     'set tx pin direction to output                
'
' Wait for refresh time to elapse
'
wait            mov     t2,REFRESH                                                   
                add     t2,cnt
                waitcnt t2,#0                           ' let refresh timer expire 

transmit        mov     txcnt,txchannels                'setup number of channels to tx
                mov     txbuff,pTXbuffptr               'Load pointer (buffer_ptr) into txbuff
'
' Send the sync byte (0x7E)
'
                mov     txdata,sync                     'load the sync byte
                call    #tx                             'transmit the sync byte
'
' Send the command byte (0x80)
'
                mov     txdata,command                  'load the command byte
                call    #tx                             'transmit the command byte
'
' Send the intensity values
'
:byte           rdbyte  txdata,txbuff                   'get the byte to transmit
                add     txbuff,#1                       'increment the buffer ptr
'
' Check for special characters (0x7D, 0x7E, 0x7F)
'
                cmp     txdata,#$7D             wz      'check for 0x7D
        if_z    call    #esc                            'send escape byte
                cmp     txdata,#$7E             wz      'check for 0x7E
        if_z    call    #esc                            'send escape byte
                cmp     txdata,#$7F             wz      'check for 0x7F
        if_z    call    #esc                            'send escape byte
'
' Add Stop bit and Start bit then transmit the byte
'                
                or      txdata,#$100                    'add stop bit
                shl     txdata,#1                       'add start bit
                call    #tx                             'transmit byte
                djnz    txcnt,#:byte                    'repeat until all bytes are transmitted
                jmp     #wait                           'wait for next buffer update

'
' Transmit the byte
'
tx              mov     txbits,#10                      'setup number of bits to tx
                mov     bitcnt,cnt                      'setup timing
                add     bitcnt,bitticks
:bit            test    txdata,#1               wc      'test the LSB
                muxc    outa,txmask                     'set the tx pin
                shr     txdata,#1                       'setup for next bit
                waitcnt bitcnt,bitticks                 'wait for end of bit period
                djnz    txbits, #:bit                   'repeat until all bits are transmitted
tx_ret          ret                                     'return from transmit byte

'
' Send Escape byte (0x7F)
'
esc             mov     t1,txdata                       'save the byte to be transmitted
                mov     txdata,escape                   'load the escape byte
                call    #tx                             'transmit the byte
                mov     txdata,t1                       'restore the original byte
esc_ret         ret                                     'return

'
' Initialized Data
'
sync      long    $000002FC     'Synch byte (0x7E + 1 start bit and 1 stop bit)
escape    long    $000002FE     'Escape byte (0x7F + 1 start bit and 1 stop bit)
command   long    $00000300     'Standard command byte (0x80 + 1 start bit and 1 stop bit)                                                                               
REFRESH   long    0-0           'ticks in refresh (between packet sends)                 
'
' Uninitialized Data
'           
t1              res     1       'temp1
t2              res     1       'temp2

bitticks        res     1       'number of clock cycles between bits
bitcnt          res     1       'used to keep track of the delay between bits
txmask          res     1       'mask for the transmit pin
txbuff          res     1       'pointer to idex in transmit buffer
pTXbuffptr      res     1       'pointer to the transmit buffer pointer
txdata          res     1       'the data to be transmitted
txcnt           res     1       'used to keep track of the number of channels to send out
txbits          res     1       'used to keep track of the number of bits to send out
txchannels      res     1       'number of Renard channels in the chain

{{
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                 │                                                            
├─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation   │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,   │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the        │
│Software is furnished to do so, subject to the following conditions:                                                         │         
│                                                                                                                             │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the         │
│Software.                                                                                                                    │
│                                                                                                                             │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE         │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR        │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,  │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                        │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}                