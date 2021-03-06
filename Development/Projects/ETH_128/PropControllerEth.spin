{{
  ************************************************* 
  *  PropController Ethernet                      *
  *  Version: 1.1.1                               *
  *  See end of file for terms of use.            *
  *************************************************
  *                                               *
  *                 10/25/2011                    *
  *         Author: Benjamin Yaroch               *
  *                                               *
  *************************************************

Change Log
--------------------
1.0.0 (12/12/2010) - Initial release
1.1.0 (10/19/2011) - Added support for MAC address EEProm.
1.1.1 (10/26/2011) - Moved ACN code to its own object. Allows for easy protocol switching.
  
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

  'WIZ module I/O
  MISO          = 21            ' Master In Slave Out
  MOSI          = 22            ' Master Out Slave In
  SCS           = 23            ' Slave Select
  SCLK          = 24            ' Serial Clock            
  RST           = 25            ' Reset

  ' I2C
  i2cSCL        = 28            ' i2c Clock line (Data line/SDA is assumed to be 1 pin higher)
  eepromAddress = %1110_0000    ' Code/Storage EEProm
  macEEPROMAddr = %1010_0010    ' i2c address of MAC EEPROM     
  eepromAddr    = $7D01         ' First non-code Memory address in eeprom
  macAddrPtr    = $FA           ' Memory address of first MAC byte                                    

  'DMX I/O
  DMXtx         = 17            ' Transmit pin 
  DMXrx         = 19            ' Receive pin
  DMXctrl       = 18            ' Control pin; make high to transmit 
  DMXsbyte      = 0             ' Start code byte   
  DMXsize       = 513           ' Number of slots to transmit (2 to 513)
  DMXb2bt       = 35            ' Break-to-Break timing, 23ms to 44ms  
  
  ' USB I/O
  USBtx         = 30            ' USB tx pin
  USBrx         = 31            ' USB rx pin

  ' Sockets and Ports
  DHCPSocket    = 3             ' Socket for DHCP (3 == socket #4)

DAT
        HostName        byte "PropController", 0                
        mac             byte $10,$00,$00,$00,$00,$01    ' <-------- MAC address (MUST BE CHANGED FOR EACH DEVICE...
                                                        ' ...UNLESS EEPROM IS USED)
        
VAR                                                                                                     

  word  DMXstart                                        ' DMX start address
  long  DMXbffrptr                                      ' Pointer to DMX out buffer
  long  WantDHCP                                        ' True/False - Want DHCP?
  long  WantDebug                                       ' True/False - IP serial debug

  long  DMXptr
  
  long  LeaseTime                                       ' Duration of DHCP lease in seconds  
  byte  IP[4]                                           ' IP address 
  byte  Subnet[4]                                       ' Subnet Mask 
  byte  Gateway[4]                                      ' Gateway IP address
  byte  DomainName[64]                                  ' you may need to make this larger if you have a very long domain name
  byte  DHCP_Server[4]                                  ' DHCP server IP
  byte  DNS_Server[4]                                   ' DNS server IP
  byte  MACAddress[6]                                   ' MAC address for PropController
  
  byte  IntsBffr[NumOfDimmers]                          ' byte array with current intensity values of the channels
  
OBJ

  sACN          : "sACN"                                'W5100 SPI Ethernet driver (2 cogs)
  dimmer[4]     : "Channel Driver"                      'Dimmer Bank driver (32 dimmed outputs)                                                                                                                                                                      
  'led          : "jm_bicolor"                          'Bicolor LED driver
  i2c           : "I2C_driver"                          'i2c driver
  DHCP          : "DHCP"                                'DHCP driver
  PST           : "Parallax Serial Terminal"   
  
PUB start  | ch0val

'' Start ethernet PropController

  ' Configuration Settings
  DMXstart := 1                                        ' DMX Start Address for Dimmers
  WantDebug := false                                   ' true = yes / false = no
  WantDHCP := false                                    ' true = yes / false = no

  ' Set LED pins to outputs
  'led.init(BiColorRed, BiColorGreen)                   ' Set LED pins
  'led.yellow                                           ' Set both Red and Green = Yellow
  dira[BiColorGreen]~~

  bytefill(@IntsBffr, 0, NumOfDimmers)                  ' Zero intensity buffer to stop lights from going to full at boot

  ' setup i2c object
  i2c.Initialize(i2cSCL)         
  
  ' Dimmer Banks (32ch each = 128ch total)
  dimmer[0].Start(DIM0_CLK,DIM0_SI,DIM0_STB,@IntsBffr)   ' Dimmer Bank 1 (1-32)
  dimmer[1].Start(DIM1_CLK,DIM1_SI,DIM1_STB,@IntsBffr+32)' Dimmer Bank 2 (33-63)
  dimmer[2].Start(DIM2_CLK,DIM2_SI,DIM2_STB,@IntsBffr+64)' Dimmer Bank 3 (64-95)
  dimmer[3].Start(DIM3_CLK,DIM3_SI,DIM3_STB,@IntsBffr+96)' Dimmer Bank 4 (96-128)

  ' Network Settings:
  ' If DHCP is NOT used (WantDHCP:=0) the below values will be used.
  ' Otherwise if DHCP is used the below values will be overwritten by the DHCP server

  ' IP Address
  IP[0]          := 192
  IP[1]          := 168
  IP[2]          := 1
  IP[3]          := 200
  
  ' Subnet Mask
  Subnet[0]      := 255
  Subnet[1]      := 255
  Subnet[2]      := 255
  Subnet[3]      := 0
  
  ' Gateway IP
  Gateway[0]     := 192 
  Gateway[1]     := 168 
  Gateway[2]     := 1 
  Gateway[3]     := 200

  ' Intilize SPI interface to W5100
  initMACeeprom                                         ' Obtain Device MAC address

  ' Obtain IP via DHCP
  If WantDHCP == false                                  ' If we want DHCP try to get an IP 
    DHCPrequest

  ' Obtain IP via DHCP
  If WantDebug == false                                 ' If we want DHCP try to get an IP 
    Debug
        
  ' Intilize and Start sACN driver
  sACN.Start(SCS, SCLK, MOSI, MISO, RST, BiColorRed)
  sACN.initAddresses(@ip, @subnet, @gateway, @mac)
  sACN.openSACNsocket(0, 1)                             ' Open Socket for E1.31 for a specific DMX Universe
  DMXptr := sACN.rxbuffrptr

  ' Control Status LED, and capture sACN (E1.31) data
  repeat                                                ' Loop forever
    ' Read sACN (E1.31) data from remote buffer and store locally
    if sACN.read(0) == 0                                ' Ensure the DMX start code is 0 (dimmer values)
      bytemove(@IntsBffr,DMXptr+DMXstart,128)           ' Copy slot values (intensity) to output buffer
       
      'ch0val := IntsBffr[0]*100/255                     ' Calculate precentage based on channel 0 level
      'led.setlevels(ch0val,100-ch0val)                   ' Apply percentage to Red and inverse value to Green

PRI initMACeeprom | idx

  if i2c.devicePresent(i2cSCL,macEEPROMAddr) == true    ' Check if MAC EEPROM is present   
    repeat idx from 0 to 5      
      MACAddress[idx] := i2c.ReadLocation(i2cSCL, macEEPROMAddr, macAddrPtr+idx) ' Use MAC addr in EEProm
  else
    bytemove(@MACAddress, @mac, 6)                      ' No MAC EEProm use statically defined value above

PRI DHCPrequest

'' Obtain network setting via DHCP (not recommended because of periodic renewal)  

  ' Start DHCP, starts cog and opens socket #4               
  DHCP.Start(@HostName)                                 ' Provide the hostname for our device to object
  DHCP.SetMAC_Address(@MACAddress)                      ' Provide our MAC address

  repeat                             
    result := DHCP.DoDHCP(DHCPSocket, $4242_4242)       ' Try to get an IP address from server
    DHCP.GetIP(@IP)                                     ' What IP were we given?
    DHCP.GetGatewayIP(@Gateway)                         ' What Gateway IP were we given?
    DHCP.GetSubnetMask(@Subnet)                         ' What Subnet mask were we given?
    DHCP.GetDNSServer(@DNS_Server)                      ' What is the DNS Server IP?
    DHCP.GetDHCPServer(@DHCP_Server)                    ' What is the DHCP Server IP?
    bytemove(@DomainName, DHCP.GetDomainName, 64)       ' What is the Domain Name of the network?
    bytemove(@HostName, DHCP.GetHostName, 64)           ' What is the Host Name on the network?
    LeaseTime := DHCP.GetLeaseTime                      ' What is the duration of our IP lease?
       
    if result <> DHCP#SUCCESS                           ' Failed! 

  while result <> DHCP#SUCCESS                          ' Wait until we suceed

    ' Done with DHCP, stop it to free the cog that was used.               
  DHCP.Stop 

PRI Debug
  
  PST.Start(115_200)

  ' delay to allow time to enable PST
  waitcnt(((clkfreq / 1_000 * 2000 - 3932) #> 381) + cnt)
  
  PST.Home
  PST.Clear
  pst.RxFlush

  If WantDHCP == true                                       ' If we chose DHCP
    pst.Str(string("DHCP IP Settings", 13, 13))
    pst.RxFlush

    ' If result == Failure, then the W5100 is not configured and error is displayed
    if result <> DHCP#SUCCESS
      pst.Str(string("DHCP Failed"))

  else                                                  ' If we chose Static
    pst.Str(string("Static IP Settings", 13, 13))

  pst.Str(string("IP         : "))                      ' Print IP address
  pst.Dec(IP[0])
  pst.Str(string("."))
  pst.Dec(IP[1])
  pst.Str(string("."))
  pst.Dec(IP[2])
  pst.Str(string("."))
  pst.Dec(IP[3])
  pst.Str(string(13))
   
  pst.Str(string("Subnet mask: "))                      ' Print Subnet Mask
  pst.Dec(Subnet[0])
  pst.Str(string("."))
  pst.Dec(Subnet[1])
  pst.Str(string("."))
  pst.Dec(Subnet[2])
  pst.Str(string("."))
  pst.Dec(Subnet[3])
  pst.Str(string(13))
   
  pst.Str(string("Gateway IP : "))                      ' Pring Gateway IP address
  pst.Dec(Gateway[0])
  pst.Str(string("."))
  pst.Dec(Gateway[1])
  pst.Str(string("."))
  pst.Dec(Gateway[2])
  pst.Str(string("."))
  pst.Dec(Gateway[3])
  pst.Str(string(13))
   
  pst.Str(string("DNS Server : "))                      ' Print DNS Server IP
  pst.Dec(DNS_Server[0])
  pst.Str(string("."))                        
  pst.Dec(DNS_Server[1])
  pst.Str(string("."))
  pst.Dec(DNS_Server[2])
  pst.Str(string("."))
  pst.Dec(DNS_Server[3])
  pst.Str(string(13))
   
  pst.Str(string("DHCP Server: "))                      ' Print DHCP Server IP
  pst.Dec(DHCP_Server[0])
  pst.Str(string("."))
  pst.Dec(DHCP_Server[1])
  pst.Str(string("."))
  pst.Dec(DHCP_Server[2])
  pst.Str(string("."))
  pst.Dec(DHCP_Server[3])
  pst.Str(string(13))
   
  pst.Str(string("Domain Name: "))                      ' Print Domain name
  pst.Str(@DomainName)
  pst.Str(string(13))
   
  pst.Str(string("Lease Time : "))                      ' Print our lease duration (in seconds)
  pst.Dec(LeaseTime)
  pst.Str(string(13))

  pst.Str(string("MAC Address: "))                      ' Print DHCP Server IP
  pst.Hex(MACAddress[0],2)
  pst.Str(string(":"))
  pst.Hex(MACAddress[1],2)
  pst.Str(string(":"))
  pst.Hex(MACAddress[2],2)
  pst.Str(string(":"))
  pst.Hex(MACAddress[3],2)
  pst.Str(string(":"))
  pst.Hex(MACAddress[4],2)
  pst.Str(string(":"))
  pst.Hex(MACAddress[5],2)
  pst.Str(string(13))

  waitcnt(((clkfreq / 1_000 * 2000 - 3932) #> 381) + cnt)   
  
  pst.Stop
  
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
}}        