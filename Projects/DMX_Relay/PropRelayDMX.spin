{{
  ************************************************* 
  *  PropRelay - DMX                              *
  *  Version: 1.0.0                               *
  *  See end of file for terms of use.            *
  *************************************************
  *             DMX512 & 16 Relays                *
  *                                               *
  *                 12/19/2011                    *
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
                                                                                           
The DMX standard is maintained by and can be purchased from ESTA:
  ESTA
  875 Sixth Avenue, Suite 1005
  New York, NY 10001
  +1-212-244-1505
  http://www.esta.org

Change Log
--------------------
1.0.0 (12/19/2011) - Initial release
  
}}
CON

   _clkmode = xtal1 + pll16x
   _xinfreq = 5_000_000

  ' Dimmer Constant
  NumOfRelays   = 16           ' Number of Relays   

  ' LED I/O
  BiColorRed    = 27            ' Status LED red pin                         
  BiColorGreen  = 26            ' Status LED green pin                                                            
                                 
  ' DMX                          
  DMXrx         = 24            ' DMX receive
  DMXen         = 23            ' DMX Enable
  DMXtx         = 25            ' DMX transmit

  ' USB I/O
  USBtx         = 30            ' USB tx pin
  USBrx         = 31            ' USB rx pin

  'Address I/O
  Addr_256      = 20
  Din           = 21
  Clock         = 22
  ShLoad        = 23
  
VAR

  word  dmxStart                                        ' DMX start Address
  long  DMXptr                                          ' DMX buffer pointer
  byte  IntsBffr[NumOfRelays]                           ' byte array with current intensity values of the channels                                                                                                             

OBJ

  dmx   : "jm_dmxin"                                    ' DMXin data driver

PUB Main | idx, ch0val


  ' Setup LED pins
  dira[BiColorRed]~~                                    
  dira[BiColorGreen]~~                                  

  ' Setup DMX input source for dimmer data
  ReadAddress
  dmx.init(DMXrx, BiColorGreen, dmxStart, 0)
  DMXptr := dmx.address
  dira[DMXen]~~                                         ' Set pin as output to 75176 enable
  outa[DMXen]~                                          ' Set 75176 enable pin low for Rx

  ' Zero intensity buffer to stop lights from going to full at boot
  bytefill(@IntsBffr, 0, NumOfRelays)                                                                                     

  ' Setup Relay I/O pins
  dira[0..15]~~                                         ' Set pin as output to 75176 enable
  outa[0..15] := 0                                      ' Preset relays to off
  
  repeat
    if dmx.read(0) == 0                                 ' Ensure start code is still 0 (dimmer values)
      bytemove(@IntsBffr, DMXptr+dmxStart, NumOfRelays) ' Copy slot values (intensity) to output buffer

    UpdateRelays

PRI UpdateRelays   | idx

  repeat idx from 0 to NumOfRelays-1
    if IntsBffr[idx] > 127                              ' Greater than 50% intensity
      outa[idx]~~                                       ' Set pin High
    else
      outa[idx]~                                        ' Set pin low

PRI ReadAddress : value | dmxStart_LSB, InBit

  dira[ShLoad]~~                                        ' Set the Load pin to output
  outa[ShLoad]~                                         ' TOGGLE the load pin OFF
  waitcnt(1000 + cnt)                                   ' Allow pin to settle
  
  outa[ShLoad]~~                                        ' TOGGLE the Load pin ON
  dira[ShLoad]~                                         ' Set Data pin to output

  dira[Clock]~~                                         ' SET the Clock pin to output
  outa[Clock]~                                          ' TOGGLE the Clock pin OFF

  repeat 8                                              ' REPEAT for8 Bits                                                                
    InBit:=ina[Din]                                     ' READ the Data pin (bit value 1 or 0)
    dmxStart_LSB := (dmxStart_LSB << 1) + InBit         ' SHIFT Left and Add to the dmxStart_LSB of the Next Bit
    outa[Clock] := 1                                    ' TOGGLE the Clock pin ON
    outa[Clock] := 0                                    ' TOGGLE the Clock pin OFF
    waitcnt(1000 + cnt)                                 ' Allow pin to settle  

  if Addr_256 == 0                                      ' If dipswitch 256 is set...
    dmxStart := dmxStart_LSB + 256                      ' ...add 256 to the other dip switch values
  else
    dmxStart := dmxStart_LSB                            ' If dipswitch 256 is NOT set just go with other dipswitch values

  ' Trap DMX bad address settings
  if dmxStart == 0                                      ' If no dipswitches are set...
    dmxStart := 1                                       ' ...assume a starting address of 1
    
  if dmxStart > 512-NumOfRelays                         ' If dipswitches are beyond the number of relays...
    dmxStart := 1                                       ' ...assume a starting address of 1

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