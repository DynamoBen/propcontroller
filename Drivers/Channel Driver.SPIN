'' ******************************************************************************
'' * (Helix) Channel Driver Object                                              *
'' * Copyright May 2009 Gregory Bartlett                                        *
'' * Modified by: Benjamin Yaroch                                               *
'' * See end of file for terms of use                                           *
'' * Version 1.3                                                                *
'' ******************************************************************************
''
'' Revision Changes:
''   1.0 Jan 2009:  Initial Release
''   1.1 May 2009:  Added automatic 60Hz/50Hz selection
''   1.2 Sep 2009:  Changed both the Start and Stop method to properly stop the cog
''   1.3 Nov 2010:  Added the ability to assign clock, data, and strobe individually (BY)
''   1.4 Feb 2011:  Increased Duty Cycle to 99.9% (BY)
''
'' This object provides an interface between the main routine and the Serial In, Parallel Out (SIPO) shift registers that
'' drive 32 channels via Solid State Relays (SSR).  The SSRs are the interface between the controller and the lights.
'' The SIPO registers are four 74HC4094 and require a data input, clock input and strobe input.  
''
'' The light intensity of each channel can be independently controlled with 256 levels.  The object accomplishes this using
'' phase delay triggering of the SSRs.  0 intensity represents full off and 255 intensity represents full on.
'' The object is given the starting address of a 32 byte array that holds the current intensity values of each channel.
'' The main routine updates the values in this 32 byte array to represent the current intensities.
''
'' The SSRs are controlled with a current sink; therefore, an output of 1 will be off and an output of 0 will be on.
''
'' The object provides the different intensities by first synchronizing with the zero crossing of the AC power
'' line.  It then starts a countdown loop from 255 to 0, essentially dividing the half wave of the AC power into 256 time slots.
'' It compares the current loop value with the intensity values of each channel.  If the intensity value of the channel is equal to or
'' greater than the current loop value then it turns that channel on.  Once all 32 channels are compared with the current
'' loop value the object waits for the current time slot to complete.  It then decrements the current loop value and starts the
'' comparisons all over again.  Once the loop counts down to 0 the object turns the output of all of the channels to
'' off.  The SSRs automatically turn off at each zero crossing of the AC power.  The process then starts all over again.
'' 
'' This object is written in assembly language because it requires 8160 (32 * 255) comparisons be accomplished in 1/120 of a second.
''
'' this object provides these PUBLIC methods:
''  -> start - starts the object
''  -> stop - stops the object    

VAR
  long    cogon, cog
  long    temp1, temp2, temp3, temp4

PUB Start(_Clock, _Serial, _Strobe, AddChA_Inten) : okay
  Stop
  temp1 := _Clock
  temp2 := _Serial
  temp3 := _Strobe
  temp4 := AddChA_Inten
  okay  := (cog := cognew(@entry, @temp1) + 1)
      
PUB Stop

' Stop Channel Driver  frees cog

  if cog
    cogstop(cog~ - 1)
    

DAT

                        org
                                
entry                   waitpeq ZeroXingPin, ZeroXingPin        'Wait for the zero crossing of the AC power
                        mov     Time, cnt                       'Set up and wait for a short delay to make sure
                        add     Time, Pause                     'Zero X-ing has cleared
                        waitcnt Time, Pause
                        
                        waitpeq ZeroXingPin, ZeroXingPin        'Wait for the second zero crossing of the AC power
                        mov     t1, cnt                         'Store the current count
                        mov     Time, t1                        'Set up for a short delay to make sure
                        add     Time, Pause                     '0 X-ing has cleared
                        waitcnt Time, Pause
                        
                        waitpeq ZeroXingPin, ZeroXingPin        'Wait for the third zero crossing of the AC power
                        mov     t2, cnt                         'Store the current count
                        cmp     t2, t1 wc                       'Check to see if t2 is less than t1
              if_c      jmp     #entry                          'If t2 < t1 then cnt rolled over so check again
                        sub     t2, t1                          'Calculate the number of clock cycles between 0 X-ings
                        cmp     t2, MidPnt wc                   'Compare the count with the MidPnt count
              if_c      mov     Delay, F60Hz                    'If less than MidPnt count then it is a 60Hz mains
              if_nc     mov     Delay, F50Hz                    'If greater than MidPnt then it is a 50Hz mains                        
                        
                        mov     t1, par                         'Get @CLK Pin Number
                        rdlong  t2, t1                          'Get CLK Pin Number
                        mov     CLK, #1                         'Load CLK Mask with %1
                        shl     CLK, t2                         'Shift Left appropriate number of times

                        add     t1, #4
                        rdlong  t2, t1                          'Setup SerialIn Pin Mask
                        mov     SerialIn, #1
                        shl     SerialIn, t2

                        add     t1, #4                          'Increament address pointer by four bytes (1 long)
                        rdlong  t2, t1                          'Setup Strobe Pin Mask
                        mov     Strobe, #1
                        shl     Strobe, t2
                                                               
                        add     t1, #4                          'Get @ of the intensity of the first channel
                        rdlong  ChA_Inst, t1
                        
                        andn    outa, CLK                       'Set CLK output to 0
                        or      dira, CLK                       'Set CLK pin to be an output
                        andn    outa, SerialIn                  'Set SerialIn output to 0
                        or      dira, SerialIn                  'Set SerialIn pin to be an output
                        andn    outa, Strobe                    'Set Strobe output to 0
                        or      dira, Strobe                    'Set Strobe pin to be an output
:OuterLoop
                        waitpeq ZeroXingPin, ZeroXingPin        'Wait for the zero crossing of the AC power
                        mov     Time, cnt                       'Setup for a short delay after the zero crossing
                        add     Time, ZeroXingDelay                                             
                        mov     Loop_Cnt, #255                  'Setup loop to count down from 255 to 0
                        waitcnt Time, Delay                     'Wait for end of short delay and setup Time for the next time slice (1/255 of 1/120 or 1/100 second)
                        
:InnerLoopSetup                                                 'We pass through this routine 255 times      
                        mov     ChX_Inst, ChA_Inst              'Get @ of the intensity of the first channel
                        mov     Loop_Chnl, #32                  'Setup to loop through the 32 channels
                        
:InnerLoop                                                      'We pass through this routine 32 times
                        rdbyte  t1, ChX_Inst                    'Get the current intensity to compare from main memory
                        cmp     t1, Loop_Cnt  wc                'Check for intensity => loop count
                        muxc    outa, SerialIn                  'If => then C will be 0 and turn on the channel
                        or      outa, CLK                       'Clock in the data
                        add     ChX_Inst, #1                    'Get @ of next intensity value 
                        andn    outa, CLK                       'Clear the CLK
                        djnz    Loop_Chnl, #:InnerLoop          'Decrement Channel Loop and jump to InnerLoop if not 0
                        
                        or      outa, Strobe                    'Strobe in the date
                        waitcnt Time, Delay                     'Wait for the end of this time slice
                        andn    outa, Strobe                    'Clear the Strobe
                        djnz    Loop_Cnt, #:InnerLoopSetup      'Decrement the Intensity Loop and jump to InnerLoopSetup if not 0
                        mov     Loop_Chnl, #32                  'Turn all of the channels off
:ClearSIPO
                        or      outa, SerialIn                  'By setting their value to 1
                        or      outa, CLK
                        andn    outa, CLK
                        djnz    Loop_Chnl, #:ClearSIPO
                        or      outa, Strobe
                        andn    outa, Strobe
                        jmp     #:OuterLoop                     'Jump to OuterLoop to wait for the next zero crossing 
                                


{
############################ Defined data #############################
}

ZeroXingPin             long    |<0             'Zero Xing Pin is P0
ZeroXingDelay           long    $0F             'Zero Xing Delay of 100 cycles $64 (changed to 15 cycles)
F60Hz                   long    $A33            'Loop Delay for a 60Hz AC mains (80Mhz/(120 X-ings/Sec)/(255 levels))*99.9% duty cycle (~2611)   
F50Hz                   long    $C3E            'Loop Delay for a 50Hz AC mains (80Mhz/(100 X-ings/Sec)/(255 levels))*99.9% duty cycle (~3134)
MidPnt                  long    $B3095          'Mid Point # clock cycles between a 60Hz and 50Hz mains (733,333)
Pause                   long    $28B0A          'Pause to make sure zero xing has cleared. (166,666)

{
############################# I/O masks ###############################
}

CLK                     res     1               'CLK Pin Mask
SerialIn                res     1               'SerialIn Pin Mask
Strobe                  res     1               'Strobe Pin Mask

{
########################### Other Variables ###########################
}

Delay                   res     1               'Loop Delay variable
t1                      res     1               'Temp 1
t2                      res     1               'Temp 2
Loop_Cnt                res     1               'Loop Counter
Loop_Chnl               res     1               'Channel Loop
ChX_Inst                res     1               'Address of the intensity of the current channel to be compared
ChA_Inst                res     1               'Address of the intensity of the first channel
Time                    res     1               'Value of the next cnt delay

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