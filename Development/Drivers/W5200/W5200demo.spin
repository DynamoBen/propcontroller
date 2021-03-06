{{
  ************************************************* 
  *  PropController Ethernet to DMX(sACB Protocol)*
  *  Version: 1.0.0                               *
  *  See end of file for terms of use.            *
  *************************************************
  *    Uses Lightweight streaming protocol for    *
  *      transport of DMX512 over ACN (E1.31)     *
  *                                               *
  *                 04/26/2011                    *
  *         Author: Benjamin Yaroch               *
  *                                               *
  *************************************************
  

Change Log
--------------------
1.0.0 (04/26/2011) - Initial release
  
}}
CON

  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  'WIZ module I/O
  MISO          = 12            ' Master In Slave Out
  MOSI          = 15            ' Master Out Slave In
  SCS           = 13            ' Slave Select
  SCLK          = 14            ' Serial Clock            
  RST           = 11            ' Reset
  
  ' USB I/O
  USBtx         = 30            ' USB tx pin
  USBrx         = 31            ' USB rx pin

  ACNPort       = 5568          ' ACN Port Number  

VAR

  long  WantDebug
  
  byte  IP[4]                                           ' IP address 
  byte  Subnet[4]                                       ' Subnet Mask 
  byte  Gateway[4]                                      ' Gateway IP address
  byte  macAddr[6]
  byte  destIP[4]
  
  byte  rcvdpacket[648]                                 ' rcvd udp packet goes here for analysis

OBJ

  eth           : "W5200_Driver"                        'W5100 SPI Ethernet driver
  'eth          : "W5100_SPI_Driver"
  pst           : "Parallax Serial Terminal"            'Debug Serial Terminal  

PUB start  | idx, tmp, pktsize

'' Start ethernet

  pst.start(115_200)                                     ' Start serial debug (USB)
  waitcnt(((clkfreq / 1_000 * 200 - 3932) #> 381) + cnt) ' Wait 200ms for cog to start

  WantDebug:= 1                                         ' 1 = enable / 0 = disable

  ' IP
  IP[0]          := 192
  IP[1]          := 168
  IP[2]          := 1
  IP[3]          := 201
  
  ' Subnet
  Subnet[0]      := 255
  Subnet[1]      := 255
  Subnet[2]      := 255
  Subnet[3]      := 0
  
  ' Gateway 
  Gateway[0]     := 192 
  Gateway[1]     := 168 
  Gateway[2]     := 1 
  Gateway[3]     := 1

  ' MAC Address
  macAddr[0]     := $10
  macAddr[1]     := $00
  macAddr[2]     := $00
  macAddr[3]     := $00
  macAddr[4]     := $00
  macAddr[5]     := $01

  ' Assign socket to a universe
  destip[0]:= 239                                       ' Multicast Destination IP for E1.31         
  destip[1]:= 255
  destip[2]:= 0
  destip[3]:= 1                                         ' Sets Destination IP address (4th octet == universe #)
  

  ' Intilize SPI interface to W5100                                  
  eth.StartSPI(SCS, SCLK, MOSI, MISO, RST)  
  eth.InitAddresses(true,@macAddr,@gateway,@subnet,@ip) ' Intilize network addresses, and socket to universe assignments 

  readAddresses
  
  ' Output network settings via serial
  If WantDebug == 1 
    SerialDebug                                         ' Display the IP settings to the serial terminal
   
  ' Open socket for multicast and bind to universe
  eth.SocketOpen(0,eth#_MULTIM+eth#_UDPPROTO,ACNPort,ACNPort,@destIP)' Open socket for multicast and UDP read

  repeat                                                ' Loop forever
     'pktsize := eth.rxUDP(0,@rcvdpacket)               ' get packet size and copy packet to rcvdpacketarray
     eth.readSPI($0017, @rcvdpacket, 1)          
     pst.bin(rcvdpacket[0],8)
     pst.Str(string("/"))

PRI readAddresses

  eth.ReadMACaddress(@macAddr)
  eth.ReadGatewayAddress(@Gateway)
  eth.ReadSubnetMask(@Subnet)
  eth.ReadIPaddress(@IP)                              

PRI SerialDebug | okay, idx

'' Serial Debug to display network settings

                                                        ' If we chose Static
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