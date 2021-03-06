'' ******************************************************
'' * TM1804 Pixel 4 Strand High Speed Driver Object     *
'' * Copyright Feburary 2011 Benjamin Yaroch            *
'' * See end of file for terms of use                   *
'' * Version 1.0                                        *
'' ******************************************************
''
'' 
'' Revision Changes:
''   1.0 Mar 2011:  Initial Release
''
'' Assumes an 80Mhz clock
'' Assumes the 4 strands are on adjacent pins starting with _Dpin
'' Assumes intensity data is stored in this order:
'' address      B1              Blue value of first pixel
'' address+1    G1              Green value of first pixel
'' address+2    R1              Red value of first pixel
'' address+3    B2
'' address+4    G2
'' address+5    R2
'' address+6    B3
'' address+7    G3
'' address+8    R3
'' address+9    B4
'' address+10   G4
'' address+11   R4
''
VAR

  long  cog

  long  DATA_pin                ' Data pin for pixel string
  long  IntnsBffr               ' Intensity data buffer pointer
  long  PixelCnt                ' Number of pixels in string
  long  PacketDelay             ' Clock ticks for inter-packet idle time

PUB Start(_Dpin, _IntnsBffr, _pixelCnt) : okay

  if ((_Dpin < 0) or (_Dpin > 28))
    okay := false
    return
    
  DATA_pin     := _Dpin                                 ' Data pin                 
  IntnsBffr    := _IntnsBffr                            ' Intensity buffer pointer 
  PixelCnt     := _pixelCnt                             ' Number of pixels   
  PacketDelay  := (clkfreq/100_000)                     ' Duration of Packet delay (10us)

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
              mov       DATA1mask, #1             
              shl       DATA1mask, t2
              mov       DATA2mask, DATA1mask
              shl       DATA2mask, #1
              mov       DATA3mask, DATA2mask
              shl       DATA3mask, #1
              mov       DATA4mask, DATA3mask
              shl       DATA4mask, #1             
                                                 
              add       t1, #4                  ' Increment address pointer by four bytes
              rdlong    BffrPtr, t1             ' Get @ of the intensity of the first channel 
                                                 
              add       t1, #4                  ' Increment address pointer by four bytes                   
              rdlong    PxlCnt, t1              ' Get Number of Pixels to be controlled & mutliple by 3 (RGB)
                                                 
              add       t1,#4                   ' Increment address pointer by four bytes
              rdlong    PktDelay,t1             ' Bring over value of PacketDelay

              ' Setup I/Os
              andn      outa, DATA1mask          ' Preset SerialIn output to LOW
              or        dira, DATA1mask          ' Set SerialIn pin to be an OUTPUT
              andn      outa, DATA2mask          ' Preset SerialIn output to LOW
              or        dira, DATA2mask          ' Set SerialIn pin to be an OUTPUT
              andn      outa, DATA3mask          ' Preset SerialIn output to LOW
              or        dira, DATA3mask          ' Set SerialIn pin to be an OUTPUT
              andn      outa, DATA4mask          ' Preset SerialIn output to LOW
              or        dira, DATA4mask          ' Set SerialIn pin to be an OUTPUT

              ' Inter packet delay (10us)   
idle          andn      outa, DATA1mask         ' Force Data line LOW
              andn      outa, DATA2mask         ' Force Data line LOW
              andn      outa, DATA3mask         ' Force Data line LOW
              andn      outa, DATA4mask         ' Force Data line LOW

              mov       t1, cnt                 ' Setup for a interframe delay (reset)
              add       t1, PktDelay            ' Add counter to delay
              waitcnt   t1, PktDelay            ' Wait for the end of this delay

              mov       BffrIdx, BffrPtr        ' Get pointer location for the first channel in Intns buffer
              mov       PxlIdx, PxlCnt          ' Set intial Pixel Index count

              ' Send Data frames (1 per pixel)
PixelLoop     rdlong    data1, BffrIdx          ' data1:  B2 R1 G1 B1
              add       BffrIdx, #4             ' Increment buffer pointer
              mov       data2, data1            ' data2:  B2 R1 G1 B1
              rdlong    t1, BffrIdx             ' t1:  G3 B3 R2 G2
              add       BffrIdx, #4             ' Increment buffer pointer
              shl       data1, #8               ' data1: R1 G1 B1 00 (Finished)
              rdlong    t2, BffrIdx             ' t2:  R4 G4 B4 R3
              mov       data3, t1               ' data3:  G3 B3 R2 G2
              shr       data2, #16              ' data2:  00 00 B2 R1
              shl       t1, #16                 ' t1:  R2 G2 00 00
              add       data2, t1               ' data2:  R2 G2 B2 R1 (Finished)
              mov       data4, t2               ' data4:  R4 G4 B4 R3 (Finished)
              shr       data3, #8               ' data3:  00 G3 B3 R2
              shl       t2, #24                 ' t2:  R3 00 00 00
              add       data3, t2               ' data3:  R3 G3 B3 R2 (Finished)

              call      #txbits                 ' Send it

              add       BffrIdx, #4             ' Increment buffer pointer
              djnz      PxlIdx, #PixelLoop      ' Loop until transmitted all nodes
              jmp       #idle                   ' Pull lines idle

                                                 
' -----------------------------
'     Shift out pixel data
' -----------------------------                  
'
txbits        mov       BitsCnt, #24            ' Setup to loop through the 24 bits per color

              ' Shift out each bit starting with bit 31   
BitLoop       or        outa, DATA1mask         ' CLK output to High
              nop                               ' Kill 4 clock cycles
              or        outa, DATA2mask         ' CLK output to High
              nop                               ' Kill 4 clock cycles
              or        outa, DATA3mask         ' CLK output to High
              nop                               ' Kill 4 clock cycles
              or        outa, DATA4mask         ' CLK output to High
              
              shl       data1, #1        wc     ' Move bit 31 to C
              muxc      outa, DATA1mask         ' Output the bit to the data pin
              shl       data2, #1        wc     ' Move bit 31 to C
              muxc      outa, DATA2mask         ' Output the bit to the data pin
              shl       data3, #1        wc     ' Move bit 31 to C
              muxc      outa, DATA3mask         ' Output the bit to the data pin
              shl       data4, #1        wc     ' Move bit 31 to C
              muxc      outa, DATA4mask         ' Output the bit to the data pin
              
              nop                               ' Kill 4 clock cycles

              andn      outa, DATA1mask         ' CLK output Low
              nop                               ' Kill 4 clock cycles
              andn      outa, DATA2mask         ' CLK output Low
              nop                               ' Kill 4 clock cycles
              andn      outa, DATA3mask         ' CLK output Low
              nop                               ' Kill 4 clock cycles
              andn      outa, DATA4mask         ' CLK output Low

              djnz      BitsCnt, #BitLoop       ' Loop until all bits transmitted
              
txbits_ret    ret              
              

' I/O masks 
DATA1mask     res       1                       ' Data Pin Masks
DATA2mask     res       1
DATA3mask     res       1
DATA4mask     res       1

' Other Variables  
t1            res       1                       ' Temp 1
t2            res       1                       ' Temp 2
BffrPtr       res       1                       ' Address of the intensity of the first channel 
BffrIdx       res       1                       ' Address of the intensity of the current channel to be compared
PxlCnt        res       1                       ' Number of pixels 
PxlIdx        res       1                       ' Pixels that have been processed
data1         res       1                       ' Data to be sent to pixel (using 24 bits of the 32 available)
data2         res       1                       ' Data to be sent to pixel (using 24 bits of the 32 available)
data3         res       1                       ' Data to be sent to pixel (using 24 bits of the 32 available)
data4         res       1                       ' Data to be sent to pixel (using 24 bits of the 32 available)                     
BitsCnt       res       1                       ' Number of bits that have been processed
PktDelay      res       1                       ' Pause duration for reset sequence
                                           
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