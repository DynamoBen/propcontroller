'' ******************************************************************************
'' * BAM (Bit Angle Modulation) RGB Driver Object                               *
'' * Copyright Feb 2011 Benjamin Yaroch                                         *                                                          *
'' * See end of file for terms of use                                           *
'' * Version 1.0a                                                                *
'' ******************************************************************************
'' 
'' 
'' 
''  Reference:
''  http://www.artisticlicence.com/WebSiteMaster/App%20Notes/appnote011.pdf
''  http://www.picbasic.co.uk/forum/showthread.php?t=7393
''  http://www.batsocks.co.uk/readme/art_bcm_1.htm
'' 
VAR

  long  cog

  long  ClockPin     
  long  DataPin
  long  StrobePin
  long  IntensBffrPtr
  long  CurveBffrPtr
  long  sCurvePtr

  byte  CurveBffr[48]                                 ' byte array to map a curve to a channel 

PUB start(_Clock, _Data, _Strobe, _IntensBffrPtr) : okay

'' Start RGB LED cog

  TIX_001 := (clkfreq / 100_000)                        ' timing for one "tick"

  ClockPin      := _Clock
  DataPin       := _Data
  StrobePin     := _Strobe
  IntensBffrPtr := _IntensBffrPtr                       ' set level pointer
  CurveBffrPtr  := @CurveBffr
  sCurvePtr     := @curve0

  okay  := (cog := cognew(@entry, @ClockPin) + 1)       ' start the rgb cog

PUB finalize

'' Stops serial RGB LED driver; frees a cog

  if cog
    cogstop(cog~ - 1)

PUB curveChnl(_chnl, _id)

  CurveBffr[_chnl-1] := _id

PUB curveSetAll(_id)  | idx

  bytefill(@CurveBffr, _id, 32)     

DAT
'-------------------------------------------------------------------------------------------------------------------
'Dimmer Curve(s)
'Name                     Intensity Values (255 entries required)
'------------------------------------------------------------------------------------------------------------------- 
curve0  byte  000,001,002,003,004,005,006,007,008,009,010,011,012,013,014,015   ' organized in blocks of 16                                   
        byte  016,017,018,019,020,021,022,023,024,025,026,027,028,029,030,031                                                                  
        byte  032,033,034,035,036,037,038,039,040,041,042,043,044,045,046,047                                                                 
        byte  048,049,050,051,052,053,054,055,056,057,058,059,060,061,062,063                                                                  
        byte  064,065,066,067,068,069,070,071,072,073,074,075,076,077,078,079                                  
        byte  080,081,082,083,084,085,086,087,088,089,090,091,092,093,094,095
        byte  096,097,098,099,100,101,102,103,104,105,106,107,108,109,110,111
        byte  112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127                             
        byte  128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143
        byte  144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159                              
        byte  160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175                
        byte  176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191                
        byte  192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207                              
        byte  208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223
        byte  224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239
        byte  240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255

curve1  byte  000,000,001,001,001,001,002,002,002,003,003,003,004,004,004,004
        byte  005,005,005,006,006,006,007,007,007,008,008,008,009,009,010,010
        byte  010,011,011,011,012,012,012,013,013,014,014,014,015,015,016,016
        byte  016,017,017,018,018,019,019,019,020,020,021,021,022,022,022,023
        byte  023,024,024,025,025,026,026,027,027,028,028,029,029,030,030,031
        byte  $1F,$20,$20,$21,$21,$22,$23,$23,$24,$24,$25,$25,$26,$27,$27,$28
        byte  $28,$29,$2A,$2A,$2B,$2B,$2C,$2D,$2D,$2E,$2F,$2F,$30,$31,$31,$32
        byte  $33,$33,$34,$35,$35,$36,$37,$37,$38,$39,$3A,$3A,$3B,$3C,$3D,$3D
        byte  $3E,$3F,$40,$40,$41,$42,$43,$44,$44,$45,$46,$47,$48,$49,$49,$4A
        byte  $4B,$4C,$4D,$4E,$4F,$50,$51,$51,$52,$53,$54,$55,$56,$57,$58,$59
        byte  $5A,$5B,$5C,$5D,$5E,$5F,$60,$61,$62,$63,$64,$65,$67,$68,$69,$6A
        byte  $6B,$6C,$6D,$6E,$6F,$71,$72,$73,$74,$75,$77,$78,$79,$7A,$7B,$7D
        byte  $7E,$7F,$81,$82,$83,$84,$86,$87,$89,$8A,$8B,$8D,$8E,$8F,$91,$92
        byte  $94,$95,$97,$98,$9A,$9B,$9D,$9E,$A0,$A1,$A3,$A4,$A6,$A7,$A9,$AB
        byte  $AC,$AE,$B0,$B1,$B3,$B5,$B6,$B8,$BA,$BB,$BD,$BF,$C1,$C3,$C4,$C6
        byte  $C8,$CA,$CC,$CE,$D0,$D1,$D3,$D5,$D7,$D9,$DB,$DD,$DF,$E1,$E3,$E6
                                       
DAT

                        org     0

Entry                   mov     t1, par                             
                        rdlong  t2, t1                  ' Get CLK Pin Number
                        mov     CLK, #1                 ' Load CLK Mask with %1
                        shl     CLK, t2                 ' Shift Left appropriate number of times
                                                         
                        add     t1, #4                   
                        rdlong  t2, t1                  ' Setup SerialIn Pin Mask
                        mov     SerialIn, #1             
                        shl     SerialIn, t2             
                                                         
                        add     t1, #4                  ' Increament address pointer by four bytes (1 long)
                        rdlong  t2, t1                  ' Setup Strobe Pin Mask
                        mov     Strobe, #1               
                        shl     Strobe, t2

                        add     t1, #4                  ' Get @ of the intensity of the first channel
                        rdlong  InstBffrPtr, t1

                        add     t1, #4                  ' Get @ of Curve Buffer
                        rdlong  crvBffrPtr, t1                 

                        andn    outa, CLK               ' Set CLK output to 0
                        andn    outa, SerialIn          ' Set SerialIn output to 0
                        andn    outa, Strobe            ' Set Strobe output to 0                        
                        or      dira, CLK               ' Set CLK pin to be an output                        
                        or      dira, SerialIn          ' Set SerialIn pin to be an output                        
                        or      dira, Strobe            ' Set Strobe pin to be an output
                       
:OuterLoop              mov     bitperiod, TIX_001      ' Start with 1 bit tick
                        shl     bitperiod, #8
                        
                        mov     bitmask, #%1000_0000    ' start with bit0
                        mov     BitsCnt, #8    
                        
:BitLoopSetup                                           ' We pass through this routine 8 times (once for each bit)
                        mov     InstBffrIdx, InstBffrPtr' Get @ of the intensity of the first channel
                        mov     Loop_Chnl, #48          ' Setup to loop through the 48 channels

:ChnlLoop                                               ' We pass through this routine 48 times (once for each channel)                        
                        rdbyte  dataval, InstBffrIdx    ' Get the current intensity to compare from main memory
                        'call   #dimCurve               ' Apply Dimmer Curve
                                                                   
                        test    dataval, bitmask  wc                              
                        muxc    outa, SerialIn          ' output the bit to data pin                    
                        
                        or      outa, CLK               ' Clock in the data
                        add     InstBffrIdx, #1         ' Increment to next intensity value
                        andn    outa, CLK               ' Clear the CLK
                        djnz    Loop_Chnl, #:ChnlLoop   ' Decrement Channel Loop and jump to InnerLoop if not 0

                        or      outa, Strobe            ' We clocked in all the data, Strobe to commit data
                        mov     bittimer, bitperiod     ' initialize bit timer  
                        andn    outa, Strobe            ' Clear the Strobe

                        add     bittimer, cnt           ' sync with system counter
                        waitcnt bittimer, bitperiod     ' finish bit, then reload
                        shr     bitperiod, #1           ' Decrement to next bit period
                        
                        shr     bitmask, #1
                        djnz    BitsCnt, #:BitLoopSetup ' update bit count

                        jmp     #:OuterLoop             ' done, Start Over 

'===================== Dimmer Curve Processing =========================                        
dimCurve               ' mov    t3,Loop_Cnt             ' Copy loop count into temp
                        sub     t3,#32                  ' Invert value
                        mov     t2,crvBffrPtr           ' Copy Curve buffer point into temp  
                        add     t2,t3                   ' Add Pointer to Index into Curve buffer                                          
                        rdbyte  crvVal,t2               ' Read the curve value from buffer location

:scurve                 cmp     crvVal,#1       wz      ' curve = 1
              if_nz     jmp     #dimCurve_ret
                             
                        mov     t2,scrvPtr              ' Copy Intensity to temp
                        add     t2,dataval              ' Index into curve buffer by adding to pointer address
                        rdbyte  dataval,t2              ' Read intensity from curve table, into value

dimCurve_ret            ret                             ' Done!
                        
                        fit     492  
' --------------------------------------------------------------------------------------------------

TIX_001                 long    0-0                     ' timing for bit0

t1                      res     1
t2                      res     1
t3                      res     1
bitperiod               res     1                       ' duration of current bit
bittimer                res     1
InstBffrIdx             res     1                       ' Address of the intensity of the current channel to be compared
InstBffrPtr             res     1                       ' Address of the intensity of the first channel
Loop_Chnl               res     1                       ' Channel Loop
CLK                     res     1                       ' CLK Pin Mask
SerialIn                res     1                       ' SerialIn Pin Mask
Strobe                  res     1                       ' Strobe Pin Mask
BitsCnt                 res     1
bitmask                 res     1

' Curve Variables

crvVal                  res     1                       ' Curve Buffer Value (read)
crvBffrPtr              res     1                       ' Curve Selection Buffer Pointer 
scrvPtr                 res     1                       ' sCurve Buffer Pointer
dataval                 res     1

                        fit     492
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
                