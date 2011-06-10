{{    
  ************************************************* 
  *  sACN (E1.31) Protocol Object                 *
  *  Version: 1.0.0                               *
  *  Author: Benjamin Yaroch                      *
  *  Mofications: Joshua Moyerman                 *
  *  See end of file for terms of use.            *
  *************************************************
  *                                               *
  *   Uses Lightweight streaming protocol for     *
  *      transport of DMX512 over ACN (E1.31)     *
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
-----------------------
1.0.0   (12/12/2010) - Initial release
1.0.1:  (06/06/2011) - Code moved to its own object JM
1.0.2:  (06/06/2011) - Restructured data flow and usage BY

}}
CON

  NumOfDimmers = 2052           ' Number of Dimmers (NOTE: multiples of 513)

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
        
        mac             byte $10,$00,$00,$00,$00,$01    ' <---------------- MAC address (MUST BE CHANGED FOR EACH DEVICE)
        
VAR

  long  stack[100]                                      ' Sets up a stack space for a Cog(processor)
 
  'Ethernet Configuration Variables
  byte  IP[4]                                           ' IP address 
  byte  Subnet[4]                                       ' Subnet Mask 
  byte  Gateway[4]                                      ' Gateway IP address
  byte  destIP[4]                                       ' Destination IP for udp multicast
  byte  destMAC[6]                                      ' Destination MAC address for multicast
  byte  rcvdpacket[648]                                 ' rcvd udp packet goes here for analysis
  byte  useDHCP                                         ' Use DHCP?  
  word  socketUniverse[4]                               ' Table to determine what universe is in each socket
  
  'Logging Variables
  long  failedPackets[4]                                ' Stores total number of failed packets

  ' DMX data buffers 
  byte  DMXbuffr[NumOfDimmers]                          ' DMX input buffer

OBJ
  eth   : "W5100_SPI_Driver"                            ' W5100 Ethernet Chip Driver

PUB start(_SCS, _SCLK, _MOSI, _MISO, _RST) : okay | idx

''Start E1.31 Driver (will setup W5100 chip with data provided)

  ' Load Default IP values, Parent to load custom values via, InitAddresses
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
  destIP[3]      := 100

' Grab MAC addr from EEProm?

  ' Intilize SPI interface to W5100                                  
  eth.StartSPI(_SCS, _SCLK, _MOSI, _MISO, _RST)  
  eth.InitAddresses(true,@mac,@gateway,@subnet,@ip)     ' Intilize network addresses, and socket to universe assignments

  cognew(readData, @stack)                              ' Starts readData in a new Cog, uses @stack
     
PUB readData | idx

  repeat                                                ' Loop forever
    ' Read sACN (E1.31) data from W5100 and store to buffer
    repeat idx from 0 to 3
      if socketUniverse[idx] > 0 
        readSACNdata (idx, socketUniverse[idx])

PUB setPortInput(_port, _universe) | universeLow, universeHigh

'' Setup a socket on the W5100 for sACN (E1.31) communication

  'universeLow := _universe                             ' Universe Low Byte
  'universeHigh := _universe                            ' Universe High Byte 

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
  destmac[5]:= _port                                    ' Sets Destination MAC address

  ' Open socket for multicast and bind to universe                                                       
  'eth.writeind (true,_socketNum*$100+$406,@destMAC,6)  ' Set Desitination MAC address in Destination hardware registry (for IGMP)
  eth.SocketOpen(_port,eth#_MULTIM+eth#_UDPPROTO,ACNPort,ACNPort,@destIP)' Open socket for multicast and UDP read

  socketUniverse[_port] := _universe
                                                        

PRI readSACNdata (_port, _universe) | idx, pktsize, validpkt                               

'' Receive and qualify sACN (E1.31) then store DMX data       

  pktsize := eth.rxUDP(_port,@rcvdpacket)               ' get packet size and copy packet to rcvdpacketarray     
                                           
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
          ' Move DMX data from the ethernet receive buffer to the intensity buffer
          bytemove(@DMXbuffr,@rcvdpacket[PropertyVals+DataOffset],513)
    else
      failedPackets[_port]++

PUB bffrptr(_socket) : buffrloc

'' Returns buffer location address of dmx buffer used for socket

  buffrloc := @DMXbuffr
  
PUB InitAddresses

  eth.InitAddresses(true,@mac,@gateway,@subnet,@ip)     ' Intilize network addresses, and socket to universe assignments

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