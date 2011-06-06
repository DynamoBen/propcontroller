{{    
  ************************************************* 
  *  E1.31 Protocol Object                        *
  *  Version: 1.0.0                               *
  *  Copyright(c) 2011, Joshua Moyerman           *
  *  See end of file for terms of use.            *
  *************************************************
  *      ArtNet Node Functions and Commands       *
  *                                               *
  *                  05/05/09                     *
  *         Author: Joshua Moyerman               *
  *     Modeled after: ArtNet by B. Yaroch        *
  *               EthtoDMX by B. Yaroch           *
  *                                               *
  *************************************************

Change Log
-----------------------
1.0.0: Initial Release of Object

}}

CON
''Ethernet Definitions
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

DAT     'once for all instances
        RootLayer       byte $00,$10,$00,$00,$41,$53,$43,$2d,$45,$31,$2e,$31,$37,$00,$00,$00
        FrameLayer      byte $00,$00,$00,$02
        DMPLayer        byte $02,$A1,$00,$00,$00,$01
        HostName        byte "PropController",0
        
        mac             byte $10,$00,$00,$00,$00,$01    ' <---------------- MAC address (MUST BE CHANGED FOR EACH DEVICE)
VAR     'once for each instance
'Ethernet Configuration Variables
  byte  IP[4]                                           ' IP address 
  byte  Subnet[4]                                       ' Subnet Mask 
  byte  Gateway[4]                                      ' Gateway IP address
  byte  destIP[4]                                       ' Destination IP for udp multicast
  byte  destMAC[6]                                      ' Destination MAC address for multicast
  byte  rcvdpacket[648]                                 ' rcvd udp packet goes here for analysis
  byte  useDHCP                                         ' Use DHCP?
'Logging Variables
  byte  goodPackets[4]                                     ' Stores total number of successful packets
  byte  failedPackets[4]                                   ' Stores total number of failed packets
'Output Variables
  long DMXbffrPtr[4]                                    ' Pointer to location of locations for dmx buffers to be stored                        
                  
OBJ
  eth   : "W5100_SPI_Driver"       'W5100 Ethernet Chip Driver

PUB setOutputLocation (bffrptr)
  bytemove(@DMXbffrPtr, @bffrptr, 4)
PUB start (_SCS, _SCLK, _MOSI, _MISO, _RST, _numSockets, _default) : okay | idx
''Start E1.31 Driver (will setup W5100 chip with data provided)
  
  if _default == true
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
    

  ' Intilize SPI interface to W5100                                  
  eth.StartSPI(_SCS, _SCLK, _MOSI, _MISO, _RST)  
  eth.InitAddresses(true,@mac,@gateway,@subnet,@ip)     ' Intilize network addresses, and socket to universe assignments

  'Open number of sockets requested by user
  repeat idx from 0 to (_numSockets - 1)  
    openSACNsocket(idx, idx+1)                          ' Open Socket for E1.31 for a specific DMX Universe

  readData
     
PRI readData | idx

  repeat                                                ' Loop forever
    ' Read sACN (E1.31) data from W5100 and store to buffer
    repeat idx from 0 to 3  
      readSACNdata (idx, idx+1, DMXbffrPtr[idx])

PRI openSACNSocket(_socketNum, _universe)

'' Setup a socket on the W5100 for sACN (E1.31) communication

  ' Assign socket to a universe
  destip[0]:= 239                                       ' Multicast Destination IP for E1.31         
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

'PUB setIP
'PUB setSubnet
'PUB setGateway
'PUB setDestIP
'PUB setDestMAC
PRI readSACNdata (_socket, _universe, _buffptr) | idx, pktsize, validpkt                   

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
      if rcvdpacket[PropertyVals+DataOffset] <> $DD                  
        if rcvdpacket[UniverseNum+DataOffset]*256+rcvdpacket[UniverseNum+DataOffset+1] == _universe
          ' Move DMX data from the ethernet receive buffer to the intensity buffer
          bytemove(_buffptr,@rcvdpacket[PropertyVals+DataOffset],513)
          ' Increment good packet counter
          goodPackets[_socket]++
    else
      failedPackets[_socket]++