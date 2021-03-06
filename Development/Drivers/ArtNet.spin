{{    
  ************************************************* 
  *  ArtNet II Protocol Object                    *
  *  Version: 1.0.2                               *
  *  Copyright(c) 2009, Benjamin Yaroch           *
  *  See end of file for terms of use.            *
  *************************************************
  *      ArtNet Node Functions and Commands       *
  *                                               *
  *                  05/05/09                     *
  *         Author: Benjamin Yaroch               *
  *                                               *
  *     Art-Net Designed by and Copyright         *
  *        Artistic Licence (UK) Ltd.             *
  *                                               *
  *************************************************

  Overview:
Art-Net is an Ethernet protocol based on the TCP/IP protocol suite. Its purpose is to allow transfer
of large amounts of data, typically DMX512, over a wide area using standard networking technology.
Art-Net is primarily intended to operate over 10BaseT networks.
The latest revision of the protocol implements a number of new features and also simplifies the
data transfer mechanism. The changes are all based on feed back from manufacturers who are using
the protocol.

  Limitations:
A theoretical limit of 255 universes of DMX512 exists in this specification. However a simplistic data
rate comparison (DMX runs at 250KBaud, 10BaseT at 10MBaud) suggests a maximum of 40 universes
of DMX is the limit. Art-Net uses a simple delta transmission compression technique that will provide
about 40 universes. If an installation of more than say 30 universes is contemplated, then it is
necessary to use the unicast features of Art-Net II and 100BaseT or better physical layer. If this is
done the number of universes limit becomes purely related to the network bandwidth.

  Protocol Operation:
A Node operates in one mode, each Node having a unique IP address derived from its Ethernet MAC
address. The UDP port used as sources and destinations is 0x1936.
NOTE: See "Art-Net II Ethernet Communciation Standard" for further details on IP addressing.

Packet Layout in Buffer of W5100
  data[0]..[3] is the source IP address
  data[4]..[5] is the source port
  data[6]..[7] is the payload size
  data[8] starts here for the ArtNet payload
                                  
Change Log
--------------------
1.0.0 (5/06/09) - Initial release
1.0.1 (9/18/09) - Moved variables to DAT
1.0.2 (10/22/09) - Optimized packet creation, to speed things up

}}
CON

  UBEA          = 0             ' User Bios Extension Area firmware version 
  ProtVer       = 14            ' Art-Net II protocol revision number node supports. 
  
  ' Opcodes                       
  Poll          = $2000         ' ArtPoll packet, no other data is contained in this UDP packet.
  PollReply     = $2100         ' ArtPollReply packet contains device status information.
  Output        = $5000         ' ArtDmx packet contains DMX512 information for a single Universe.
  Address       = $6000         ' ArtAddress packet contains remote programming information for a Node.
  Input         = $7000         ' ArtInput packet contains enable - disable data for DMX inputs.
  TodRequest    = $8000         ' ArtTodRequest packet is used to request a Table of Devices (ToD) for RDM discovery.
  TodData       = $8100         ' ArtTodData packet is used to send a Table of Devices (ToD) for RDM discovery.
  TodControl    = $8200         ' ArtTodControl packet is used to send RDM discovery control messages.
  Rdm           = $8300         ' ArtRdm packet is used to send all non discovery RDM messages.
  RdmSub        = $8400         ' ArtRdmSub packet is used to send compressed, RDM Sub-Device data.
  VideoSetup    = $a010         ' ArtVideoSetup packet contains video screen setup information for nodes that implement...
                                ' ...the extended video features.
  VideoPalette  = $a020         ' ArtVideoPalette packet contains colour palette setup information for nodes that implement
                                ' the extended video features.
  VideoData     = $a040         ' ArtVideoData packet contains display data for nodes that implement the extended video features.
  FirmwareMaster= $f200         ' ArtFirmwareMaster packet is used to upload new firmware or firmware extensions to the Node.
  FirmwareReply = $f300         ' ArtFirmwareReply packet is returned by the node to acknowledge receipt of an ArtFirmwareMaster packet.
  IpProg        = $f800         ' ArtIpProg packet is used to reprogramme the IP, Mask and Port address of the Node.
  IpProgReply   = $f900         ' ArtIpProgReply packet is returned by the node to acknowledge receipt of an ArtIpProg packet.
  Media         = $9000         ' ArtMedia packet is Unicast by a Media Server and acted upon by a Server.
  MediaPatch    = $9100         ' ArtMediaPatch packet is Unicast by a Server and acted upon by a Media Server.
  MediaControl  = $9200         ' ArtMediaControl packet is Unicast by a Server and acted upon by a Media Server.
  MediaContrlReply = $9300      ' ArtMediaControlReply packet is Unicast by a Media Server and acted upon by a Server.

  ' Opcodes "Factory" Initialisation
  MacMaster     = $f000         ' ArtMacMaster packet is used to program the Node's MAC address, Oem device type and ESTA...
                                ' ...manufacturer code. This is for factory initialisation of a Node is not to be used by applications.
                                ' MAC address is recorded to EEPROM.
  MacSlave      = $f100         ' ArtMacSlave packet is returned by the node to acknowledge receipt of an ArtMacMaster packet.

  ' Node Report Codes
  RcDebug       = $0000         ' Booted in debug mode (Only used in development)
  RcPowerOK     = $0001         ' Power On Tests successful
  RcPowerFa     = $0002         ' Hardware tests failed at Power On
  RcSocketWr1   = $0003         ' Last UDP from Node failed due to truncated length, most likely caused by a collision.
  RcParseFail   = $0004         ' Unable to identify last UDP transmission. Check OpCode and packet length.
  RcUdpFail     = $0005         ' Unable to open Udp Socket in last transmission attempt
  RcShNameOk    = $0006         ' Confirms that Short Name programming via ArtAddress, was successful.
  RcLoNameOk    = $0007         ' Confirms that Long Name programming via ArtAddress, was successful.
  RcDmxError    = $0008         ' DMX512 receive errors detected.
  RcDMXUdpFull  = $0009         ' Ran out of internal DMX transmit buffers.
  RcDmxRxFull   = $000a         ' Ran out of internal DMX Rx buffers.
  RcSwitchErr   = $000b         ' Rx Universe switches conflict.
  RcConfigErr   = $000c         ' Product configuration does not match firmware.
  RcDmxShort    = $000d         ' DMX output short detected. See GoodOutput field.
  RcFirmwareFail= $000e         ' Last attempt to upload new firmware failed.
  RcUserFail    = $000f         ' User changed switch settings when address locked by remote programming. User changes ignored.

  ' Style Codes
  StNode        = $00           ' DMX to/from ArtNet Device
  StServer      = $01           ' Lighting console
  StMedia       = $02           ' Media Server
  StRoute       = $03           ' Network routing device
  StBackup      = $04           ' Backup device
  StConfig      = $05           ' Configuration or diagnostic tool

  ' DMX settings
  DMXPacketSize = 513           ' Standard packet size for DMX data

  ' ArtNet Byte Ordering     
  DataOffset    = 8             ' Number of bytes prior to sACN (E1.31) data
  
  BUFFER_SIZE = 640   

DAT
        
  ' General Node Information
  Version       word    $0001                           ' This Node's Firmware Version, change with each revision
  ID            byte    "Art-Net",0                     ' Art-Net packet ID -- DO NOT ALTER!!!!

  ' Node Configuration Settings (some/all of these may end up in EEProm)
  OEMCode       word    $0010                                                   ' Development OEM code. (Not to be used in production products)
  ESTAMan       word    $0000                                                   ' Esta Manufacter Code.
     
  Status1       byte    %11100000                                               ' General Status Register
  ShortName     byte    "PropNode",0,0,0,0,0,0,0,0,0,0                          ' 18 bytes                        
  LongName      byte    "PropNode (ArtNet/DMX) - v1.0",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 '64 bytes   
  NodeReport    byte    "PropNode booted and operating correctly.",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0      '64 bytes
  PortType      byte    %10000000,%10000000,%10000000,%10000000                 ' Port type for each port
  GoodInput     byte    %00000000,%00000000,%00000000,%00000000                 ' Input status for each node port
  GoodOutput    byte    %10000000,%10000000,%10000000,%10000000                 ' Output status for each node port
  Swin          byte    0, 1, 2, 3                                              ' Input universe address for each node port
  Swout         byte    0, 1, 2, 3                                              ' Output universe address for each node port
  SwVideo       byte    0                                                       ' Show video local/ethernet
  SwMacro       byte    %00000000                                               ' Macro key inputs, trigger values
  SwRemote      byte    %00000000                                               ' Remote trigger inputs, trigger values
  Style         byte    StNode                                                  ' Equipment style of device (see constants)

  ' Node Ethernet Settings (provided by parent)
  ip            byte    0, 0, 0, 0                      'Ethernet IP address    <--------------Must be changed for each node!
  subnet        byte    255, 0, 0 ,0                    'Subnet Mask
  port          word    $1936                           'UDP Port for Art-Net protocol            
  dest_ip       byte    0, 255, 255, 255                'Destination IP is the address of the computer we will communicate with.
  gateway       byte    0, 0, 0, 0                      'Default gateway

' ***************************************
' **    MAC Address Vars / Defaults    **
' ***************************************
  ' ** This is the default MAC address used by this driver.  The parent object
  '    can override this by passing a pointer to a new MAC address in the public
  '    start() method.  It is recommend that this is done to provide a level of
  '    abstraction and makes tcp stack design easier.
  ' ** This is the ethernet MAC address, it is critical that you change this
  '    if you have more than one device using this code on a local network.
  ' ** If you plan on commercial deployment, you must purchase MAC address
  '    groups from IEEE or some other standards organization.
        
 eth_mac      byte      $10, $00, $00, $00, $00, $01
 
VAR

  ' ArtNet Variables
  byte  TalkToMe                ' TalkToMe, sets behavior of node     
  word  NumPorts                ' Number of input/output ports (max. 4 ports)
  word  SubSwitch               ' Subnet switch -- low nibble of swtich affects high nibble of Swin and Swout                            
  long  socket                  ' W5100 socket
  long  ArtDetected             ' ArtNet packet detected True/False
  long  opcode                  ' Opcode defines the class of data

  ' DMX buffer variables
  byte  sequence                                                                              
  byte  Inputs[4]
  byte  DATAbuffrptr[4]         ' Hub data buffer locations array, Pointers from caller object

  ' Ethernet variables
  byte buffer[BUFFER_SIZE]
                                                   
OBJ

  eth   : "W5100_SPI_Driver"       ' instantiate the W5100 driver

PUB start (_MISO, _MOSI, _SCLK, _SCS, _RST, _NumPorts, _socket) : okay               

'' Start ArtNet driver - starts ethernet, and serial drivers

  NumPorts := _NumPorts                                 ' Set the number of ports on node   
  socket   := _socket

  'Destination IP is IP we are sending to
  dest_ip[0] := 192
  dest_ip[1] := 168
  dest_ip[2] := 1
  dest_ip[3] := 138

  'Fill out the rest of the arrays needed for intialization.
  'W5100 IP address.
  ip[0] := 192
  ip[1] := 168
  ip[2] := 1
  ip[3] := 205

  'Gateway.
  gateway[0] := 192
  gateway[1] := 168
  gateway[2] := 1
  gateway[3] := 1

  'Subnet.
  subnet[0] := 255
  subnet[1] := 255
  subnet[2] := 255
  subnet[3] := 0
                                                        ' start the W5100 driver
  eth.StartSPI(_SCS, _SCLK, _MOSI, _MISO, _RST)                                 
                                                        ' Initialize gateway, subnet mask, ip, MAC addr
  eth.InitAddresses(true, @eth_mac, @gateway, @subnet, @ip)
                                                        ' Open UDP socket to IP                      
  eth.SocketOpen(socket, eth#_UDPPROTO, PORT, PORT, @dest_ip)

  ReadData
  
PUB ReadData  | packetSize 

  repeat
    packetSize := eth.rxUDP(socket, @buffer[0])         ' copy packet data to buffer and get packet size  
    
    if (packetSize > 0) 'and (packetSize =< BUFFER_SIZE)

      if STRCOMP(@buffer+DataOffset, @ID)               ' Compare header to 'Art-Net' 
      
        OpCode := buffer[DataOffset+8] + buffer[DataOffset+9] << 8
      
      'if ProtVer == buffer[DataOffset+11] + buffer[DataOffset+10] << 8 ' Does the Inbound Protocol Version match, if so carry on

          case OpCode                                   ' Branch based on OpCode 
                                                         
            Output:                                      
              ArtDMXrx                                  ' Inbound Art-Net DMX packet
                                                         
            Input:                                       
              ArtInput                                  ' Inbound ArtInput packet
              ArtPollReply                              ' Respond with ArtPollReply                                                                                                                                         
                                                         
            Poll:
              ArtPoll                                   ' Inbound ArtPoll packet looking for nodes
              ArtPollReply                              ' Send an 'ArtPollReply' in response to this ArtPoll                                               
                                                         
            Address:                                     
              ArtAddress                                ' Inbound ArtAddress packet   
              ArtPollReply                              ' Respond with ArtPollReply                    
                                                         
            IpProg:                                      
              ArtIpProg                                 ' Inbound IpProg packet 
              ArtIpProgReply                            ' Respond with ArtIpProgReply                                                                                                    
                                                         
            FirmwareMaster:                              
              ArtFirmwareMaster                         ' Inbound Load Firmware packet 
              ArtFirmwareReply                          ' Respond to sender with ArtFrimwareReply
                                                         
PUB stop

'' Stop ethernet, and serial driver - frees the cogs

  eth.SocketClose(0)                                    ' Close any active sockets
  eth.stopSPI                                           ' Stop the ethernet driver

PRI ArtPoll | idx

'' The ArtPoll packet is used to discover the presence of other Servers, Nodes and Media Servers. The
'' ArtPoll packet is only sent by a Server. Nodes respond to the packet, see ArtPollReply.

  TalkToMe := buffer[DataOffset+13]                      ' TalkToMe - Set behavior or node:
  
  if (TalkToMe & |< 0) >> 0 == 1                         ' Read bit 0 == 1 if reply is to server IP (unicast)

  else                                                   ' If bit 0 == 0 if reply is broadcast

  if (TalkToMe & |< 1) >> 1 == 1                         ' Read bit 1 == 1 then Node sends reply when it needs to

  else                                                   ' bit 1 == 0 then Node only replies when polled
                                                         
                                                         ' bit 2-7 are not used

PRI sendPacket(_payloadSize, packetBuffer)

  bytemove(@buffer[DataOffset], @ID, 8)                  ' copy the header 'Art-Net ' into the buffer
                               
  buffer[0] := dest_IP[0]
  buffer[1] := dest_IP[1]
  buffer[2] := dest_IP[2]
  buffer[3] := dest_IP[3]
  buffer[4] := port.byte[1]
  buffer[5] := port.byte[0]
  buffer[6] := _payloadSize.byte[1]
  buffer[7] := _payloadSize.byte[0]

  eth.txUDP(socket, @buffer)

PRI ArtPollReply | idx

''A device, in response to a Server's ArtPoll, sends the ArtPollReply. The "TalkToMe" field in the
''ArtPoll packet can modify this default mode of operation. This packet is also broadcast by all Art-
''Net devices on power up.
  
  buffer[DataOffset+8] := PollReply                      ' OpPoll Artnet Poll Request
  buffer[DataOffset+9] := PollReply>>8
  
  bytemove(@buffer[DataOffset+10],@ip,4)                 ' Node's IP address
  
  buffer[DataOffset+14] := PORT                          ' ArtNet Socket
  buffer[DataOffset+15] := PORT>>8
  
  bytemove(@buffer[DataOffset+16],@Version,2)            ' Node's Firmware Version
  
  buffer[DataOffset+18] := SubSwitch.byte[1]             ' Node's Subnet Switch:
  buffer[DataOffset+19] := SubSwitch.byte[0]             '      0 - not used
                                                         '      From switch on front panel (0-15)
  bytemove(@buffer[DataOffset+20],@OEMcode,2)            ' OEM value
  
  buffer[DataOffset+22] := UBEA                          ' User Bios Extension Area (UBEA) firmware version
  buffer[DataOffset+23] := Status1                       ' General Status Register
  buffer[DataOffset+24] := EstaMan                       ' ESTA Manufacturer code (zero for now)
  buffer[DataOffset+25] := EstaMan>>8
  
  bytemove(@buffer[DataOffset+26],@ShortName,strsize(@ShortName)) ' Short Name (zero terminated)
  bytemove(@buffer[DataOffset+44],@LongName,strsize(@LongName)) ' Long Name (zero terminated)
  bytemove(@buffer[DataOffset+108],@NodeReport,strsize(@NodeReport))' Node Report - Text (zero terminated)
  
  buffer[DataOffset+172] := NumPorts.byte[1]             ' Number of I/O ports supported:
  buffer[DataOffset+173] := NumPorts.byte[0]
  
  bytemove(@buffer[DataOffset+174],@PortType,12)         ' Port 1-4 type/protocol, Good Input, Good Output
  bytemove(@buffer[DataOffset+186],@Swin,11)             ' Swin, Swout, SwVideo, SwMacro, and SwRemote                                                                  ' 
  
  bytefill(@buffer[DataOffset+197],0,3)                  ' Spare 1-4, not used set to zero
  
  buffer[DataOffset+200] := Style                        ' Style - equipment style type
  
  bytemove(@buffer[DataOffset+201],@eth_mac,6)           ' Node's MAC address
  
  bytefill(@buffer[DataOffset+207],0,32)                 ' Filler (for future expansion)

  sendPacket(240,@buffer)                                ' broadcast the newly formed Art-Net packet

PRI ArtIPProg | command, idx

'' The ArtIpProg packet allows the IP settings of a Node to be reprogrammed. If the Node supports
'' remote programming, it will respond with an ArtIpProgReply packet.

  command := buffer[DataOffset+15]                      ' Actions
     
  bytemove(buffer[DataOffset+17], @ip, 10)              ' IP, Subnet mask, and Port/Socket to be programmed                                                                                          

  eth.SocketClose(0)                                    ' Close UDP socket to IP
  eth.InitAddresses(true, @eth_mac, @gateway, @subnet, @ip)' Initialize gateway, subnet mask, ip, MAC addr                                                         
  eth.SocketOpen(socket, eth#_UDPPROTO, PORT, PORT, @dest_ip) ' Open UDP socket to IP
                         
PRI ArtIpProgReply | idx

'' The ArtIpProgReply packet is issued by a Node in response to an ArtIpProg packet. Nodes that do not
'' supports remote programming of IP address do not reply to ArtIpProg packets.

  buffer[DataOffset+9] := IpProgReply>>8                 ' Opcode IpProgReply
  buffer[DataOffset+10] := IpProgReply
  buffer[DataOffset+11] := ProtVer>>8
  buffer[DataOffset+12] := ProtVer
  
  bytefill(@buffer[DataOffset+13], 0, 4)                 ' Filler 1-4
  
  bytemove(@buffer[DataOffset+17], @ip, 10)              ' IP, Subnet mask, and Port/Socket
  
  bytefill(@buffer[DataOffset+27], 0, 8)                 ' Transmit as Zero

  sendPacket(36, @buffer)                                ' broadcast the newly formed Art-Net packet

PRI ArtAddress | idx, command

'' A Server or monitoring device on the network can reprogram numerous controls of a node remotely.
'' This is achieved by sending an ArtAddress packet to the Node's IP address. (The IP address is
'' returned in the ArtPoll packet). The node replies with an ArtPollReply packet.
'' Fields 7 to 13 contain the data that will be programmed into the node.

  bytemove(@shortname, @buffer[DataOffset+15], 82)       ' Shortname, and Longname
  bytemove(@swin, @buffer[DataOffset+97], 8)             ' Swin, and Swout
  
  subswitch := buffer[DataOffset+102]
  
  byte[@SwVideo] := buffer[DataOffset+103]
  
  command := buffer[DataOffset+104]

PUB ArtDMXtx (_physical, _universe, _length) | idx

'' ArtDmx is the data packet used to transfer DMX512 data. The format is identical for Node to Server,
'' Node to Node and Server to Node. This routine handles the Node to Server communications when acting
'' as DMX input.

  buffer[DataOffset+9] := Output>>8                     ' Opcode IpProgReply
  buffer[DataOffset+10] := Output

  buffer[DataOffset+11] := ProtVer>>8
  buffer[DataOffset+12] := ProtVer
  
  if sequence <> 0
    sequence++
    if sequence == 0
      sequence := 1
  else
    sequence := 0 

  buffer[DataOffset+13] := sequence                     ' 0x01-0xFF ensure sequence of packets
  buffer[DataOffset+14] := _physical                    ' Physical port of DMX data (informational)
  buffer[DataOffset+15] := _universe
  buffer[DataOffset+16] := _universe>>8                 ' DMX data universe
  
  buffer[DataOffset+17] := _length>>8                   ' DMX packet Length (word sized)
  buffer[18] := _length

  bytemove(@buffer[DataOffset+19], DATAbuffrptr[DMXPacketSize*_universe], _length) ' copy data from DMX buffer location

  sendPacket(19+_length, @buffer)                     ' broadcast the newly formed Art-Net packet

PRI ArtDMXrx | idx, physical, universe, length

'' ArtDmx is the data packet used to transfer DMX512 data. The format is identical for Node to Server,
'' Node to Node and Server to Node. This routine handles the Server to Node communications when acting
'' as DMX output.
'' PERFORMANCE: 4 Universes = 263 packets/sec, 531 bytes/packet, ~1.4MB/sec                                         

  sequence := buffer[DataOffset+12]                      ' 0x01-0xFF ensure sequence of packets (not used)
  physical := buffer[DataOffset+13]                      ' Physical port of DMX data (informational)
  universe := buffer[DataOffset+14] + buffer[15]<<8      ' DMX data universe
  length   := buffer[DataOffset+16]<<8 + buffer[17]      ' DMX packet Length

  bytemove(DATAbuffrptr[DMXPacketSize*universe],buffer[DataOffset+18],length)

PRI ArtInput | idx

'' A Server or monitoring device on the network can enable or disable individual DMX512 inputs on any
'' of the network nodes. This allows the Server to directly control network traffic and ensures that
'' unused inputs are disabled and therefore not wasting bandwidth.
'' All nodes power on with all inputs enabled.

  bytemove(@NumPorts, @buffer[DataOffset+16], 2)         ' Number of inputs and outputs
  bytemove(@Inputs, @buffer[DataOffset+18], 4)           ' Input disable status for each port
  
PRI ArtFirmwareMaster | type, blockID, length, idx, tmp, start_time

'' Firmware File Format:
'' All firmware and UBEA upload files should be of the following format.
'' The firmware file extension is .alf.
'' The UBEA file extension is .alu.

'' NOTE: Partially implemented, work in progress -- untested

  type := @buffer[DataOffset+15]                         ' Type of message received:
                                                         '   0x00 = FirmFirst The first packet of a firmware upload.                 
                                                         '   0x01 = FirmCont A consecutive continuation packet of a firmware upload.
                                                         '   0x02 = FirmLast The last packet of a firmware upload.
                                                         '   0x03 = UbeaFirst The first packet of a UBEA upload.
                                                         '   0x04 = UbeaCont A consecutive continuation packet of a UBEA upload.
                                                         '   0x05 = UbeaLast The last packet of a UBEA upload.
                                                         
  blockID := @buffer[DataOffset+16]                      ' Counts the consecutive blocks of firmware upload.
  
                                                         ' Starting at 0x00 for the FirmFirst/UbeaFirst packet.
  repeat idx from 0 to 3                                 ' The total number of words (Int32) in the firmware         
    length.byte[idx] := @buffer[DataOffset+20-idx]       ' upload plus the firmware header size. Eg a 32K word       
    length.byte[idx] := @buffer[DataOffset+20-idx]       ' upload plus 530 words of header information ==            
    length.byte[idx] := @buffer[DataOffset+20-idx]       ' 0x00008212. This value is also the file size (in words)   
    length.byte[idx] := @buffer[DataOffset+20-idx]       ' of the file to be uploaded.                               
                                                         
  repeat idx from 0 to length*2                          ' Load EEPROM code from buffer, in WORDS
      tmp:=byte[@buffer][40+idx]                         
      'i2c.Write(i2c_SCL, tmp)                            
      start_time := cnt                                  ' prepare to check for a timeout
     
      'repeat while i2c.WriteWait(i2c_SCL, 0, $8000+(idx))
      if cnt - start_time > clkfreq / 10
        idx:=false
        quit
     
    waitcnt(cnt+clkfreq/2)                                ' wait for 10th of a sec
    reboot                                                ' reboot prop, reload code
    
PRI ArtFirmwareReply
'' This packet is sent by the Node to the Server in acknowledgement of each OpFirmwareMaster
'' packet.

 'Not implemented, future
 
PUB ArtTodRequest

'' This packet is used to request the Table of RDM Devices (TOD). A Node receiving this packet must
'' not interpret it as forcing full discovery. Full discovery is only initiated at power on or when an
'' ArtTodControl.AtcFlush is received.

  'Not implemented, future

PUB ArtTodData

  'Not implemented, future      


PUB ArtTodControl

'' The ArtTodControl packet is used to send RDM control parameters over Art-Net. The response is
'' ArtTodData.

  'Not implemented, future      

PUB ArtRDM

'' The ArtRdm packet is used to transport all non-discovery RDM messages over Art-Net.

  'Not implemented, future      

PUB ArtRDMSub

'' The ArtRdmSub packet is used to Get, Set, GetResponse and Set Response data to multiple subdevices
'' within an RDM device. This packet is primarily used by Art-Net devices that proxy or
'' emulate RDM.

'' Please note that this packet was added at the release of Art-Net II. For backwards compatibility it is
'' only acceptable to implement this packet in addition to ArtRdm. It must not be used instead of
'' ArtRdm.

  'Not implemented, future

PUB IPconfig(_state)
    
'' Configure the standard IP address.
                                  
  'macptr := eth.get_mac_pointer 
  ' First octet of IP
 ' if _state == true                                    ' if network switch/state is on/true 10.x.x.x
 '  ip[0] := 10
 '  dest_ip[0] := 10
    
 ' if _state == false                                   ' if network switch/state is off/false 2.x.x.x
 '  ip[0] := 2
 '  dest_ip[0] := 2

 ' ip[1] := byte[macptr][3]+OEMCode>>8+OEMCode          ' 10.114.34.76 or 2.114.34.76
 ' ip[2] := byte[macptr][4]
 ' ip[3] := byte[macptr][5]
                                                        ' Gateway matches calculated IP
 ' gateway := ip
  
PUB CustomIPconfig (_ipptr, _gwayptr, _subnetptr)
'
'' Configure the custom IP address.

' bytemove(_ipptr, @ip[0],4)
' bytemove(_gwayptr, @gateway[0],4)
' bytemove(_subnetptr, @subnet[0],4)

PUB setPortConfig(_portnum, _datatype, _direction, _bufferptr) 

'' Configure each input/output port, caller also provide a storage buffer location for data

  byte[@PortType][_portnum] := _datatype
  
  if _direction == 1
    byte[@PortType][_portnum] |= 8                             ' Set port direction to output (bit 8)
  else
    byte[@PortType][_portnum] |= 7                             ' Set port direction to input (bit 7)
  
  byte[@DATAbuffrptr][_portnum] := _bufferptr                  ' Provide pointer to data buffer

PUB getPortConfig(_portnum) : _config

  _config := byte[@PortType][_portnum]       

PUB setPortStatus(_portnum, _status, _state) | tmp

  if (PortType[_portnum] & |< 8) >> 8 == 1              ' Port direction is OUTPUT
    if _state == 1
      byte[@GoodOutput][_portnum] |= |< _status         ' Set bit/port status
    else                                            
      byte[@GoodOutput][_portnum] &= !|< _status        ' Clear bit/port status
      
                                                        ' bit 0 = unused
                                                        ' bit 1 = Merge Mode is LTP
                                                        ' bit 2 = DMX output short detected on power up
                                                        ' bit 3 = Output is merging ArtNet data    
                                                        ' bit 4 = Channel includes DMX512 text packets 
                                                        ' bit 5 = Channel includes DMX512 SIP's
                                                        ' bit 6 = Channel includes DMX512 test packets
                                                        ' bit 7 = Data is being transmitted.
                                                        
  else                                                  ' Port direction is INPUT
    if _state == 1
      byte[@GoodInput][_portnum] |= |< _status          ' Set bit/port status  
    else                                                
      byte[@GoodInput][_portnum] &= !|< _status         ' Clear bit/port status
      
                                                        ' bit 0-1 = unused
                                                        ' bit 2 = Received errors detected 
                                                        ' bit 3 = Input disabled                             
                                                        ' bit 4 = Channel includes DMX512 text packets       
                                                        ' bit 5 = Channel includes DMX51 SIP's               
                                                        ' bit 6 = Channel includes DMX512 test packets       
                                                        ' bit 7 = Data Received                              

PUB getPortStatus(_portnum) : _status

  if (PortType[_portnum] & |< 8) >> 8 == 1              ' Port direction is output  
    _status := byte[@GoodOutput][_portnum]              ' Output port status
  else
    _status := byte[@GoodInput][_portnum]               ' Input port status

PUB bufferptr : value

  value := @buffer                                 'Memory pointer to recieve data buffer

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

variable &= !|<Bit                                      '<-- To Turn Off (clear) a Bit via Number
variable &= !Bit                                        '<-- To Turn Off (clear) a Bit via mask
                                                         
variable |= |<Bit                                       '<-- To Turn On a Bit via Number
variable |= Bit                                         '<-- To Turn On a Bit via Mask
                                                         
variable ^= |<Bit                                       '<-- To Toggle a Bit via Number
variable ^= Bit                                         '<-- To Toggle a Bit via Mask
 
BitValue := (variable & |<Bit)>>Bit                     '<-- To Read a Bit via Number
BitValue := (variable & Bit)>>Bit                       '<-- To Read a Bit via Mask

}}