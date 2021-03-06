'' DHCP  Version 1.0
'' Copyright (c) 2010 Roy ELtham
'' November 15, 2010
'' See end of file for terms of use
''
'' This is an implementation of DHCP for the Spinneret Web Server.
''
CON

  ' UDP port numbers for DHCP 
  DHCP_SERVER_PORT  = 67        ' from server to client
  DHCP_CLIENT_PORT  = 68        ' from client to server

  ' DHCP message OP code 
  DHCP_BOOTREQUEST  = 1
  DHCP_BOOTREPLY    = 2

  ' DHCP message type
  DHCP_DISCOVER     = 1
  DHCP_OFFER        = 2
  DHCP_REQUEST      = 3
  DHCP_DECLINE      = 4
  DHCP_ACK          = 5
  DHCP_NAK          = 6
  DHCP_RELEASE      = 7
  DHCP_INFORM       = 8

  ' MISC DHCP stuff
  DHCP_TIMEOUT        = 80_000_000 * 4  ' 4 seconds, assumes 80Mhz clkfreq
  DHCP_FLAGSBROADCAST = $8000
  DHCP_HTYPE10MB      = 1
  DHCP_HLENETHERNET   = 6
  MAGIC_COOKIE_0      = $63
  MAGIC_COOKIE_1      = $82
  MAGIC_COOKIE_2      = $53
  MAGIC_COOKIE_3      = $63
  
  ' DHCP Options
  OPT_padOption               = 0
  OPT_subnetMask              = 1
  OPT_timerOffset             = 2
  OPT_routersOnSubnet         = 3
  OPT_timeServer              = 4
  OPT_nameServer              = 5
  OPT_dns                     = 6
  OPT_logServer               = 7
  OPT_cookieServer            = 8
  OPT_lprServer               = 9
  OPT_impressServer           = 10
  OPT_resourceLocationServer  = 11
  OPT_hostName                = 12
  OPT_bootFileSize            = 13
  OPT_meritDumpFile           = 14
  OPT_domainName              = 15
  OPT_swapServer              = 16
  OPT_rootPath                = 17
  OPT_extentionsPath          = 18
  OPT_IPforwarding            = 19
  OPT_nonLocalSourceRouting   = 20
  OPT_policyFilter            = 21
  OPT_maxDgramReasmSize       = 22
  OPT_defaultIPTTL            = 23
  OPT_pathMTUagingTimeout     = 24
  OPT_pathMTUplateauTable     = 25
  OPT_ifMTU                   = 26
  OPT_allSubnetsLocal         = 27
  OPT_broadcastAddr           = 28
  OPT_performMaskDiscovery    = 29
  OPT_maskSupplier            = 30
  OPT_performRouterDiscovery  = 31
  OPT_routerSolicitationAddr  = 32
  OPT_staticRoute             = 33
  OPT_trailerEncapsulation    = 34
  OPT_arpCacheTimeout         = 35
  OPT_ethernetEncapsulation   = 36
  OPT_tcpDefaultTTL           = 37
  OPT_tcpKeepaliveInterval    = 38
  OPT_tcpKeepaliveGarbage     = 39
  OPT_nisDomainName           = 40
  OPT_nisServers              = 41
  OPT_ntpServers              = 42
  OPT_vendorSpecificInfo      = 43
  OPT_netBIOSnameServer       = 44
  OPT_netBIOSdgramDistServer  = 45
  OPT_netBIOSnodeType         = 46
  OPT_netBIOSscope            = 47
  OPT_xFontServer             = 48
  OPT_xDisplayManager         = 49
  OPT_dhcpRequestedIPaddr     = 50
  OPT_dhcpIPaddrLeaseTime     = 51
  OPT_dhcpOptionOverload      = 52
  OPT_dhcpMessageType         = 53
  OPT_dhcpServerIdentifier    = 54
  OPT_dhcpParamRequest        = 55
  OPT_dhcpMsg                 = 56
  OPT_dhcpMaxMsgSize          = 57
  OPT_dhcpT1value             = 58
  OPT_dhcpT2value             = 59
  OPT_dhcpClassIdentifier     = 60
  OPT_dhcpClientIdentifier    = 61
  OPT_endOption               = 255

  ' offsets for UDP header
  UDP_HEADER_DESTADDR     = 0
  UDP_HEADER_PORT         = 4
  UDP_HEADER_PAYLOADSIZE  = 6
  UDP_HEADER_SIZE         = 8

  ' offsets for DHCP packet (UDP header is in front of this)
  DHCP_OP     = 8
  DHCP_HTYPE  = 9
  DHCP_HLEN   = 10
  DHCP_HOPS   = 11
  DHCP_XID    = 12
  DHCP_SECS   = 16
  DHCP_FLAGS  = 18
  DHCP_CIADDR = 20
  DHCP_YIADDR = 24
  DHCP_SIADDR = 28
  DHCP_GIADDR = 32
  DHCP_CHADDR = 36
  DHCP_SNAME  = 52
  DHCP_FILE   = 116
  DHCP_COOKIE = 244
  DHCP_OPT    = 248
  DHCP_END    = 556
  
  ' return codes
  SUCCESS               = 0
  SOCKET_FAILED_OPENING = 1
  SERVER_TIMEOUT        = 2
  SERVER_NAK            = 3

  BUFFER_SIZE = 2048

  'WIZ module I/O
  MISO          = 21            ' Master In Slave Out
  MOSI          = 22            ' Master Out Slave In
  SCS           = 23            ' Slave Select
  SCLK          = 24            ' Serial Clock            
  RST           = 25            ' Reset  

VAR

  byte MAC_Address[6]
  byte IP[4]
  byte SubnetMask[4]
  byte GatewayIP[4]

  long DHCP_LeaseTime           ' duration of lease in seconds
  byte DHCP_Server[4]
  byte DNS_Server[4]

  byte HostName[64]
  byte DomainName[64]          ' you may need to make this larger if you have a very long domain name
  
  byte Buffer[BUFFER_SIZE]

OBJ
  W5100 : "W5100_SPI_Driver"    'Ethernet indirect driver

PUB Start(HostNamePtr)

  ' clear all our variables
  BYTEFILL(@MAC_Address, 0, 158)
  
  ' set the host name
  BYTEMOVE(@HostName, HostNamePtr, STRSIZE(HostNamePtr))
  
  ' init the Wiznet 5100 chip
  W5100.StartSPI(SCS, SCLK, MOSI, MISO, RST)

PUB Stop
  W5100.StopSPI

'' only call these GetXXX functions after calling DoDHCP()
PUB GetIP(ipPtr)
  bytemove(ipPtr, @IP, 4)

PUB GetGatewayIP(gatewayPtr)
  bytemove(gatewayPtr, @GatewayIP, 4)
  
PUB GetSubnetMask(subnetPtr)
  bytemove(subnetPtr, @SubnetMask, 4)
   
PUB GetDNSServer(dnsPtr)
  bytemove(dnsPtr, @DNS_Server, 4)
  
PUB GetDHCPServer(dhcpPtr)
  bytemove(dhcpPtr, @DHCP_Server, 4)

PUB GetDomainName
  return @DomainName

PUB GetLeaseTime
  return DHCP_LeaseTime
  
'' call this function after Start, but before DoDHCP()
PUB SetHostName(newHostName)
  bytemove(@HostName, newHostName, STRSIZE(newHostName))

PUB GetHostName
  return @HostName

'' call this function after Start, but before DoDHCP()
PUB SetMAC_Address(newMAC_Address)
  MAC_Address[0] := byte[newMAC_Address][0]
  MAC_Address[1] := byte[newMAC_Address][1]
  MAC_Address[2] := byte[newMAC_Address][2]
  MAC_Address[3] := byte[newMAC_Address][3]
  MAC_Address[4] := byte[newMAC_Address][4]
  MAC_Address[5] := byte[newMAC_Address][5]          
  W5100.WriteMACaddress(true, @MAC_Address[0])
  
PUB GetMAC_Address(macPtr)
  bytemove(macPtr, @MAC_Address, 6)

'' You should call SetMAC_Address() and SetHostName() before calling this.  
PUB DoDHCP(socket, XID) | packetSize, startCnt, timeoutCnt, currentCnt, serverReply, DestinationIP[4], status 

  ' open the socket with the broadcast IP and the DHCP port
  DestinationIP[0] := 255
  DestinationIP[1] := 255
  DestinationIP[2] := 255
  DestinationIP[3] := 255
  W5100.SocketOpen(socket, W5100#_UDPPROTO, DHCP_CLIENT_PORT, DHCP_CLIENT_PORT, @DestinationIP[0])

  ' check the status of the socket
  status := ReadStatus(socket)
  if status <> W5100#_SOCK_UDP
    return SOCKET_FAILED_OPENING
  
  ' construct a DHCP Discover packet and send it, this asks DHCP servers to send us an Offer packet
  FillHeader(255,255,255,255, 67, DHCP_END-UDP_HEADER_SIZE, @Buffer[0])
  FillDiscoverPacket(XID, @Buffer)
  W5100.txUDP(socket, @Buffer)
  
  PauseMSec(100)
  
  ' wait for a DHCP Offer reply, we just go with the first server to reply
  startCnt := CNT
  timeoutCnt := startCnt + DHCP_TIMEOUT
  repeat
    packetSize := W5100.rxUDP(socket, @Buffer)
    if packetSize > 0
      serverReply := ParseDHCPReply(XID, DHCP_OFFER, @Buffer)
      case serverReply
        1: ' we got our packet
          QUIT
        2: ' got NAK from server
          W5100.SocketClose(socket)
          return SERVER_NAK
    ' check for timeout, handling wrap case        
    currentCnt := CNT          
    if startCnt < timeoutCnt 
      if (currentCnt => timeoutCnt) OR (currentCnt < startCnt)
        return SERVER_TIMEOUT
    else
      if (currentCnt => timeoutCnt) AND (currentCnt < startCnt)
        return SERVER_TIMEOUT
 
  ' construct a DHCP Request packet and send it, requesting to claim the offered IP
  FillHeader(255,255,255,255, 67, DHCP_END-UDP_HEADER_SIZE, @Buffer)
  FillRequestPacket(XID, @Buffer)
  W5100.txUDP(socket, @Buffer)

  PauseMSec(100)
  
  ' wait for a DHCP Ack reply, this grants us our claim on the IP
  startCnt := CNT
  timeoutCnt := startCnt + DHCP_TIMEOUT
  repeat
    packetSize := W5100.rxUDP(socket, @Buffer)
    if packetSize > 0
      serverReply := ParseDHCPReply(XID, DHCP_ACK, @Buffer)
      case serverReply
        1: ' we got our packet
          QUIT
        2: ' got NAK from server
          W5100.SocketClose(socket)
          return SERVER_NAK
          
    ' check for timeout, handling wrap case        
    currentCnt := CNT          
    if startCnt < timeoutCnt 
      if (currentCnt => timeoutCnt) OR (currentCnt < startCnt)
        return SERVER_TIMEOUT
    else
      if (currentCnt => timeoutCnt) AND (currentCnt < startCnt)
        return SERVER_TIMEOUT
 
  W5100.WriteGatewayAddress(true, @GatewayIP)
  W5100.WriteSubnetMask(true, @SubnetMask)
  W5100.WriteIPAddress(true, @IP)
  
  W5100.SocketClose(socket)
  return SUCCESS

PUB RenewLease(socket)
  'still to be done
  return SERVER_NAK
  
PRI ReadStatus(socket) | socketStatus
  W5100.readSPI((W5100#_S0_SR + (socket * $0100)), @socketStatus, 1)                         

  return socketStatus
    
PRI FillHeader(ip0,ip1,ip2,ip3, port, payloadSize, packetBuffer)
  byte[packetBuffer][UDP_HEADER_DESTADDR] := ip3
  byte[packetBuffer][UDP_HEADER_DESTADDR+1] := ip2
  byte[packetBuffer][UDP_HEADER_DESTADDR+2] := ip1
  byte[packetBuffer][UDP_HEADER_DESTADDR+3] := ip0
  byte[packetBuffer][UDP_HEADER_PORT] := port.byte[1]
  byte[packetBuffer][UDP_HEADER_PORT+1] := port.byte[0]
  byte[packetBuffer][UDP_HEADER_PAYLOADSIZE] := payloadSize.byte[1]
  byte[packetBuffer][UDP_HEADER_PAYLOADSIZE+1] := payloadSize.byte[0]

PRI FillBasePacket(XID, messageType, packetBuffer) | index, optionOffset, hostNameLength
  BYTEFILL(@byte[packetBuffer][DHCP_OP], 0, DHCP_END-UDP_HEADER_SIZE)
  byte[packetBuffer][DHCP_OP] := DHCP_BOOTREQUEST
  byte[packetBuffer][DHCP_HTYPE] := DHCP_HTYPE10MB
  byte[packetBuffer][DHCP_HLEN] := DHCP_HLENETHERNET
  byte[packetBuffer][DHCP_XID+0] := XID.byte[3]
  byte[packetBuffer][DHCP_XID+1] := XID.byte[2]
  byte[packetBuffer][DHCP_XID+2] := XID.byte[1]
  byte[packetBuffer][DHCP_XID+3] := XID.byte[0]
  word[@byte[packetBuffer][DHCP_FLAGS]] := ByteSwapWord(DHCP_FLAGSBROADCAST)
  
  repeat index from 0 to 5
    byte[packetBuffer][DHCP_CHADDR+index] := MAC_Address[index]
    
  byte[packetBuffer][DHCP_COOKIE+0] := MAGIC_COOKIE_0
  byte[packetBuffer][DHCP_COOKIE+1] := MAGIC_COOKIE_1
  byte[packetBuffer][DHCP_COOKIE+2] := MAGIC_COOKIE_2
  byte[packetBuffer][DHCP_COOKIE+3] := MAGIC_COOKIE_3
  
  optionOffset := 0
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpMessageType
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 1
  byte[packetBuffer][DHCP_OPT+optionOffset++] := messageType
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpClientIdentifier
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 7
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 1
  repeat index from 0 to 5
    byte[packetBuffer][DHCP_OPT+optionOffset++] := MAC_Address[index]
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_hostName
  hostNameLength := STRSIZE(@HostName[0])
  ' force to be even, so next option after this will be word aligned (16bit)
  if (hostNameLength & 1) == 1
    hostNameLength += 1
  byte[packetBuffer][DHCP_OPT+optionOffset++] := hostNameLength
  repeat index from 0 to hostNameLength-1
    byte[packetBuffer][DHCP_OPT+optionOffset++] := HostName[index]
  
  return optionOffset
  
PRI FillDiscoverPacket(XID, packetBuffer) | optionOffset
  optionOffset := FillBasePacket(XID, DHCP_DISCOVER, packetBuffer)
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpParamRequest
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 6
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_subnetMask
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_domainName
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dns
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_routersOnSubnet
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpT1value
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpT2value
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_endOption
  
PRI FillRequestPacket(XID, packetBuffer) | optionOffset
  optionOffset := FillBasePacket(XID, DHCP_REQUEST, packetBuffer)
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpRequestedIPaddr
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 4
  byte[packetBuffer][DHCP_OPT+optionOffset++] := IP[0]
  byte[packetBuffer][DHCP_OPT+optionOffset++] := IP[1]
  byte[packetBuffer][DHCP_OPT+optionOffset++] := IP[2]
  byte[packetBuffer][DHCP_OPT+optionOffset++] := IP[3]
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpServerIdentifier
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 4
  byte[packetBuffer][DHCP_OPT+optionOffset++] := DHCP_Server[0]
  byte[packetBuffer][DHCP_OPT+optionOffset++] := DHCP_Server[1]
  byte[packetBuffer][DHCP_OPT+optionOffset++] := DHCP_Server[2]
  byte[packetBuffer][DHCP_OPT+optionOffset++] := DHCP_Server[3]
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpParamRequest
  byte[packetBuffer][DHCP_OPT+optionOffset++] := 8
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_subnetMask
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_routersOnSubnet
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dns
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_domainName
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpT1value
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_dhcpT2value
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_performRouterDiscovery
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_staticRoute
  
  byte[packetBuffer][DHCP_OPT+optionOffset++] := OPT_endOption
  
PRI ParseDHCPReply(XID, expectedType, packetBuffer) | index, optionOffset, option, optionLength, port, payloadSize
  port := ByteSwapWord(word[@byte[packetBuffer][UDP_HEADER_PORT]])
  payloadSize := ByteSwapWord(word[@byte[packetBuffer][UDP_HEADER_PAYLOADSIZE]])

  ' verify the packet is from the DHCP server and is at least of minimum size
  if port <> DHCP_SERVER_PORT OR payloadSize < DHCP_OPT
    return 0 ' this is not a DHCP packet

  ' verify that the packet is a DHCP Reply
  if byte[packetBuffer][DHCP_OP] <> DHCP_BOOTREPLY
    return 0 ' this is not a DHCP Reply 
    
  ' verify XID match
  repeat index from 0 to 3
    if XID.byte[3-index] <> byte[packetBuffer][DHCP_XID+index]
      return 0 ' does not match, so not for us
      
  ' verify MAC Address match
  repeat index from 0 to 5
    if MAC_Address[index] <> byte[packetBuffer][DHCP_CHADDR+index]
      return 0 ' does not match, so not for us

  ' save the IP that is offered/claimed
  IP[0] := byte[packetBuffer][DHCP_YIADDR+0]
  IP[1] := byte[packetBuffer][DHCP_YIADDR+1]
  IP[2] := byte[packetBuffer][DHCP_YIADDR+2]
  IP[3] := byte[packetBuffer][DHCP_YIADDR+3]
  
  DHCP_LeaseTime := 0
  
  ' scan through options pulling out stuff we need
  optionOffset := 0
  repeat
    option := byte[packetBuffer][DHCP_OPT+optionOffset++]
    if option <> 0
      optionLength := byte[packetBuffer][DHCP_OPT+optionOffset++]
    else
      optionLength := 0
    case option
      OPT_endOption : 
        QUIT
      OPT_dhcpMessageType :
        if byte[packetBuffer][DHCP_OPT+optionOffset] <> expectedType
          if byte[packetBuffer][DHCP_OPT+optionOffset] == DHCP_NAK
            return 2
          else
            return 0
      OPT_subnetMask : 
        SubnetMask[0] := byte[packetBuffer][DHCP_OPT+optionOffset+0]
        SubnetMask[1] := byte[packetBuffer][DHCP_OPT+optionOffset+1]
        SubnetMask[2] := byte[packetBuffer][DHCP_OPT+optionOffset+2]
        SubnetMask[3] := byte[packetBuffer][DHCP_OPT+optionOffset+3]
      OPT_routersOnSubnet :
        GatewayIP[0] := byte[packetBuffer][DHCP_OPT+optionOffset+0]
        GatewayIP[1] := byte[packetBuffer][DHCP_OPT+optionOffset+1]
        GatewayIP[2] := byte[packetBuffer][DHCP_OPT+optionOffset+2]
        GatewayIP[3] := byte[packetBuffer][DHCP_OPT+optionOffset+3]
      OPT_dhcpIPaddrLeaseTime :
        DHCP_LeaseTime.byte[0] := byte[packetBuffer][DHCP_OPT+optionOffset+3]
        DHCP_LeaseTime.byte[1] := byte[packetBuffer][DHCP_OPT+optionOffset+2]
        DHCP_LeaseTime.byte[2] := byte[packetBuffer][DHCP_OPT+optionOffset+1]
        DHCP_LeaseTime.byte[3] := byte[packetBuffer][DHCP_OPT+optionOffset+0]
      OPT_dns :
        DNS_Server[0] := byte[packetBuffer][DHCP_OPT+optionOffset+0]
        DNS_Server[1] := byte[packetBuffer][DHCP_OPT+optionOffset+1]
        DNS_Server[2] := byte[packetBuffer][DHCP_OPT+optionOffset+2]
        DNS_Server[3] := byte[packetBuffer][DHCP_OPT+optionOffset+3]
      OPT_dhcpServerIdentifier :
        DHCP_Server[0] := byte[packetBuffer][DHCP_OPT+optionOffset+0]
        DHCP_Server[1] := byte[packetBuffer][DHCP_OPT+optionOffset+1]
        DHCP_Server[2] := byte[packetBuffer][DHCP_OPT+optionOffset+2]
        DHCP_Server[3] := byte[packetBuffer][DHCP_OPT+optionOffset+3]
      OPT_domainName :
        BYTEMOVE(@DomainName[0], @byte[packetBuffer][DHCP_OPT+optionOffset], optionLength)
        
    optionOffset += optionLength
  
  return 1
  
PRI ByteSwapWord(value)
  result.byte[0] := value.byte[1]
  result.byte[1] := value.byte[0]
  
PRI PauseMSec(Duration)
''  Pause execution for specified milliseconds.
''  This routine is based on the set clock frequency.
''  
''  params:  Duration = number of milliseconds to delay                                                                                               
''  return:  none
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)


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