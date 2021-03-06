'' ******************************************************
'' * LPD6803 Pixel Driver Object                        *
'' * Copyright Feburary 2011 Benjamin Yaroch            *
'' * See end of file for terms of use                   *
'' * Version 1.0                                        *
'' ******************************************************
''
'' LPD6803 is a 3 channel constant-current driver and grey-level modulate output
''
'' Bit Timing Sequence
'' A. First shift in 32bit 0 as start frame, then shift in all data frame, start frame and data
'' frame both are shift by high-bit, every data is input on DCLK rising edge.
'' B. The first data frame is corresponding LED light nearest from shift-in polar, its format
'' includes 1bit as start 1 plus 3 groups 5bits grey level.
'' C. Turn shift in all data, add append pulse of corresponding point, new data start valid.
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
  long  BitTime                 ' Delay between bits as they are sent

PUB Start(_CLK, _SDI, _IntnsBffr, _pixelCnt) : okay
    
  CLK_pin      := _CLK                                  ' Clock pin
  DATA_pin     := _SDI                                  ' Data pin
  IntnsBffr    := _IntnsBffr                            ' Intensity buffer pointer
  PixelCnt     := _pixelCnt                             ' Number of pixels
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
              rdlong    BitDelay,t1             ' Bring over value of BitTime
                                                 
              ' Setup I/O                        
              andn      outa, CLKmask           ' Preset CLK output to LOW
              or        dira, CLKmask           ' Set CLK pin to be an OUTPUT
              andn      outa, DATAmask          ' Preset SerialIn output to LOW
              or        dira, DATAmask          ' Set SerialIn pin to be an OUTPUT              

              ' Send 32 bit start frame
strtFrame     mov       data, #0                ' Load zeros for start frame
              mov       BitsCnt, #32            ' Setup to loop through 32bits, all zero'd
              call      #BitLoop                ' send it

              mov       BffrIdx, BffrPtr        ' Get pointer location for the first channel in Intns buffer
              mov       PxlIdx, PxlCnt          ' Set intial Pixel Index count              

              ' Send Data frames (1 per pixel)
PixelLoop     rdbyte    t1, BffrIdx             ' Read Red Intensity byte from buffer
              shr       t1, #3                  ' Drop three bits from value
              add       data, t1                ' Add Intensity to variable 
              add       data, #32               ' Add Start bit
              shl       data, #5                ' Make room for the next data byte 

              add       BffrIdx, #1             ' Read Green Intensity byte from buffer 
              rdbyte    t1, BffrIdx             ' Make room for the next data byte
              shr       t1, #3                  ' Drop three bits from value                        
              add       data, t1                ' Add Intensity to variable
              shl       data, #5                ' Make room for the next data byte
              
              add       BffrIdx, #1             ' Read Blue Intensity byte from buffer                      
              rdbyte    t1, BffrIdx             ' Make room for the next data byte
              shr       t1, #3                  ' Drop three bits from value                           
              add       data, t1                ' Add Intensity to variable
              shl       data, #16               ' Move to MSB of Long

              mov       BitsCnt, #16            ' Setup to loop through level 16 bits
              call      #BitLoop                ' send it
                                 
              add       BffrIdx, #1             ' update buffer pointer
              djnz      PxlIdx, #PixelLoop      ' update Pixel Index count
              jmp       #strtFrame              ' Send next start frame
                                                 
' -----------------------------
'    Shift out pixel data
' -----------------------------                  
'
              ' Shift out each bit starting with bit 31   
BitLoop       shl       data, #1           wc   ' move bit31 to C         
              muxc      outa, DATAmask          ' output the bit to data pin

              mov      t2, cnt                  ' Setup for a bit delay 
              add      t2, BitDelay             ' Add counter to delay
              waitcnt  t2, BitDelay             ' Wait for the end of this delay
              or        outa, CLKmask           ' CLK output to HIGH

              mov      t2, cnt                  ' Setup for a bit delay 
              add      t2, BitDelay             ' Add counter to delay
              waitcnt  t2, BitDelay             ' Wait for the end of this delay                                                                              
              andn      outa, CLKmask           ' CLK output to LOW
                                                                                                
              djnz      BitsCnt, #BitLoop       ' update bit count                                                                                                                                                                                                                                                                                                                    
                                                 
BitLoop_ret   ret        


' I/O masks 
CLKmask       res       1                       ' CLK Pin Mask
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