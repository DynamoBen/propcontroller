{{    
  ************************************************* 
  *  sACN (E1.31) Protocol Object                 *
  *  Version: 1.0.0                               *
  *  Author: Benjamin Yaroch                      *
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
1.0.0   (10/25/2011) - Initial release

}}
CON

  ' E1.31 Byte Ordering
  DataOffset      = 8           ' Number of bytes prior to sACN (E1.31) data
  PreambleSizePtr = 0           ' Preamble Size data location
  FramingVectorPtr= 40          ' Framing Vector data location
  DMPVectorPtr    = 117         ' DMP Vector data location
  PropertyValsPtr = 125         ' Property Values data location
  UniverseNumPtr  = 113         ' Universe Number data location

  ' Sockets and Ports                                                  
  ACNPort         = 5568        ' ACN Port Number

DAT   
        RootLayer       byte $00,$10,$00,$00,$41,$53,$43,$2d,$45,$31,$2e,$31,$37,$00,$00,$00
        FrameLayer      byte $00,$00,$00,$02
        DMPLayer        byte $02,$A1,$00,$00,$00,$01  
        
VAR

  long  cog                                             ' cog flag/id
  long  stack[100]                                      ' Sets up stack space for a Cog(processor)   

  'WIZ module I/O
  long  SCS                                             ' Slave Select
  long  SCLK                                            ' Serial Clock
  long  MOSI                                            ' Master Out Slave In 
  long  MISO                                            ' Master In Slave Out
  long  RST                                             ' Reset
  long  LED

  'Network Settings
  long  ipPTR                                           ' IP address 
  long  subnetPTR                                       ' Subnet Mask 
  long  gatewayPTR                                      ' Gateway IP address
  long  macPTR
  byte  destIP[4]                                       ' Destination IP for udp multicast
  byte  destMAC[6]                                      ' Destination MAC address for multicast

  'Data Buffers
  byte  packetBuff[648]                                 ' UDP packet buffer to rx and tx
  byte  DMXinBuff[2052]                                 ' Array for DMX values read (4 universes)
  byte  DMXoutBuff[2052]                                ' Array for DMX values to be sent (4 universes) 

OBJ

  W5100 : "W5100_SPI_Driver"                            ' W5100 Ethernet Chip Driver

PUB initAddresses (_ipPTR, _subnetPTR, _gatewayPTR, _macPTR)

'' Setup network interface.

  longmove(@ipPTR, @_ipPTR, 4)

  W5100.InitAddresses(true, macPTR, gatewayPTR, subnetPTR, ipPTR) ' Intilize network addresses, and socket to universe assignments           
  
PUB start(_SCS, _SCLK, _MOSI, _MISO, _RST, _LED) : okay | idx

''Start E1.31 Driver (will setup W5100 chip with data provided)

  longmove(@SCS, @_SCS, 6)

  ' Intilize SPI interface to W5100                                  
  W5100.StartSPI(SCS, SCLK, MOSI, MISO, RST)      

  okay := cog := cognew(readSACNdata(1, 1), @stack)           ' Update Channels Method to its own cog

PUB stop

  if cog
    cogstop(cog~ - 1)
  W5100.StopSPI

PUB read(Channel) : level

'' Return value of channel requested

   level := DMXinBuff[Channel]

PUB write(channel, level)

'' Set value of channel requested

  DMXoutBuff[channel] := level

PUB flushbuf

  '' Flushes DMX buffer to zeroes

  bytefill(@dmxoutBuff, 0, 2052)

PUB rxbuffrptr

  return @DMXinBuff

PUB txbuffrptr

  return @DMXoutBuff
  
PUB openSACNsocket(_socketNum, _universe)

'' Setup a socket on the W5100 for sACN (E1.31) communication

  ' Assign socket to a universe
  destIP[0]:= 239                                       ' Multicast Destination IP for E1.31         
  destIP[1]:= 255
  'destIP[2]:= _universe>>8
  destIP[2]:= 0             
  destIP[3]:= _universe                                 ' Sets Destination IP address (4th octet == universe #)
  
  ' Assign MAC based per universe
  destMAC[0]:= $01                                      ' The multicast dest mac adrs for E1.31 (01:00:5e:$7F:xx:xx)                       
  destMAC[1]:= $00
  destMAC[2]:= $5E
  destMAC[3]:= $7F
  destMAC[4]:= _universe>>8    
  destMAC[5]:= _universe                                ' Sets Destination MAC address

  ' Open socket for multicast and bind to universe                                                    
  W5100.writeSPI (true,_socketNum*$100+$406,@destMAC,6)   ' Set Desitination MAC address in Destination hardware registry (for IGMP)
  W5100.SocketOpen(_socketNum,W5100#_MULTIM+W5100#_UDPPROTO,ACNPort,ACNPort,@destIP)' Open socket for multicast and UDP read  

PRI readSACNdata (_port, _universe) | idx, pktsize, validpkt   

'' Receive and qualify sACN (E1.31) then store DMX data
'' Port = 1-4

  dira[LED]~~                                           ' Set LED I/O pin to output              

  repeat
    outa[LED]~  
    pktsize := W5100.rxUDP(_port-1,@packetBuff)           ' get packet size and copy packet to ethernet buffer
                 
    if (pktsize=>133) or (pktsize<=648)                   ' Check to see if packet len => 8+125
        
      validpkt := true                                    ' Preset Valid Packet to True
        
      repeat idx from 0 to 15                             ' Qualify Preamble Size, Postamble Size, ACN Packet ID
        if packetBuff[PreambleSizePtr+DataOffset+idx] <> RootLayer[idx]
          validpkt := false                               ' Didn't match, set valid packet to False
     
      repeat idx from 0 to 3                              ' Qualify Framing Layer Vector
        if packetBuff[FramingVectorPtr+DataOffset+idx] <> FrameLayer[idx]
          validpkt := false                               ' Didn't match, set valid packet to False
          
      repeat idx from 0 to 5                              ' Qualify DMP Vector, Address & Data Type, First Property Addr, Address Incr
        if packetBuff[DMPVectorPtr+DataOffset+idx] <> DMPLayer[idx]
          validpkt := false                               ' Didn't match, set valid packet to False
            
      if validpkt == true                                 ' If all parts of the packet qualify
        outa[LED]~~
        ' Ensure Universe # in packet matches what we asked for
        if packetBuff[UniverseNumPtr+DataOffset]*256+packetBuff[UniverseNumPtr+DataOffset+1] == _universe
          ' Make sure DMX Start Code = 0 (dimmer data)
          if packetBuff[PropertyValsPtr+DataOffset] == 0   
             ' Move DMX data from the ethernet receive buffer to the DMX data buffer
             bytemove(@DMXinBuff, @packetBuff[PropertyValsPtr+DataOffset], 513)

PRI writeSACNdata (_port, _universe) | pktsize

'' Transmit sACN (E1.31) from DMX data buffer
'' Port = 1-4, Universe = 1 - 16

  pktsize := 133
  
  bytemove(@packetBuff[0], @ipPTR, 4) 'Could this be a longmove?
  wordmove(@packetBuff[4], ACNPort, 1)
  wordmove(@packetBuff[6], pktsize, 1)  
  bytemove(@packetBuff[PreambleSizePtr+DataOffset], @RootLayer, 26)             ' Preamble (16 bytes), Framing Layer Vector (4 bytes), DMP Vector (6 bytes)                                                                           
  wordmove(@packetBuff[UniverseNumPtr+DataOffset+1], _universe, 1)              ' DMX Universe (2 bytes)
  longmove(@packetBuff[PropertyValsPtr+DataOffset], 513*_universe+@DMXoutBuff, 128) '  DMX data from the ethernet tx buffer (513 bytes)

  W5100.txUDP(_port-1,@packetBuff)                      ' Send assembled packet

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