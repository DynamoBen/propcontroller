'' ******************************************************
'' * WS2801 Pixel Driver Object                         *
'' * Copyright Feburary 2011 Benjamin Yaroch            *
'' * See end of file for terms of use                   *
'' * Version 1.0                                        *
'' ******************************************************
''
'' WS2801 3-Channel Constant Current LED Driver With Programmable PWM Outputs
''
'' Gray Scale Data Word Format and Timing 
'' CLK pin keeps low more than 500uS will make the WS2801 internal status register reset, and at this moment, the gray scale data
'' in the data shift registers will be latched. Now WS2801 is ready for gray scale data transport. When the WS2801 receives total 24
'' clock rising edges, the WS2801 enters relay mode, which relays the input signal got from CKI and SDI with very low distortion
'' (100pS typical) and very low delay time (8 ns typical). 
'' The gray scale data frame is comprised of 3 gray data words, each data word is composed of 8 gray scale data bits, total 24 bits.
'' The 8bit gray data can easily realize the linear 256 LED gray levels control.
'' During data transfer, the first bit is the data frame signal, then is the MSB of the ROUT channel, the last one transferred into the
'' data shift register is the LSB of the BOUT channel.
''
'' The Connection and Driving of Cascading Operation
'' The transmit the data over long distance by cascading, the WS2801 integrates push-pull output stage with strong driving
'' capability which enables the data and clock can be transmitted up to 6 meters at 2MHz clock frequency.
'' To prevent the reflection, it is necessary to connect a 50Ω resistor at the data input or output port for impedance match.
'' 
'' Revision Changes:
''   1.0 Feb 2011:  Initial Release
''
VAR

  long  cog
  
  long  CLK_pin                 ' Clock pin for pixel string
  long  DATA_pin                ' Data pin for pixel string
  long  IntnsBffr               ' Intensity data buffer pointer
  long  PixelCnt                ' Number of pixels in string
  long  PacketDelay             ' Clock ticks for inter-packet idle time
  long  BitTime                 ' Delay between bits as they are sent

PUB Start(_CLK, _SDI, _IntnsBffr, _pixelCnt) : okay
    
  CLK_pin      := _CLK                                  ' Clock pin                
  DATA_pin     := _SDI                                  ' Data pin                 
  IntnsBffr    := _IntnsBffr                            ' Intensity buffer pointer 
  PixelCnt     := _pixelCnt                             ' Number of pixels   
  PacketDelay  := (clkfreq/1_000)                       ' Duration of Packet delay (datasheet says 500us, but anything under 1ms causes problems)
  BitTime      := (clkfreq / 10_000_000) * 4            ' 400ns bit time delay        
  
  okay  := cog := cognew(@entry, @Clk_pin) + 1          ' Start driver in new cog  

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
entry         mov       t1, par                 ' Get @CLK Pin Number
              rdlong    t2, t1                  ' Get CLK Pin Number
              mov       CLKmask, #1             ' Load CLK Mask with 1
              shl       CLKmask, t2             ' Shift Left appropriate number of times
                                                 
              add       t1, #4                   
              rdlong    t2, t1                  ' Setup DataIn Pin Mask
              mov       DATAmask, #1             
              shl       DATAmask, t2             
                                                 
              add       t1, #4                  ' Get @ of the intensity of the first channel
              rdlong    BffrPtr, t1              
                                                 
              add       t1, #4                   
              rdlong    PxlCnt, t1              ' Get Number of Pixels to be controlled & mutliple by 3 (RGB)
                                                 
              add       t1,#4                   ' Increament address pointer by four bytes
              rdlong    PktDelay,t1             ' Bring over value of BitTime

              add       t1,#4                   ' Increament address pointer by four bytes
              rdlong    BitDelay,t1             ' Bring over value of BitTime
                                                 
              ' Setup I/Os                       
              andn      outa, CLKmask           ' Preset CLK output to LOW
              or        dira, CLKmask           ' Set CLK pin to be an OUTPUT
              andn      outa, DATAmask          ' Preset SerialIn output to LOW
              or        dira, DATAmask          ' Set SerialIn pin to be an OUTPUT

              ' Inter packet delay (1ms)    
idle          andn      outa, CLKmask           ' Force Clock line LOW
              andn      outa, DATAmask          ' Force Data line LOW

              mov       t1, cnt                 ' Setup for a interframe delay (reset)
              add       t1, PktDelay            ' Add counter to delay
              waitcnt   t1, PktDelay            ' Wait for the end of this delay

              mov       BffrIdx, BffrPtr        ' Get pointer location for the first channel in Intns buffer
              mov       PxlIdx, PxlCnt          ' Set intial Pixel Index count

              ' Send Data frames (1 per pixel)
PixelLoop     rdbyte    data, BffrIdx           ' Read Red Intensity byte from buffer 
              shl       data, #8                ' Make room for the next data byte 

              add       BffrIdx, #1             ' Read Green Intensity byte from buffer 
              rdbyte    t1, BffrIdx             ' Make room for the next data byte                          
              add       data, t1                ' Add Intensity to variable
              shl       data, #8                ' Make room for the next data byte
              
              add       BffrIdx, #1             ' Read Blue Intensity byte from buffer                      
              rdbyte    t1, BffrIdx             ' Make room for the next data byte                          
              add       data, t1                ' Add Intensity to variable
              shl       data, #8                ' Move to MSB of Long
                    
              call      #txbits                 ' send it
                                 
              add       BffrIdx, #1             ' update buffer pointer
              djnz      PxlIdx, #PixelLoop      ' update Pixel Index count
              jmp       #idle                   ' Pull lines idle
                                                 
' -----------------------------
'     Shift out pixel data
' -----------------------------                  
'
txbits        mov       BitsCnt, #24            ' Setup to loop through the 24 bits per color

              ' Shift out each bit starting with bit 31
BitLoop       shl       data, #1           wc   ' move bit31 to C         
              muxc      outa, DATAmask          ' output the bit to data pin
              
              mov       t1, cnt                 ' Setup for a bit delay 
              add       t1, BitDelay            ' Add counter to delay
              waitcnt   t1, BitDelay            ' Wait for the end of this delay
              or        outa, CLKmask           ' CLK output to HIGH
              
              mov       t1, cnt                 ' Setup for a bit delay 
              add       t1, BitDelay            ' Add counter to delay
              waitcnt   t1, BitDelay            ' Wait for the end of this delay 
              andn      outa, CLKmask           ' CLK output to LOW
                                             
              djnz      BitsCnt, #BitLoop       ' update bit count                                                                                                                                                                                                                                                                                                                    
                                                 
txbits_ret    ret


' I/O masks 
CLKmask       res       1                       ' CLK Pin Mask
DATAmask      res       1                       ' DataIn Pin Mask

' Other Variables  
t1            res       1                       ' Temp 1
t2            res       1                       ' Temp 2
BffrPtr       res       1                       ' Address of the intensity of the first channel 
BffrIdx       res       1                       ' Address of the intensity of the current channel to be compared
PxlCnt        res       1                       ' Number of pixels 
PxlIdx        res       1                       ' Pixels that have been processed
data          res       1                       ' Data to be sent to pixel (using 24 bits of the 32 available)                     
BitsCnt       res       1                       ' Number of bits that have been processed
PktDelay      res       1                       ' Pause duration for reset sequence
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