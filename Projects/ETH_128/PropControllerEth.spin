{{
  ************************************************* 
  *  PropController Ethernet (E1.31 Protocol)     *
  *  Version: 1.1.0                               *
  *  See end of file for terms of use.            *
  *************************************************
  *    Uses Lightweight streaming protocol for    *
  *      transport of DMX512 over ACN (E1.31)     *
  *                                               *
  *                 12/12/2010                    *
  *         Author: Benjamin Yaroch               *
  *                                               *
  *************************************************
  
Overview and Architecture:
  This standard can be used to transfer DMX512-A [DMX] packets of all START Codes via an ANSI
  E1.17 [ACN] supported network. A simple packet wrapper approach is used whereby the
  DMX512-A [DMX] data is encapsulated in a wrapper following the ACN packet structure. The
  ACN standard wrapper is carried in UDP [UDP] packets when used on TCP/IP networks. In the
  future, this use of the ACN wrapper and packet structure will also allow E1.31 to be carried over
  other networks supported by ACN.

  The wrapper is structured such that it is both compatible and meaningful to the ANSI E1.17 [ACN]
  standard. Readers are referred to the ANSI E1.17 [ACN] standard, paticularly the ACN
  Architecture and Device Management Protocol documents for more information. The Root
  Layer Protocol used in this standard is described in the ACN Architecture document.
  This standard uses multicast addressing to provide a mechanism to partition traffic for distinct
  universes of DMX512-A [DMX] data. Direct unicast of DMX512-A [DMX] data is also supported.

Classes of data appropriate for transmission:
  This standard, E1.31, is intended to define a method to carry DMX512-A [DMX] style data over IP
  Networks, including Ethernet IP Networks. It is designed to carry repetitive control data from one
  or more controllers to one or more receivers. This protocol is intended to be used to control
  dimmers, other lighting devices, and related nonhazardous effects equipment.

Protocol Packet Structure Summary:
  E1.31 is a protocol that lives within the suite of protocols defined by the ANSI E1.17 [ACN]
  standard. The ACN standard provides a method for layering protocols and for using a simple
  repeating message structure throughout. The lowest layer ACN protocol is called the Root Layer
  Protocol (RLP), which wraps E1.31 as well as other protocols such as Session Data Transport
  (SDT). It is not necessary to implement or understand these other protocols to use E1.31 to send
  DMX512 [DMX] data over ACN.

  E1.31 defines an outer layer repeating message structure called Protocol Data Unit (PDU) wrapper
  that specifies the sequence number of a packet and that carries a block of data (all PDUs carry a
  block of data). This data block contains a nested PDU containing a single message of the Device
  Management Protocol of ANSI E1.17 [ACN] to carry DMX512 [DMX] data. Each PDU contains a length
  field which equals the length of the entire PDU including its header and data block information.

This standard is maintained and can be purchased from ESTA:
  ESTA
  875 Sixth Avenue, Suite 1005
  New York, NY 10001
  +1-212-244-1505
  http://www.esta.org

Packet Layout in Buffer of W5100
  data[0]..[3] is the source IP address
  data[4]..[5] is the source port
  data[6]..[7] is the payload size
  data[8] starts here for the E1.31 payload

Change Log
--------------------
1.0.0 (12/12/2010) - Initial release
1.1.0 (10/19/2011) - Added support for MAC address EEProm. Optimized Serial Debug code.
  
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

  ' E1.31 Byte Ordering
  DataOffset    = 8             ' Number of bytes prior to sACN (E1.31) data
  PreambleSize  = 0             ' Preamble Size data location
  FramingVector = 40            ' Framing Vector data location
  DMPVector     = 117           ' DMP Vector data location
  PropertyVals  = 125           ' Property Values data location
  UniverseNum   = 113           ' Universe Number data location

  ' Sockets and Ports
  DHCPSocket    = 3             ' Socket for DHCP 
  ACNPort       = 5568          ' ACN Port Number
  
DAT
        RootLayer       byte $00,$10,$00,$00,$41,$53,$43,$2d,$45,$31,$2e,$31,$37,$00,$00,$00
        FrameLayer      byte $00,$00,$00,$02
        DMPLayer        byte $02,$A1,$00,$00,$00,$01
        HostName        byte "PropController",0        
        mac             byte $10,$00,$00,$00,$00,$01    ' <-------- Default MAC address (MUST BE CHANGED FOR EACH DEVICE, if not using EEProm)

VAR                                                                                                     

  byte  WantDHCP                                        ' Determines if DHCP or Static IP - 1 = DHCP / 0 = Static
  byte  WantDebug                                       ' Determines if Serial Debug is on - 1 = Enable / 0 = Disable
  word  DMXstart                                        ' DMX start address
  long  LeaseTime                                       ' Duration of DHCP lease in seconds
  long  DMXbffrptr
  
  byte  IP[4]                                           ' IP address 
  byte  Subnet[4]                                       ' Subnet Mask 
  byte  Gateway[4]                                      ' Gateway IP address
  byte  DomainName[64]                                  ' you may need to make this larger if you have a very long domain name
  byte  DHCP_Server[4]                                  ' DHCP server IP
  byte  DNS_Server[4]                                   ' DNS server IP
  byte  destIP[4]                                       ' Destination IP for udp multicast
  byte  destmac[6]                                      ' Destination MAC address for multicast
  byte  rcvdpacket[648]                                 ' rcvd udp packet goes here for analysis
  byte  macAddr[6]
  
  byte  IntsBffr[NumOfDimmers]                          ' byte array with current intensity values of the channels
  
OBJ

  eth           : "W5100_SPI_Driver"                    'W5100 SPI Ethernet driver
  dimmer[4]     : "Channel Driver"                      'Dimmer Bank driver (32 dimmed outputs)  
  DHCP          : "DHCP"                                'DHCP driver                                                                                                  
  led           : "jm_bicolor"                          'Bicolor LED driver
  pst           : "Parallax Serial Terminal"            'Debug Serial Terminal
  DMXout        : "jm_dmxout"                           'DMX out driver
  i2c           : "I2C_driver"                          'i2c driver
  
PUB start  | ch0val

'' Start ethernet PropController

  ' Configuration Settings
  DMXstart := 1                                         ' DMX Start Address for Dimmers
  WantDHCP := 1                                         ' 1 = yes / 0 = no
  WantDebug:= 1                                         ' 1 = enable / 0 = disable

  ' Set LED pins to outputs
  led.init(BiColorRed, BiColorGreen)                    ' Set LED pins
  led.yellow                                            ' Set both Red and Green = Yellow

  bytefill(@IntsBffr, 0, NumOfDimmers)                  ' Zero intensity buffer to stop lights from going to full at boot       
  
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
  Gateway[3]     := 1

  ' Destination IP         
  destIP[0]      := 192
  destIP[1]      := 168
  destIP[2]      := 1  
  destIP[3]      := 200


  ' setup i2c object
  i2c.Initialize(i2cSCL)            
  
  ' MAC Address 
  if i2c.devicePresent(i2cSCL,macEEPROMAddr) == true    ' Check if MAC EEPROM is present   
    ReadMACeeprom                                       ' Use MAC addr in EEProm
  else
    bytemove(@macAddr, @mac, 6)                         ' No MAC EEProm use statically defined value above

  ' Obtain IP via DHCP
  If WantDHCP == 1                                      ' If we want DHCP try to get an IP 
    DHCPrequest

  ' Output network settings via serial
  If WantDebug == 1 
    SerialDebug                                         ' Display the IP settings to the serial terminal

  ' Intilize DMX out
  DMXout.init(DMXtx, DMXctrl, DMXsbyte, DMXsize, DMXb2bt)
  DMXout.flushbuf                                       ' Zero out DMX data buffer
  DMXbffrptr := DMXout.buffrptr                         ' Grab DMX data buffer pointer
      
  ' Intilize SPI interface to W5100                                  
  eth.StartSPI(SCS, SCLK, MOSI, MISO, RST)  
  eth.InitAddresses(true,@macAddr,@gateway,@subnet,@ip) ' Intilize network addresses, and socket to universe assignments
    
  ' Intilize socket for sACN (E1.31)
  openSACNsocket(0, 1)                                  ' Open Socket for E1.31 for a specific DMX Universe
  
  ' Control Status LED, and capture sACN (E1.31) data
  repeat                                                ' Loop forever
    ch0val := IntsBffr[0]*100/255                       ' Calculate precentage based on channel 0 level
    led.setlevels(ch0val,100-ch0val)                    ' Apply percentage to Red and inverse value to Green

    ' Read sACN (E1.31) data from W5100 and store to buffer
    readSACNdata (0, 1, @IntsBffr, DMXstart, NumOfDimmers)                                                                            

PRI readSACNdata (_socket, _universe, _buffptr, _startaddr, _len) | idx, pktsize, validpkt 

'' Receive and qualify sACN (E1.31) then store DMX data       

  pktsize := eth.rxUDP(_socket,@rcvdpacket)             ' get packet size and copy packet to rcvdpacketarray     
                                           
  if (pktsize=>133) or (pktsize<=648)                   ' Check to see if packet len => 8+125
    validpkt := true                                    ' Preset Valid Packet to True
      
    repeat idx from 0 to 15                             ' Qualify Preamble Size, Postamble Size, ACN Packet ID
      if rcvdpacket[PreambleSize+DataOffset+idx] <> RootLayer[idx]
        validpkt := false                               ' Didn't match, set valid packet to False
   
    repeat idx from 0 to 3                              ' Qualify Framing Layer Vector
      if rcvdpacket[FramingVector+DataOffset+idx] <> FrameLayer[idx]
        validpkt := false                               ' Didn't match, set valid packet to False
        
    repeat idx from 0 to 5                              ' Qualify DMP Vector, Address & Data Type, First Property Addr, Address Incr
      if rcvdpacket[DMPVector+DataOffset+idx] <> DMPLayer[idx]
        validpkt := false                               ' Didn't match, set valid packet to False
          
    if validpkt == true                                 ' If all parts of the packet qualify
      ' Ensure Universe # in buffer matches what we asked for
      if rcvdpacket[UniverseNum+DataOffset]*256+rcvdpacket[UniverseNum+DataOffset+1] == _universe
        ' Make sure DMX Start Code = 0 (dimmer data)       
        if rcvdpacket[PropertyVals+DataOffset] == 0
          ' Move DMX data from the ethernet receive buffer to the intensity buffer
          bytemove(_buffptr,@rcvdpacket[PropertyVals+DataOffset+DMXstart],_len)
          ' Move DMX data from the ethernet receive buffer to the DMX out buffer   
          bytemove(DMXbffrptr,@rcvdpacket[PropertyVals+DataOffset],513)
             
PRI openSACNSocket(_socketNum, _universe)

'' Setup a socket on the W5100 for sACN (E1.31) communication

  ' Assign socket to a universe
  destIP[0]:= 239                                       ' Multicast Destination IP for E1.31         
  destip[1]:= 255
  destip[2]:= 0
  destip[3]:= _universe                                 ' Sets Destination IP address (4th octet == universe #)
  
  ' Assign MAC based on universe
  destmac[0]:= $01                                      ' The multicast dest mac adrs for E1.31                       
  destmac[1]:= $00
  destmac[2]:= $5E
  destmac[3]:= $7F
  destmac[4]:= $00
  destmac[5]:= _universe                                ' Sets Destination MAC address

  ' Open socket for multicast and bind to universe                                                       
  'eth.writeind (true,_socketNum*$100+$406,@destMAC,6)  ' Set Desitination MAC address in Destination hardware registry (for IGMP)
  eth.SocketOpen(_socketNum,eth#_MULTIM+eth#_UDPPROTO,ACNPort,ACNPort,@destIP)' Open socket for multicast and UDP read

PRI ReadMACeeprom | idx, ackbit

'' Read MAC EEPROM value to MAC variable 

  repeat idx from 0 to 5    
    macAddr[idx] := i2c.ReadLocation(i2cSCL, macEEPROMAddr, macAddrPtr+idx)
    
PRI DHCPrequest

'' Obtain network setting via DHCP

  eth.StopSPI                                           ' Done with ethernet driver, stop it to free the cog that was used.
  
   ' Start DHCP, starts cog and opens socket #4              
  DHCP.Start(@HostName)                                 ' Provide the hostname for our device to object
  DHCP.SetMAC_Address(@macAddr)                         ' Provide our MAC address

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

PRI SerialDebug | okay, idx

'' Serial Debug to display network settings
  
  okay := pst.start(19_200)                              ' Start serial debug (USB)
  waitcnt(((clkfreq / 1_000 * 200 - 3932) #> 381) + cnt) ' Wait 200ms for cog to start

  If WantDHCP == 1                                       ' If we chose DHCP
    pst.Str(string("DHCP IP Settings", 13, 13))
    pst.RxFlush

    ' If result == Failure, then the W5100 is not configured and error is displayed
    if result <> DHCP#SUCCESS
      pst.Str(string("Error: "))

      case result                                       ' Display error message 
        eth#_SOCK_CLOSED        : pst.Str(string("$00 - socket closed", 13, 13))                                        
        eth#_SOCK_INIT          : pst.Str(string("$13 - socket initalized", 13, 13))                                    
        eth#_SOCK_LISTEN        : pst.Str(string("$14 - socket listening", 13, 13))
        eth#_SOCK_ESTAB         : pst.Str(string("$17 - socket established", 13, 13)) 
        eth#_SOCK_UDP           : pst.Str(string("$22 - socket UDP open", 13, 13))
        OTHER :
          pst.Dec(result)
          pst.Str(string(13)) 
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
  pst.Hex(macAddr[0],2)
  pst.Str(string(":"))
  pst.Hex(macAddr[1],2)
  pst.Str(string(":"))
  pst.Hex(macAddr[2],2)
  pst.Str(string(":"))
  pst.Hex(macAddr[3],2)
  pst.Str(string(":"))
  pst.Hex(macAddr[4],2)
  pst.Str(string(":"))
  pst.Hex(macAddr[5],2)
  pst.Str(string(13))

  waitcnt(((clkfreq / 1_000 * 200 - 3932) #> 381) + cnt)' Wait 200ms to let things finish up
  pst.stop                                              ' Stop PST and free cog
 
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