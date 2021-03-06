{{
  ************************************************* 
  *  PropController DMX 128 channel dimmer        *
  *  Version: 1.0.0                               *
  *  See end of file for terms of use.            *
  *************************************************
  *         DMX512 & 128 Channels of Dimmers      *
  *                                               *
  *                 10/14/2010                    *
  *          Author: Benjamin Yaroch              *
  *                                               *
  *************************************************
  
What is DMX?
  DMX (Digital Multiplexing) is a communications protocol created by the theatrical lighting industry
  to control stage lighting. DMX controls everything from dimmers to moving lights and has been the standard
  for lighting control for over two decades.

Why DMX?
  DMX is very robust and stable in harsh environments. DMX also allows you to control 512 dimmable channels
  and up to 32 devices all from one cable.
  
  In addition, because DMX is sent via RS-485/422 hardware it can travel up to 1500 meters (~4921 feet).
  
  Finally, because DMX is the worldwide lighting communications standard you can purchase any brand of DMX dimmers,
  connect them and be dimming within minutes.
  
  "Dimmers" are a type of control box that allows a person to plug in multiple lights (or strings of lights) and
  control their intensity using DMX. Each dimmer normally supports four separate channels, each channel capable of
  being set to a certain brightness.

  In addition to dimmers, DMX is a great option if you want to have other lighting effects in your display. DMX can
  be used to control DMX-capable moving lights, color changers, lasers, LED light bars and spot lights, fog machines,
  snow machines, and more.

  More information about DMX: http://www.christmasinshirley.com/wiki/index.php?title=DMX

The DMX standard is maintained by and can be purchased from ESTA:
  ESTA
  875 Sixth Avenue, Suite 1005
  New York, NY 10001
  +1-212-244-1505
  http://www.esta.org

PropController DMX Pinout
  DMX Shield    = RJ45 7 & 8 
  DMX +         = RJ45 1
  DMX -         = RJ45 2

Change Log
--------------------
1.0.0 (10/14/2010) - Initial release
1.0.1 (12/31/2010) - Zero'd intensity buffer to stop lights from going to full at boot
  
}}
CON

   _clkmode = xtal1 + pll16x
   _xinfreq = 5_000_000

  ' Dimmer Constant
  NumOfDimmers  = 128           ' Number of Dimmers (NOTE: multiples of 32 only!)   

  ' Status LED I/O
  BiColorRed    = 27            ' Beacon LED red pin                         
  BiColorGreen  = 26            ' Beacon LED green pin                         
  
  ' Dimmer I/O
  DIM0_CLK      = 1             ' Shift-out Dimmer Bank 1 (J1)                    
  DIM0_STB      = 2 
  DIM0_SI       = 3                                           
                                                        
  DIM1_CLK      = 5             ' Shift-out Dimmer Bank 2 (J2)
  DIM1_STB      = 6 
  DIM1_SI       = 7             
                                 
  DIM2_CLK      = 9             ' Shift-out Dimmer Bank 3 (J3)
  DIM2_STB      = 10             
  DIM2_SI       = 11            
                                 
  DIM3_CLK      = 13            ' Shift-out Dimmer Bank 4 (J4)
  DIM3_STB      = 14             
  DIM3_SI       = 15                                                                      
                                 
  ' DMX                          
  DMXrx         = 24            ' DMX receive
  DMXen         = 23            ' DMX Enable
  DMXtx         = 25            ' DMX transmit
  DMXtxLED      = 21            ' DMX transmit LED (RED)
  DMXrxLED      = 22            ' DMX receive LED (GREEN)

  ' USB I/O
  USBtx         = 30            ' USB tx pin
  USBrx         = 31            ' USB rx pin

VAR

  word  StartAddr                                       ' DMX start Address
  long  DMXptr                                          ' DMX buffer pointer
  byte  IntsBffr[NumOfDimmers]                          ' byte array with current intensity values of the channels                                                                                                             

OBJ

  dmx           : "jm_dmxin"                            ' DMXin data driver           
  dimmer[4]     : "Channel Driver.spin"                 ' Dimmer Bank driver (32 dimmed outputs)
  led           : "jm_bicolor"                          ' Bicolor LED driver

PUB Main | idx, ch0val

  StartAddr := 1                                        ' DMX Start Address goes here

  ' Set LED pins to outputs
  led.init(BiColorRed, BiColorGreen)                    ' Set LED pins
  led.yellow                                            ' Set both red and green to equal yellow

  ' Setup DMX input source for dimmer data
  dmx.init(DMXrx, DMXrxLED, 0, 0)
  DMXptr := dmx.address
  
  dira[DMXen]~~                                         ' Set pin as output to 75176 enable
  outa[DMXen]~                                          ' Set 75176 enable pin low for Rx

  bytefill(@IntsBffr, 0, NumOfDimmers)                  ' Zero intensity buffer to stop lights from going to full at boot 

  ' Dimmer Banks (32ch each == 128ch total)
  dimmer[0].Start(DIM0_CLK,DIM0_SI,DIM0_STB,@IntsBffr)                          ' Dimmer Bank 1 (1-32)
  dimmer[1].Start(DIM1_CLK,DIM1_SI,DIM1_STB,@IntsBffr+32)                       ' Dimmer Bank 2 (33-63)
  dimmer[2].Start(DIM2_CLK,DIM2_SI,DIM2_STB,@IntsBffr+64)                       ' Dimmer Bank 3 (64-95)
  dimmer[3].Start(DIM3_CLK,DIM3_SI,DIM3_STB,@IntsBffr+96)                       ' Dimmer Bank 4 (96-128)

  repeat
    if dmx.read(0) == 0                                 ' Ensure start code is still 0 (dimmer values)
      bytemove(@IntsBffr,DMXptr+StartAddr,NumOfDimmers) ' Copy slot values (intensity) to output buffer

    ch0val := IntsBffr[0]*100/255                       ' Calculate precentage for channel 0
    led.setlevels(ch0val,100 - ch0val)                  ' Apply intensity of chn 0 to Red and inverse value to green

DAT
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
}}     '  