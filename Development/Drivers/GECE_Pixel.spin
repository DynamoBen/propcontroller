'' ******************************************************
'' * GE Color Effects Pixel Driver Object               *
'' * Copyright Feburary 2011 Benjamin Yaroch            *
'' * See end of file for terms of use                   *
'' * Version 1.0                                        *
'' ******************************************************
''
'' Each bulb has an address numbering from zero to fourty-nine, with bulb zero being the bulb closest to the control box.
''
'' The protocol on the data line is simple and self-clocked. Here are the low-level details:
''  * Idle bus state: Low
''  * Start Bit: High for 10µSeconds
''  * 0 Bit: Low for 10µSeconds, High for 20µSeconds
''  * 1 Bit: Low for 20µSeconds, High for 10µSeconds
''  * Minimum quiet-time between frames: 30µSeconds
''
'' Each frame is 26 bits long and has the following format:
''  * Start bit
''  * 6-Bit Bulb Address, MSB first
''  * 8-Bit Brightness, MSB first
''  * 4-Bit Blue, MSB first
''  * 4-Bit Green, MSB first
''  * 4-Bit Red, MSB first
''
'' Bulb address 63 can be thought of as the "broadcast" bulb, except that it only changes the brightness level
'' the color fields are ignored. Bulb addresses 50-62 are ignored under normal circumstances.
''
'' Each frame takes 820 µSeconds to transmit. Since there are 50 bulbs, that means that takes a minimum of 41
'' milliseconds to individually update every bulb. This gives us a maximum refresh rate of slightly more than 24Hz. 
''
'' Bulb Enumeration
'' It turns out that the data line is not a continuous wire of copper thru the whole string. Each bulb contains a
'' microcontroller with two data lines: one is an input, and one is an output.
''
'' When the string first powers up, all bulbs are in the "enumerate" state. When in this state, the first command received
'' is used to tell the bulb what its address is. Once the address is set, all subsequent commands are forwarded to the next bulb.
'' This process continues until all bulbs are enumerated and have an address.
''
'' Normally, you would want to perform some sort of power-on enumeration which would give each lamp it's own address but this
'' isn't the only option. The enumeration step allows you to assign any address to any bulb you want including giving several
'' bulbs the same address. By giving several bulbs the same address, you can control several bulbs with a single command.
''
'' Bulb Flicker
'' It appears that any time you change the brightness level on a bulb by larger than a single increment or decrement that the bulb
'' will randomly 'glitch' for a few milliseconds. These glitches are minor if you are only doing this infrequently, but if you are
'' updating the brightness level quickly it can become a problem, especially if you are updating the brightness level for each bulb
'' individually. Changing the color value (while not changing the brightness) doesn't cause glitches.
''
'' More Information: http://www.deepdarc.com/2010/11/27/hacking-christmas-lights/
''
'' Revision Changes:
''   1.0 Feb 2011:  Initial Release
''
VAR

  long  cog
                                                                      
  long  DATA_pin                ' Data pin for pixel string           
  long  IntnsBffr               ' Intensity data buffer pointer       
  long  PixelCnt                ' Number of pixels in string         
  long  BitTime                 ' Delay between bits as they are sent

PUB Start(_SDI, _IntnsBffr, _pixelCnt) : okay

  DATA_pin     := _SDI                                  ' Data pin
  IntnsBffr    := _IntnsBffr                            ' Intensity buffer pointer
  PixelCnt     := _pixelCnt                             ' Number of pixels
  PacketDelay  := (clkfreq/100_000) * 30                ' Duration of Packet delay 
  BitTime      := (clkfreq / 10_000_000) * 4            ' 400ns bit time delay        
  
  okay  := cog := cognew(@entry, @DATA_pin) + 1         ' Start driver in new cog
      
PUB Stop

' Stop Pixel Driver, frees cog

  if cog
    cogstop(cog~ - 1)

DAT

'***********************************
'* Assembly language pixel driver  *
'***********************************
                        org
'
'
' Entry
'                                                        
entry         mov       t1, par                 ' Get @Data Pin Number                                                 
              rdlong    t2, t1                  ' Setup DataIn Pin Mask
              mov       DATAmask, #1             
              shl       DATAmask, t2             
                                                 
              add       t1, #4                  ' Get @ of the intensity of the first channel
              rdlong    BffrPtr, t1              
                                                 
              add       t1, #4                   
              rdlong    PxlCnt, t1              ' Get Number of Pixels to be controlled & mutliple by 3 (RGB)

              add       t1,#4                   ' Increament address pointer by four bytes
              rdlong    BitDelay,t1             ' Bring over value of BitTime
                                                 
              ' Setup I/O
              andn      outa, DATAmask          ' Preset SerialIn output to LOW
              or        dira, DATAmask          ' Set SerialIn pin to be an OUTPUT              

              ' Inter packet delay (1ms)          
idle          andn      outa, DATAmask          ' Force Data line LOW

              mov       t1, cnt                 ' Setup for a interframe delay (reset)
              add       t1, PktDelay            ' Add counter to delay
              waitcnt   t1, PktDelay            ' Wait for the end of this delay

              mov       BffrIdx, BffrPtr        ' Get pointer location for the first channel in Intns buffer
              mov       PxlIdx, PxlCnt          ' Set intial Pixel Index count
            

              ' Send Data frames (1 per pixel)                        
PixelLoop     rdbyte    t1, BffrIdx             ' Read Red Intensity byte from buffer
              shr       t1, #4                  ' Drop four bits from value
              add       data, t1                ' Add Intensity to variable 
              shl       data, #5                ' Make room for the next data byte 

              add       BffrIdx, #1             ' Read Green Intensity byte from buffer 
              rdbyte    t1, BffrIdx             ' Make room for the next data byte
              shr       t1, #4                  ' Drop four bits from value                         
              add       data, t1                ' Add Intensity to variable
              shl       data, #5                ' Make room for the next data byte
              
              add       BffrIdx, #1             ' Read Blue Intensity byte from buffer                      
              rdbyte    t1, BffrIdx             ' Make room for the next data byte
              shr       t1, #4                  ' Drop four bits from value                            
              add       data, t1                ' Add Intensity to variable
              shl       data, #16               ' Move to MSB of Long

              call      #BitLoop                ' send it
                                 
              add       BffrIdx, #1             ' update buffer pointer
              djnz      PxlIdx, #PixelLoop      ' update Pixel Index count
              jmp       #strtFrame              ' Send next start frame
                                                 
' -----------------------------
'    Shift out pixel data
' -----------------------------                  
'

txbits        mov       BitsCnt, #26            ' Setup to loop through the 24 bits per color

              or        outa, DATAmask          ' DATA output to HIGH
              mov       t2, cnt                 ' Setup for a bit delay 
              add       t2, BitDelay            ' Add counter to delay
              waitcnt   t2, BitDelay            ' Wait for the end of this delay (wait 20us)              

              ' Shift out each bit starting with bit 31   
BitLoop       andn     outa, DATAmask           ' DATA output to LOW
              mov       t2, cnt                 ' Setup for a bit delay 
              add       t2, BitDelay            ' Add counter to delay
              waitcnt   t2, BitDelay            ' Wait for the end of this delay (wait 10us)     


              shl       data, #1           wc   ' move bit31 to C         
              muxc      outa, DATAmask          ' output the bit to data pin

              muxnc     outa, DATAmask          ' opposite of the above output, the bit to data pin

              mov      t2, cnt                  ' Setup for a bit delay 
              add      t2, BitDelay             ' Add counter to delay
              waitcnt  t2, BitDelay             ' Wait for the end of this delay
              

              mov      t2, cnt                  ' Setup for a bit delay 
              add      t2, BitDelay             ' Add counter to delay
              waitcnt  t2, BitDelay             ' Wait for the end of this delay                                                                              
              
                                                                                                
              djnz      BitsCnt, #BitLoop       ' update bit count                                                                                                                                                                                                                                                                                                                    
                                                 
txbits_ret    ret        


' I/O masks 
DATAmask      res       1                       ' DataIn Pin Mask

' Other Variables 
t1            res       1                       ' Temp 1
t2            res       1                       ' Temp 2
PxlCnt        res       1                       ' Number of pixels
BffrIdx       res       1                       ' Address of the intensity of the current channel to be compared
BffrPtr       res       1                       ' Address of the intensity of the first channel
PxlIdx        res       1                       ' Pixels that have been processed
BitsCnt       res       1                       ' Number of bits that have been processed
data          res       1                       ' Data to be sent to pixel (using 16 bits or 32 bits)
BitDelay      res       1                       ' Delay between bits, slows overall data rate
                                           
{{
┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}