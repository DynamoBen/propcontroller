''  WIZnet W5200 Driver Ver. 1.3
''
''  Original source: W5100_SPI_Driver.spin - Timothy D. Swieter (code.google.com/p/spinneret-web-server/source/browse/trunk/W5100_SPI_Driver.spin) 
''  W5200 changes/adaptations: Benjamin Yaroch (BY)
''  Additional revisions: Jim St. John (JS)
''
''Description:
''
''      This is a SPI Assembly language driver for the W5200.
''      The SEN signal should be tied high to enable SPI mode
''      on the W5200 IC. This driver requires the SCLK, /SCS,
''      MOSI, and MISO signals.  The /INT signal is not used in
''      this version of the driver and /RESET is optional.
''
''      The functions are mostly implemented in ASM for fast access. There is high level access
''      to the SPI, but going through SPIN to do many of the functions adds considerable time.
''
''      The program that calls this driver will need to set up variables for the following:
''
''      'Variables to hold the address configuration information as set
''      byte  myMAC[6]          '6 element array contianing MAC or source hardware address ex. "02:00:00:01:23:45"
''      byte  myGateway[4]      '4 element array containing gateway address ex. "192.168.0.1"
''      byte  mySubnet[4]       '4 element array contianing subnet mask ex. "255.255.255.0"
''      byte  myIP[4]           '4 element array containing IP address ex. "192.168.0.13"
''
''SPI Data Structure:
''      Address (16 bits), OpCode (1 bit), Data Length (15 bits), Data (8 bits) == 40 bits
''
''Revision Notes:
''      1.0 Initial Release - Basic single byte read/write working and optimized code for speed. (BY)
''      1.1 Increased Speed - Eliminated NOPs and increased write speed to 20mhz.  (JS)
''      1.2 Burst Mode supported - W52000 burst mode was added which increases read/write speed. (JS)
''      1.3 nReset Bug - Fixed reset problem at boot (BY)
''
CON
  
  '  W5200 Common Register Definitions
  
  _MR           = $0000         'Mode Register
  _GAR0         = $0001         'Gateway Address Register
  _GAR1         = $0002
  _GAR2         = $0003
  _GAR3         = $0004
  _SUBR0        = $0005         'Subnet Mask Address Register
  _SUBR1        = $0006
  _SUBR2        = $0007
  _SUBR3        = $0008
  _SHAR0        = $0009         'Source Hardware Address Register (MAC)
  _SHAR1        = $000A
  _SHAR2        = $000B
  _SHAR3        = $000C
  _SHAR4        = $000D
  _SHAR5        = $000E
  _SIPR0        = $000F         'Source IP Address Register
  _SIPR1        = $0010
  _SIPR2        = $0011
  _SIPR3        = $0012
  'Reserved space $0013 - $0014
  _IR           = $0015         'Interrupt Register
  _IMR2         = $0016         'Socket Interrupt Mask Register
  _RTR0         = $0017         'Retry Time Register
  _RTR1         = $0018
  _RCR          = $0019         'Retry Count Register
  'Reserved space $001A - $001B
  _PATR0        = $001C         'Authentication Type in PPPoE Register
  _PATR1        = $001D
  _PPPALGO      = $001E         'Algorithm in PPPoE
  _VERSIONR     = $001F         'Chip version
  'Reserved space  $0020 - $0027
  _PTIMER       = $0028         'PPP LCP Request Timer
  _PMAGIC       = $0029         'PPP LCP Magic Number
  'Reserved space  $002A - $002F
  _INTLEVEL0    = $0030
  _INTLEVEL1    = $0031
  'Reserved space $0032 - $0033
  _IR2          = $0034
  _PSTATUS      = $0035
  _IMR          = $0036
  
  '  W5200 Socket 0 Register Definitions
  
  _S0_MR        = $4000         'Socket 0 Mode Register
  _S0_CR        = $4001         'Socket 0 Command Register
  _S0_IR        = $4002         'Socket 0 Interrupt Register
  _S0_SR        = $4003         'Socket 0 Status Register
  _S0_PORT0     = $4004         'Socket 0 Source Port Register
  _S0_PORT1     = $4005
  _S0_DHAR0     = $4006         'Socket 0 Destination Hardware Address Register
  _S0_DHAR1     = $4007
  _S0_DHAR2     = $4008
  _S0_DHAR3     = $4009
  _S0_DHAR4     = $400A
  _S0_DHAR5     = $400B
  _S0_DIPR0     = $400C         'Socket 0 Destination IP Address Register
  _S0_DIPR1     = $400D
  _S0_DIPR2     = $400E
  _S0_DIPR3     = $400F
  _S0_DPORT0    = $4010         'Socket 0 Destination Port Register
  _S0_DPORT1    = $4011
  _S0_MSSR0     = $4012         'Socket 0 Maximum Segment Size Register
  _S0_MSSR1     = $4013
  _S0_PROTO     = $4014         'Socket 0 Protocol in IP Raw Mode Register
  _S0_TOS       = $4015         'Socket 0 IP TOS Register
  _S0_TTL       = $4016         'Socket 0 IP TTL Register
  'Reserved space $4017 - $401D
  _S0_RXMEM_SIZE = $401E
  _S0_TXMEM_SIZE = $401F  
  _S0_TX_FSRO   = $4020         'Socket 0 TX Free Size Register
  _S0_TX_FSR1   = $4021
  _S0_TX_RD0    = $4022         'Socket 0 TX Read Pointer Register
  _S0_TX_RD1    = $4023
  _S0_TX_WR0    = $4024         'Socket 0 TX Write Pointer Register
  _S0_TX_WR1    = $4025
  _S0_RX_RSR0   = $4026         'Socket 0 RX Received Size Register
  _S0_RX_RSR1   = $4027
  _S0_RX_RD0    = $4028         'Socket 0 RX Read Pointer Register
  _S0_RX_RD1    = $4029
  _S0_RX_WR0    = $402A
  _S0_RX_WR1    = $402B
  _S0_IMR       = $402C
  _S0_FRAG0     = $402D
  _S0_FRAG1     = $402E
  'Reserved space $4030 - $40FF
  
  '  W5200 Register Masks & Values Defintions  

  'Used in the mode register (MR)
  _RSTMODE      = %1000_0000    'If 1, internal registers are initialized
  _PBMODE       = %0001_0000    'Ping block mode, 1 is enabled
  _PPPOEMODE    = %0000_1000    'PPPoE mode, 1 is enabled

  'Used in the Interrupt Register (IR) & Interrupt Mask Register (IMR) & SOCKET Interrupt Register (IR2)
  _CONFLICTM    = %1000_0000
  _PPPoEM       = %0010_0000
  
  _S7_INTM      = %1000_0000    'Socket 7 interrupt bit mask (1 = interrupt)  
  _S6_INTM      = %0100_0000    'Socket 6 interrupt bit mask (1 = interrupt)  
  _S5_INTM      = %0010_0000    'Socket 5 interrupt bit mask (1 = interrupt)  
  _S4_INTM      = %0001_0000    'Socket 4 interrupt bit mask (1 = interrupt)  
  _S3_INTM      = %0000_1000    'Socket 3 interrupt bit mask (1 = interrupt)
  _S2_INTM      = %0000_0100    'Socket 2 interrupt bit mask (1 = interrupt)
  _S1_INTM      = %0000_0010    'Socket 1 interrupt bit mask (1 = interrupt)
  _S0_INTM      = %0000_0001    'Socket 0 interrupt bit mask (1 = interrupt)

  'Us in the PHY status Register
  _LINK         = %0010_0000    'This register indicates Link status (0=down, 1=up)
  _PWR_DWN      = %0000_1000    'This register indicates status of Power Down mode (0=disable, 1=enable)

  'Used in the RX memory size register(RMSR)
  _S7_SM        = %0011_0000_0000_0000    'Socket 7 size mask   
  _S6_SM        = %0000_1100_0000_0000    'Socket 6 size mask   
  _S5_SM        = %0000_0011_0000_0000    'Socket 5 size mask     
  _S4_SM        = %0000_0000_1100_0000    'Socket 4 size mask   
  _S3_SM        = %0000_0000_1100_0000    'Socket 3 size mask
  _S2_SM        = %0000_0000_0011_0000    'Socket 2 size mask
  _S1_SM        = %0000_0000_0000_1100    'Socket 1 size mask
  _S0_SM        = %0000_0000_0000_0011    'Socket 0 size mask

  _1KB          = $01           '1KB memory size
  _2KB          = $02           '2KB memory size
  _4KB          = $04           '4KB memory size
  _8KB          = $08           '8KB memory size
  _16KB         = $0F           '16KB memory size

  'Used in the socket n mode register (Sn_MR)
  _MULTIM       = %1000_0000    'Enable/disable multicasting in UDP
  _MFM          = %0100_0000    'Enable/disable MAC filter
  _ND_MCM       = %0010_0000    'Enable/disable No Delayed ACK option
  _PROTOCOLM    = %0000_1111    'Registers for setting protocol

  _CLOSEDPROTO  = %0000         'Closed
  _TCPPROTO     = %0001         'TCP
  _UDPPROTO     = %0010         'UDP
  _IPRAWPROTO   = %0011         'IPRAW
  _MACRAW       = %0100         'MACRAW (used in socket 0)
  _PPPOEPROTO   = %0101         'PPPoE (used in socket 0)

  'Used in the socket n command register (Sn_CR)
  _OPEN         = $01           'Initialize a socket
  _LISTEN       = $02           'In TCP mode, waits for request from client
  _CONNECT      = $04           'In TCP mode, sends connect request to server
  _DISCON       = $08           'In TCP mode, request to disconnect
  _CLOSE        = $10           'Closes socket
  _SEND         = $20           'Transmits data
  _SEND_MAC     = $21           'In UDP mode, like send, but uses MAC
  _SEND_KEEP    = $22           'In TCP mode, check connection status by sending 1 byte
  _RECV         = $40           'Receiving is processed

  'Used in socket n interrupt register (Sn_IR)
  _SEND_OKM     = %0001_0000    'Set to 1 if send operation is completed
  _TIMEOUTM     = %0000_1000    'Set to 1 if timeout occured during transmission
  _RECVM        = %0000_0100    'Set to 1 if data is received
  _DISCONM      = %0000_0010    'Set to 1 if connection termination is requested
  _CONM         = %0000_0001    'Set to 1 if connection is established

  'Used in socket n status register (Sn_SR)
  _SOCK_CLOSED    = $00
  _SOCK_INIT      = $13
  _SOCK_LISTEN    = $14
  _SOCK_ESTAB     = $17
  _SOCK_CLOSE_WT  = $1C
  _SOCK_UDP       = $22
  _SOCK_IPRAW     = $32
  _SOCK_MACRAW    = $42
  _SOCK_PPPOE     = $5F
  _SOCK_SYNSENT   = $15
  _SOCK_SYNRECV   = $16
  _SOCK_FIN_WAIT  = $18
  _SOCK_CLOSING   = $1A
  _SOCK_TIME_WAIT = $1B
  _SOCK_LAST_ACK  = $1D
  _SOCK_ARP       = $01

  'RX & TX definitions
  _TX_base      = $8000         'Base address of TX buffer
  _RX_base      = $C000         'Base address of RX buffer

  _TX_mask      = $7FF          'Mask for default 2K buffer for each socket
  _RX_mask      = $7FF          'Mask for default 2K buffer for each socket

  _UDP_header   = 8             '8 bytes of data in the UDP header from the W5200

  
  ' Command Definitions for ASM W5200 SPI Routine
  _reserved     = 0             'This is the default state - means ASM is waiting for command
  _readSPI      = 1 << 16       'High level access to reading from the W5200 via SPI
  _writeSPI     = 2 << 16       'High level access to writing to the W5200 via SPI
  _SetMAC       = 3 << 16       'Set the MAC ID in the W5200
  _SetGateway   = 4 << 16       'Set the gateway address in the W5200
  _SetSubnet    = 5 << 16       'Set the subnet address in the W5200
  _SetIP        = 6 << 16       'Set the IP address in the W5200
  _ReadMAC      = 7 << 16       'Recall the MAC ID in the W5200
  _ReadGateway  = 8 << 16       'Recall the gateway address in the W5200
  _ReadSubnet   = 9 << 16       'Recall the subnet address in the W5200
  _ReadIP       = 10 << 16      'Recall the IP address in the W5200
  _PingBlock    = 11 << 16      'Enable/disable ping response
  _rstHW        = 12 << 16      'Reset the W5200 IC via hardware
  _rstSW        = 13 << 16      'Reset the W5200 IC via hardware
  _Sopen        = 14 << 16      'Open a socket
  _Sdiscon      = 15 << 16      'Disconnect a socket
  _Sclose       = 16 << 16      'Close a socket  
  _lastCmd      = 17 << 16      'Place holder for last command

  ' Driver Flag Definitions
  _Flag_ASMstarted = |< 1       'Flag to indicated asm routine is started succesfully

VAR

  long  cog                     'cog flag/id
  
DAT              

  'Command setup
        command         long    0               'stores command and arguments for the ASM driver
        lock            byte    255             'Mutex semaphore

PUB start(_scs, _sclk, _mosi, _miso, _reset) : okay

''  Initializes the I/O and registers based on parameters.
''  After initilization another cog is started which is the
''  cog responsible for the SPI communication to the W5200.
''
''  The W5200 SPI cog will allow only one instance of itself
''  to run and the it consumes only 1 cog.
''
''  params:  the five pins required for SPI
''  return:  value of cog if started or zero if not started

  'Keeps from two cogs running
  stop

  'Initialize the I/O for writing the mask data to the memory area that will be copied into a COG.
  'This routine assumes SPI connection, SPI_EN should be tied high on W5200 and isn't controlled by this driver.
  SCSmask   := |< _scs
  SCLKmask  := |< _sclk
  MOSImask  := |< _mosi
  MISOmask  := |< _miso
  RESETmask := |< _reset

  'Counter values setup before calling the ASM cog that will use them.
  'CounterX     mode  PLL         BPIN        APIN
  ctramode :=  %00100_000 << 23 +  0   << 9 +  _sclk
  ctrbmode :=  %00100_000 << 23 +  0   << 9 +  _mosi

  'Clear the command buffer - be sure no commands were set before initializing
  command := 0

  'Start a cog to execute the ASM routine
  okay := cog := cognew(@Entry, @command) + 1

PUB stop    

'' Stop the W5200 SPI Driver cog if one is running.
'' Only a single cog can be running at a time.

  if cog                                                'Is cog non-zero?
    cogstop(cog~ - 1)                                   'Yes, stop the cog and then make value zero
    longfill(@SCSmask, 0, 5)                            'Clear all masks
  

PUB InitAddresses( _block, _macPTR, _gatewayPTR, _subnetPTR, _ipPTR)

'' Initialize all four addresses.
''
''  params:  _block if true will wait for ASM routine to send before returning from this function
''           _mac, _gateway, _subnet, _ip are pointers to appropriate size byte arrays

  'Checks on if the ASM cog is running is done in each of the following routines
  WriteMACaddress(_block, _macPTR)
  WriteGatewayAddress(_block, _gatewayPTR)
  WriteSubnetMask(_block, _subnetPTR)
  WriteIPaddress(_block, _ipPTR)

PUB WriteMACaddress( _block, _macPTR)

'' Write the specified MAC address to the W5200.
''
''  params:  _block if true will wait for ASM routine to send before continuing
''           The pointer should point to a 6 byte array.
''           byte[0] = highest octet and byte[5] = lowest octet
''           example 02:00:00:01:23:45 where byte[0] = $02 and byte[5] = $45
''
   
  'Send the command
  command := _SetMAC + _macPTR
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   

PUB WriteGatewayAddress(_block, _gatewayPTR)

'' Write the specified gateway address to the W5200.
''
''  params:  _block if true will wait for ASM routine to send before continuing
''           The pointer should point to a 4 byte array.
''           byte[0] = highest octet and byte[3] = lowest octet
''           example 192.168.0.1 where byte[0] = 192 and byte[3] = 1
''
''  return:  none


  'Send the command
  command := _SetGateway + _gatewayPTR
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   

PUB WriteSubnetMask(_block, _subnetPTR)

'' Write the specified Subnet mask to the W5200.
''
''  params:  _block if true will wait for ASM routine to send before continuing
''           The pointer should point to a 4 byte array.
''           byte[0] = highest octet and byte[3] = lowest octet
''           example 255.255.255.0 where byte[0] = 255 and byte[3] = 0
''
   
  'Send the command
  command := _SetSubnet + _subnetPTR
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   

PUB WriteIPaddress(_block, _ipPTR)

'' Write the specified IP address to the W5200.
''
''  params:  _block if true will wait for ASM routine to send before continuing
''           The pointer should point to a 4 byte array.
''           byte[0] = highest octet and byte[3] = lowest octet
''           example 192.168.0.13 where byte[0] = 192 and byte[3] = 13

  'Send the command
  command := _SetIP + _ipPTR
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   
   
PUB ReadMACaddress(_macPTR)

'' Read the MAC address from the W5200.
''
''  return:  The pointer should point to a 6 byte array.
''           byte[0] = highest octet and byte[5] = lowest octet
''           example 02:00:00:01:23:45 where byte[0] = $02 and byte[5] = $45

  'Send the command
  command := _ReadMAC + _macPTR
   
  'wait for the command to complete
  repeat while command
   
PUB ReadGatewayAddress(_gatewayPTR)

'' Read the gateway address from the W5200.
''
''  return:  The pointer should point to a 4 byte array.
''           byte[0] = highest octet and byte[3] = lowest octet
''           example 192.168.0.1 where byte[0] = 192 and byte[3] = 1

   
  'Send the command
  command := _ReadGateway + _gatewayPTR
   
  'wait for the command to complete
  repeat while command
   
PUB ReadSubnetMask(_subnetPTR)

'' Read the specified Subnet mask from the W5200
''
''  return:  The pointer should point to a 4 byte array.
''           byte[0] = highest octet and byte[3] = lowest octet
''           example 255.255.255.0 where byte[0] = 255 and byte[3] = 0

   
  'Send the command
  command := _ReadSubnet + _subnetPTR
   
  'wait for the command to complete
  repeat while command
   
   
PUB ReadIPaddress(_ipPTR)

'' Read the specified IP address from the W5200
''
''  return:  The pointer should point to a 4 byte array.
''           byte[0] = highest octet and byte[3] = lowest octet
''           example 192.168.0.13 where byte[0] = 192 and byte[3] = 13

   
  'Send the command
  command := _ReadIP + _ipPTR
   
  'wait for the command to complete
  repeat while command
   
   
PUB PingBlock(_block, _bool)

'' Enable/disable if the W5200 responds to pings.
''
''  params:  _block if true will wait for ASM routine to send before continuing
''           _bool is a bool, true is W5200 will NOT respond, false W5200 will respond
   
  'Send the command
  command := _pingBlock + @_bool
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   

PUB ResetHardware(_block)

'' Reset the W5200 via hardware
''
''  params:  _block if true will wait for ASM routine to send before continuing


  'Send the command
  command := _rstHW
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   
   
PUB ResetSoftware(_block)

'' Reset the W5200 via software
''
''  params:  _block if true will wait for ASM routine to send before continuing

  'Send the command
  command := _rstSW
   
  'wait for the command to complete or just move on
  if _block
    repeat while command

PUB SocketOpen(_socket, _mode, _srcPort, _destPort, _destIP)

'' Open the specified socket in the specified mode on the W5200.
'' The mode can be either TCP or UDP.
''
''  params:  _socket is a value of 0 to 7 - only eight sockets on the W5200
''           _mode is one of the constants specifing closed, TCP, UDP, IPRaw etc
''           _srcPort, _destPort are the ports to use in the connection pass by value
''           _destIP is a pointer to the destination IP byte array (use the @ on the variable)

   
  'Send the command
  command := _Sopen + @_socket
   
  'wait for the command to complete
  repeat while command

PUB SocketClose(_socket)

'' Closes the specified socket on the W5200.
''
''  params:  _socket is a value of 0 to 7 - only eight sockets on the W5200


  'Send the command
  command := _Sclose + @_socket
   
  'wait for the command to complete
  repeat while command
   
PUB SocketTCPlisten(_socket) | temp0

'' Check if a socket is TCP and open and if so then set the socket to listen on the W5200
''
''  params: _socket is a value of 0 to 7 - only eight sockets on the W5200
 

    'Check if the socket is TCP and open by looking at socket status register
    readSPI((_S0_SR + (_socket * $0100)), @temp0, 1)
     
    if temp0.byte[0] <> _SOCK_INIT
      return
     
    'Tell the W5200 to listen on the particular socket
    temp0 := _LISTEN
    writeSPI(true, (_S0_CR + (_socket * $0100)), @temp0, 1)
     
     
PUB SocketTCPconnect(_socket) | temp0

''
''  params: _socket is a value of 0 to 7 - only four sockets on the W5200

     
  'Check if the socket is TCP and open by looking at socket status register
  readSPI((_S0_SR + (_socket * $0100)), @temp0, 1)
   
  if temp0.byte[0] <> _SOCK_INIT
    return
   
  'Tell the W5200 to connect to a particular socket
  temp0 := _CONNECT
  writeSPI(true, (_S0_CR + (_socket * $0100)), @temp0, 1)
     
PUB SocketTCPestablished(_socket) | temp0

'' Check if a socket has established a TCP connection
''
''  params: _socket is a value of 0 to 7 - only eight sockets on the W5200
''  return: True if established, false if not

   
  'Check if the socket is established or not
  readSPI((_S0_SR + (_socket * $0100)), @temp0, 1)
   
  if temp0.byte[0] <> _SOCK_ESTAB
    return false
  else
    return true

  return false 'end of SocketTCPestablished

PUB SocketTCPdisconnect(_socket)

'' Disconnects the specified socket on the W5200.
''
''  params:  _socket is a value of 0 to 7 - only four sockets on the W5200

  'Send the command
  command := _Sdiscon + @_socket
   
  'wait for the command to complete
  repeat while command
   
PUB rxTCP(_socket, _dataPtr) | temp0, RSR, pcktptr, pcktoffset, pcktstart, rolloverpoint

'' Receive TCP data on the specified socket.  Most of the heavy lifting of receiving data is handled by the ASM routine,
'' but for effeciency in coding the SPIN routine walks through the process of receiving data such as verifying and manipulating
'' the various register.  NOTE: This routine could be completely coded in ASM for faster operation.
''
'' The receive routine streams over the TCP data.  The data streamed over is based on the W5200 receive register size.
''
''  params:  _socket is a value of 0 to 7 - only four sockets on the W5200
''           _dataPtr is a pointer to the byte array to be written to in HUBRAM (use the @ in front of the byte variable)
''  return:  Non-zero value indicating the number of bytes read from W5200 or zero if no data is read
''

  'Check if there is data to receive from the W5200
  readSPI((_S0_RX_RSR0 + (_socket * $0100)), @temp0, 2)
  RSR.byte[1] := temp0.byte[0]
  RSR.byte[0] := temp0.byte[1]
   
  'Bring over the data if there is data
  if RSR.word[0] <> 0
   
    'Determine the offset and location to read data from in the W5200
    readSPI((_S0_RX_RD0 + (_socket * $0100)), @temp0, 2)
    pcktptr.byte[1] := temp0.byte[0]
    pcktptr.byte[0] := temp0.byte[1]
    pcktoffset := pcktptr & _RX_mask
    pcktstart := (_RX_base + (_socket * $0800)) + pcktoffset
   
    'Read the data of the packet
    if (pcktoffset + RSR.word[0]) > constant(_RX_mask + 1)
      'process the data in two parts because the buffers rolls over
      rolloverpoint := constant(_RX_mask + 1) - pcktoffset
      readSPI(pcktstart, _dataPtr, rolloverpoint)
      pcktstart := (_RX_base + (_socket * $0800))
      readSPI(pcktstart, (_dataPtr + rolloverpoint), (RSR.word[0] - rolloverpoint))
   
    else
      'process the data in one part
      readSPI(pcktstart, _dataPtr, RSR.word[0])
   
    'Update the W5200 registers, the packet pointer
    temp0 := (pcktptr + RSR.word[0])
    pcktptr.byte[1] := temp0.byte[0]
    pcktptr.byte[0] := temp0.byte[1]
    writeSPI(true, (_S0_RX_RD0 + (_socket * $0100)), @pcktptr, 2)
   
    'Tell the W5200 we received a packet
    temp0 := _RECV
    writeSPI(true, (_S0_CR + (_socket * $0100)), @temp0, 1)
   
    return RSR.word[0]        'bugfix /Q

  return 0 'end of rxTCP

PUB txTCP(_socket, _dataPtr, _size) | temp0, freespace, pcktptr, pcktoffset, pcktstart, rolloverpoint, chunksize

'' Transmit TCP data on the specified socket and port.  Most of the heavy lifting of transmitting data is handled by the ASM routine,
'' but for effeciency in coding the SPIN routine walks through the process of transmitting data such as verifying and manipulating
'' the various register.  This routine could be completely coded in ASM for faster operation.
''
'' The transmit routine sends only the amount of data specified by _size.  This routine waits for room in the W5200 to send the packet.
''
''  params:  _socket is a value of 0 to 7 - only eight sockets on the W5200
''           _dataPtr is a pointer to the byte(s) of data to read from HUBRAM and sent (use the @ in front of the byte variable)
''           _size it the length in bytes of the data to be sent from HUBRAM
''  return:  True if data was put in W5200 and told to be sent, otherwise false
''

  'Initialize
  freespace := 0
  pcktptr:= 0
       
  repeat while _size > 0
    'wait for room in the W5200 to send some of the data
    repeat until (freespace.word[0] > 0)
      readSPI((_S0_TX_FSRO + (_socket * $0100)), @temp0, 2)
      freespace.byte[1] := temp0.byte[0]
      freespace.byte[0] := temp0.byte[1]
    chunksize := _size <# freespace.word[0]
   
    'Get the place where to start writing the packet in the W5200
    readSPI((_S0_TX_WR0 + (_socket * $0100)), @temp0, 2)
    pcktptr.byte[1] := temp0.byte[0]
    pcktptr.byte[0] := temp0.byte[1]
    pcktoffset := pcktptr & _TX_mask
    pcktstart := (_TX_base + (_socket * $0800)) + pcktoffset
   
    'Write the data based on rolling over in the buffer or not
    if (pcktoffset + chunksize) > constant(_TX_mask + 1)
      'process the data in two parts because the buffers rolls over
      rolloverpoint := constant(_TX_mask + 1) - pcktoffset
      writeSPI(true, pcktstart, _dataPtr, rolloverpoint)
      pcktstart := (_TX_base + (_socket * $0800))
      writeSPI(true, pcktstart, (_dataPtr + rolloverpoint), (chunksize - rolloverpoint))
   
    else
      'process the data in one part
      writeSPI(true, pcktstart, _dataPtr, chunksize)
   
    'Calculate the packet pointer for the next go around and save it
    temp0 := pcktptr + chunksize
    pcktptr.byte[1] := temp0.byte[0]
    pcktptr.byte[0] := temp0.byte[1]
    writeSPI(true, (_S0_TX_WR0 + (_socket * $0100)), @pcktptr, 2)
   
    'Tell the W5200 to send the packet
    temp0 := _SEND
    writeSPI(true, (_S0_CR + (_socket * $0100)), @temp0, 1)
   
    _size    -= chunksize
    _dataPtr += chunksize

PUB rxUDP(_socket, _dataPtr) | temp0, RSR, pcktsize, pcktptr, pcktoffset, pcktstart, rolloverpoint

'' Receive UDP data on the specified socket.  Most of the heavy lifting of receiving data is handled by the ASM routine,
'' but for effeciency in coding the SPIN routine walks through the process of receiving data such as verifying and manipulating
'' the various registers.  NOTE: This routine could be completely coded in ASM for faster operation.
''
'' The receive routine brings over only 1 packet of UDP data at a time.  The packet is based on the size of data read in the packet
'' header and NOT the W5200 receive register size.
''
''  params:  _socket is a value of 0 to 7 - only four sockets on the W5200
''           _dataPtr is a pointer to the byte array to be written to in HUBRAM (use the @ in front of the byte variable)
''  return:  Non-zero value indicating bytes read from W5200 or zero if no data is read
''
''  The data returned is the complete packet as provided by the W5200.  This means the following:
''  data[0]..[3] is the source IP address, data[4],[5] is the source port, data[6],[7] is the payload size and data[8] starts the payload

  'Check if there is data to receive from the W5200
  readSPI((_S0_RX_RSR0 + (_socket * $0100)), @temp0, 2)
  RSR.byte[1] := temp0.byte[0]
  RSR.byte[0] := temp0.byte[1]
   
  'Bring over the data if there is data
  if RSR.word[0] <> 0
   
    'Determine the offset and location to read data from in the W5200
    readSPI((_S0_RX_RD0 + (_socket * $0100)), @temp0, 2)
    pcktptr.byte[1] := temp0.byte[0]
    pcktptr.byte[0] := temp0.byte[1]
    pcktoffset := pcktptr & _RX_mask
    pcktstart := (_RX_base + (_socket * $0800)) + pcktoffset
   
    'Read the header of the packet - the first 8 bytes
    if (pcktoffset + _UDP_header) > constant(_RX_mask + 1)
      'process the header in two parts because the buffers rolls over
      rolloverpoint := constant(_RX_mask + 1) - pcktoffset
      readSPI(pcktstart, _dataPtr, rolloverpoint)
      pcktstart := (_RX_base + (_socket * $0800))
      readSPI(pcktstart, (_dataPtr + rolloverpoint), (_UDP_header - rolloverpoint))
   
    else
      'process the header in one part
      readSPI(pcktstart, _dataPtr, _UDP_header)
   
    'Get the size of the payload portion
    pcktsize := 0                                     'Must be initialized as ASM routine isn't masking the value so a greater than $FF could cause problems
    pcktsize.byte[1] := byte[_dataPtr][6]
    pcktsize.byte[0] := byte[_dataPtr][7]
   
    pcktoffset := (pcktptr + _UDP_header) & _RX_mask
    pcktstart := (_RX_base + (_socket * $0800)) + pcktoffset
    _dataPtr += _UDP_header
   
    'Read the data of the packet
    if (pcktoffset + pcktsize.word[0]) > constant(_RX_mask + 1)
      'process the data in two parts because the buffers rolls over
      rolloverpoint := constant(_RX_mask + 1) - pcktoffset
      readSPI(pcktstart, _dataPtr, rolloverpoint)
      pcktstart := (_RX_base + (_socket * $0800))
      readSPI(pcktstart, (_dataPtr + rolloverpoint), (pcktsize.word[0] - rolloverpoint))
   
    else
      'process the data in one part
      readSPI(pcktstart, _dataPtr, pcktsize.word[0])
   
    'Update the W5200 registers, the packet pointer
    temp0 := (pcktptr + _UDP_header + pcktsize.word[0])
    pcktptr.byte[1] := temp0.byte[0]
    pcktptr.byte[0] := temp0.byte[1]
    writeSPI(true, (_S0_RX_RD0 + (_socket * $0100)), @pcktptr, 2)
   
    'Tell the W5200 we received a packet
    temp0 := _RECV
    writeSPI(true, (_S0_CR + (_socket * $0100)), @temp0, 1)
   
    return (pcktsize.word[0] + _UDP_header)

  return 0 'end of rxUDP

PUB txUDP(_socket, _dataPtr) | temp0, payloadsize, freespace, pcktptr, pcktoffset, pcktstart, rolloverpoint

'' Transmit UDP data on the specified socket and port.  Most of the heavy lifting of transmitting data is handled by the ASM routine,
'' but for effeciency in coding the SPIN routine walks through the process of transmitting data such as verifying and manipulating
'' the various register.  This routine could be completely coded in ASM for faster operation.
''
'' The transmit routine sends only 1 packet of UDP data at a time.  The packet is based on the size of data read in the packet
'' header.  This routine waits for room in the W5200 to send the packet.
''
''  params:  _socket is a value of 0 to 7 - only eight sockets on the W5200
''           _dataPtr is a pointer to the byte(s) of data to read from HUBRAM and sent (use the @ in front of the byte variable)
''  return:  True if data was put in W5200 and told to be sent, otherwise false
''
''  The data packet passed to this routine should be of the form of the following:
''  data[0]..[3] is the destination IP address, data[4],[5] is the destination port, data[6],[7] is the payload size and data[8] starts the payload


  repeat
    readSPI((_S0_SR + (_socket * $0100)), @temp0, 1)
  until temp0.byte[0] & $CF <> $01                            '$11, $21, $31 documented ARP states, $01 undocumented
  'Make sure the socket is open for UDP business
  if temp0.byte[0] <> _SOCK_UDP
    return false
   
  'Get the size of the packet to send, this doesn't include the header info
  payloadsize := 0
  freespace := 0
  payloadsize.byte[1] := byte[_dataPtr][6]                  'hi-byte
  payloadsize.byte[0] := byte[_dataPtr][7]                  'lo-byte
   
  'wait for room in the W5200 to send data
  repeat until (freespace.word[0] > payloadsize.word[0])
    readSPI((_S0_TX_FSRO + (_socket * $0100)), @temp0, 2)
    freespace.byte[1] := temp0.byte[0]
    freespace.byte[0] := temp0.byte[1]
   
  'Tell the W5200 the destination address and destination socket
  writeSPI(true, (_S0_DIPR0 + (_socket * $0100)), _dataPtr, 6)
  _dataPtr += _UDP_header
   
  'Get the place where to start writing the packet in the W5200
  readSPI((_S0_TX_WR0 + (_socket * $0100)), @temp0, 2)
  pcktptr.byte[1] := temp0.byte[0]
  pcktptr.byte[0] := temp0.byte[1]
  pcktoffset := pcktptr & _TX_mask
  pcktstart := (_TX_base + (_socket * $0800)) + pcktoffset
   
  'Write the data based on rolling over in the buffer or not
  if (pcktoffset + payloadsize.word[0]) > constant(_TX_mask + 1)
    'process the data in two parts because the buffers rolls over
    rolloverpoint := constant(_TX_mask + 1) - pcktoffset
    writeSPI(true, pcktstart, _dataPtr, rolloverpoint)
    pcktstart := (_TX_base + (_socket * $0800))
    writeSPI(true, pcktstart, (_dataPtr + rolloverpoint), payloadsize.word[0] - rolloverpoint)
   
  else
    'process the data in one part
    writeSPI(true, pcktstart, _dataPtr, payloadsize.word[0])
   
  'Calculate the packet pointer for the next go around and save it
  'Update the W5200 registers, the packet pointer
  temp0 := (pcktptr + payloadsize.word[0])
  pcktptr.byte[1] := temp0.byte[0]
  pcktptr.byte[0] := temp0.byte[1]
  writeSPI(true, (_S0_TX_WR0 + (_socket * $0100)), @pcktptr, 2)
   
  'Tell the W5200 to send the packet
  temp0 := _SEND
  writeSPI(true, (_S0_CR + (_socket * $0100)), @temp0, 1)
   
   
PUB mutexInit

'' Initialize mutex lock semaphore. Called once at driver initialization if application level locking is needed.
''
'' Returns -1 if no more locks available.

  lock := locknew
  return lock


PUB mutexLock

'' Waits until exclusive access to driver guaranteed.

  repeat until not lockset(lock)


PUB mutexRelease

'' Release mutex lock.

  lockclr(lock)


PUB mutexReturn

'' Returns mutex lock to semaphore pool.

  lockret(lock)


PUB readSPI(_register, _dataPtr, _Numbytes)

'' High level access to SPI routine for reading from the W5200.
'' Note for faster execution of functions code them in assembly routine like the examples of setting the MAC/IP addresses.
''
''  params:  _register is the 2 byte register address.  See the constant block with register definitions
''           _dataPtr is the place to return the byte(s) of data read from the W5200 (use the @ in front of the byte variable)
''           _Numbytes is the number of bytes to read

  'Send the command
  command := _readSPI + @_register
   
  'wait for the command to complete
  repeat while command
   
PUB writeSPI(_block, _register, _dataPtr, _Numbytes)

'' High level access to SPI routine for writing to the W5200.
'' Note for faster execution of functions code them in assembly routine like the examples of setting the MAC/IP addresses.
''
''  params:  _block if true will wait for ASM routine to send before continuing
''           _register is the 2 byte register address. See the constant block with register definitions
''           _dataPtr is a pointer to the byte(s) of data to be written (use the @ in front of the byte variable)
''           _Numbytes is the number of bytes to write

  'Send the command
  command := _writeSPI + @_register
   
  'wait for the command to complete or just move on
  if _block
    repeat while command
   
DAT

''  Assembly language driver for W5200
 
        org
'-----------------------------------------------------------------------------------------------------
'Start of assembly routine
'-----------------------------------------------------------------------------------------------------
Entry
              'Upon starting the ASM cog the first thing to do is set the I/O states and directions.  SPIN already
              'setup the masks for each pin in the defined data section of the routine before starting the COG.

              'Set the initial state of the I/O, unless listed here, the output is initialized as off/low
              mov       outa,   SCSmask         'W5200 SPI slave select is initialized as high

                                                'Remaining outputs initialized as low including reset
                                                'NOTE: the W5200 is held in reset because the pin is low

              'Next set up the I/O with the masks in the direction register...
              '...all outputs pins are set up here because input is the default state
              mov       dira,   SCSmask         'Set to an output and clears cog dira register
              or        dira,   SCLKmask        'Set to an output
              or        dira,   MOSImask        'Set to an output
              or        dira,   RESETmask       'Set to an output
                                                'NOTE: MISOpin isn't here because it is an input

              mov       t0,     _rstTime        'Time to hold IC in reset
              add       t0,     cnt             'Add in the current system counter
              waitcnt   t0,     _UnrstTime      'Wait 2.5 us

              or        outa,   RESETmask       'Finally - make the reset line high for the W5200 to come out of reset
              waitcnt   t0,     _UnrstTime      'Time to wait to come out of reset - 250 ms

              'While the W5200 is coming out of reset initialize any COG counter values
              mov       frqb,   #0              'Counter B is used as a special register. Frq is set to 0 so there isn't accumulation.
              mov       ctrb,   ctrbmode        'This turns Counter B on. The main purpose is to have phsb[31] bit appear on the MOSI line.

'-----------------------------------------------------------------------------------------------------
'Main loop
'wait for a command to come in and then process it.
'-----------------------------------------------------------------------------------------------------
CmdWait
              rdlong    cmdAdrLen, par      wz  'Check for a command being present
        if_z  jmp       #CmdWait                'If there is no command, check again

              mov       t1, cmdAdrLen           'Take a copy of the command/address combo to work on
              rdlong    paramA, t1              'Get parameter A value
              add       t1, #4                  'Increment the address pointer by four bytes
              rdlong    paramB, t1              'Get parameter B value
              add       t1, #4                  'Increment the address pointer by four bytes
              rdlong    paramC, t1              'Get parameter C value
              add       t1, #4                  'Increment the address pointer by four bytes
              rdlong    paramD, t1              'Get parameter D value
              add       t1, #4                  'Increment the address pointer by four bytes
              rdlong    paramE, t1              'Get parameter E value

              mov       t0, cmdAdrLen           'Take a copy of the command/address combo to work on
              shr       t0, #16            wz   'Get the command
              cmp       t0, #(_lastCmd>>16)+1 wc 'Check for valid command
  if_z_or_nc  jmp       #:CmdExit               'Command is invalid so exit loop
              shl       t0, #1                  'Shift left, multiply by two
              add       t0, #:CmdTable-2        'add in the "call" address"
              jmp       t0                      'Jump to the command

              'The table of commands that can be called
:CmdTable     call      #rSPIcmd                'Read a byte from the W5200 - high level call
              jmp       #:CmdExit
              call      #wSPIcmd                'Write a byte to the W5200 - high level call
              jmp       #:CmdExit
              call      #wMAC                   'Write the MAC ID
              jmp       #:CmdExit
              call      #wGateway               'Write the Gateway address
              jmp       #:CmdExit
              call      #wSubnet                'Write the Subnet address
              jmp       #:CmdExit
              call      #wIP                    'Write the IP address
              jmp       #:CmdExit
              call      #rMAC                   'Read the MAC ID
              jmp       #:CmdExit
              call      #rGateway               'Read the Gateway address
              jmp       #:CmdExit
              call      #rSubnet                'Read the Subnet address
              jmp       #:CmdExit
              call      #rIP                    'Read the IP Address
              jmp       #:CmdExit
              call      #pingBlk                'Enable/disable a ping response
              jmp       #:CmdExit
              call      #rstHW                  'Hardware reset of W5200
              jmp       #:CmdExit
              call      #rstSW                  'Software reset of W5200
              jmp       #:CmdExit
              call      #sOPEN                  'Open a socket
              jmp       #:CmdExit
              call      #sDISCON                'Disconnect a socket
              jmp       #:CmdExit
              call      #sCLOSE                 'Close a socket
              jmp       #:CmdExit
              call      #LastCMD                'PlaceHolder for last command
              jmp       #:CmdExit
:CmdTableEnd

              'End of processing a command
:CmdExit      wrlong    _zero,  par             'Clear the command status
              jmp       #CmdWait                'Go back to waiting for a new command

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to read a register from the W5200 - a high level call
'-----------------------------------------------------------------------------------------------------
rSPIcmd
              mov       reg,    paramA          'Move the register address into a variable for processing
              mov       ram,    ParamB          'Move the address of the returned byte into a variable for processing
              mov       ctr,    ParamC          'Set up a counter for number of bytes to process

              call      #ReadMulti              'Read the byte from the W5200

rSPIcmd_ret ret                                 'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to write a register in the W5200 - a high level call
'-----------------------------------------------------------------------------------------------------
wSPIcmd
              mov       reg,    paramA          'Move the register address into a variable for processing
              mov       ram,    paramB          'Move the data byte into a variable for processing
              mov       ctr,    ParamC          'Set up a counter for number of bytes to process

              call      #writeMulti             'Write the byte to the W5200

wSPIcmd_ret ret                                 'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to write the MAC ID in the W5200
'-----------------------------------------------------------------------------------------------------
wMAC
              mov       reg,    #_SHAR0         'Move the MAC ID register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the MAC ID array into a variable for processing
              mov       ctr,    #6              'Set up a counter of 6 bytes

              call      #WriteMulti             'Write the bytes out to the W5200

wMAC_ret ret                                    'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to write the Gateway address in the W5200
'-----------------------------------------------------------------------------------------------------
wGateway
              mov       reg,    #_GAR0          'Move the gateway register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the gateway address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes

              call      #WriteMulti             'Write the bytes out to the W5200

wGateway_ret ret                                'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to write the Subnet address in the W5200
'-----------------------------------------------------------------------------------------------------
wSubnet
              mov       reg,    #_SUBR0         'Move the subnet register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the subnet address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes

              call      #WriteMulti             'Write the bytes out to the W5200

wSubnet_ret ret                                 'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to write the IP address in the W5200
'-----------------------------------------------------------------------------------------------------
wIP
              mov       reg,    #_SIPR0         'Move the IP register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the IP address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes

              call      #WriteMulti             'Write the bytes out to the W5200

wIP_ret ret                                     'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to Read the MAC ID in the W5200
'-----------------------------------------------------------------------------------------------------
rMAC
              mov       reg,    #_SHAR0         'Move the MAC ID register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the MAC ID array into a variable for processing
              mov       ctr,    #6              'Set up a counter of 6 bytes

              call      #ReadMulti              'Read the bytes from the W5200

rMAC_ret ret                                    'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to Read the Gateway address in the W5200
'-----------------------------------------------------------------------------------------------------
rGateway
              mov       reg,    #_GAR0          'Move the gateway register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the gateway address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes

              call      #ReadMulti              'Read the bytes from the W5200

rGateway_ret ret                                'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to Read the Subnet address in the W5200
'-----------------------------------------------------------------------------------------------------
rSubnet
              mov       reg,    #_SUBR0         'Move the subnet register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the subnet address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes

              call      #ReadMulti              'Read the bytes from the W5200

rSubnet_ret ret                                 'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine to Read the IP address in the W5200
'-----------------------------------------------------------------------------------------------------
rIP
              mov       reg,    #_SIPR0         'Move the IP register address into a variable for processing
              mov       ram,    cmdAdrLen       'Move the address of the IP address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes

              call      #ReadMulti              'Read the bytes from the W5200

rIP_ret ret                                     'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine for enabling/disabling a ping response by the W5200, true = blocked, false = not blocked
'-----------------------------------------------------------------------------------------------------
pingBlk
              mov       reg,    #_MR            'Move the mode register address into a variable for processing
              call      #ReadSingle             'Read the byte from the W5200

              rdlong    t0,     cmdAdrLen       'Read the bool from SPIN command and place in a variable for testing
              cmp       t0,     #0         wz   'Is the value zero or non-zero?
        if_z  andn      data,   #_PBMode        'Disable ping blocking - W5200 will respond to a ping
        if_nz or        data,   #_PBMode        'Enable ping blocking - W5200 will not respond to a ping

              call      #writeSingle            'Write the byte to the W5200

pingBlk_ret ret                                 'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine for resetting the W5200 via hardware
'-----------------------------------------------------------------------------------------------------
rstHW
              andn      outa,   RESETmask       'Toggle the reset line low - resets the W5200

              mov       t0,     _rstTime        'Time to hold IC in reset
              add       t0,     cnt             'Add in the current system counter
              waitcnt   t0,     _UnrstTime      'Wait

              or        outa,   RESETmask       'Finally - make the reset line high for the W5200 to come out of reset
              waitcnt   t0,     _UnrstTime      'Time to wait to come out of reset

rstHW_ret ret                                   'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine for resetting the W5200 via software
'-----------------------------------------------------------------------------------------------------
rstSW
              mov       reg,    #_MR            'Move the mode register address into a variable for processing
              call      #ReadSingle             'Read the byte from the W5200
              or        data,   #_RSTMODE       'Software reset
              call      #writeSingle            'Write the byte to the W5200

              mov       t0,     _UnrstTime      'Time to wait to come out of reset
              add       t0,     cnt             'Add in the current system counter
              waitcnt   t0,     #0              'Wait

rstSW_ret ret                                   'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine for opening a socket
'-----------------------------------------------------------------------------------------------------
sOPEN
              mov       t0, paramA              'Move the socket number into t0 ($000s)
              shl       t0, #8                  'Move the socket number to the third digit ($0s00). This is the offset to use for below ops.

              'set the mode
              mov       reg, _S0_MR_d           'Move the register address into a variable for processing
              add       reg, t0                 'Add in the particular socket to be worked on
              mov       data, paramB            'Move over the socket type
              call      #WriteSingle            'Write the byte to the W5200

              'set the source port
              mov       reg, _S0_PORT1_d        'Move the register address into a variable for processing
              add       reg, t0                 'Add in the offset for the particular socket to be worked on
              mov       data, paramC            'Move over the source socket value
              call      #WriteSingle            'Write the byte to the W5200
              sub       reg, #1                 'Increment the register address
              mov       data, paramC            'Move over the source socket value
              shr       data, #8                'shift the data over one byte
              call      #WriteSingle            'Write the byte to the W5200

              'set the destination port
              mov       reg, _S0_DPORT1_d       'Move the register address into a variable for processing
              add       reg, t0                 'Add in the offset for the particular socket to be worked on
              mov       data, paramD            'Move over the destination socket value
              call      #WriteSingle            'Write the byte to the W5200
              sub       reg, #1                 'Increment the register address
              mov       data, paramD            'Move over the destination socket value
              shr       data, #8                'shift the data over one byte
              call      #WriteSingle            'Write the byte to the W5200

              'set the destination IP
              mov       reg,    _S0_DIPR0_d     'Move the register address into a variable for processing
              add       reg,    t0              'Add in the offset for the particular socket to be worked on
              mov       ram,    paramE          'Move the address of the IP address array into a variable for processing
              mov       ctr,    #4              'Set up a counter of 4 bytes
              call      #WriteMulti             'Write the bytes out to the W5200

              'set the port open
              mov       reg,    _S0_CR_d        'Move the register address into a variable for processing
              add       reg,    t0              'Add in the offset for the particular socket to be worked on
              mov       data,   #_OPEN          'Move over the command
              call      #WriteSingle            'Write the byte to the W5200

sOPEN_ret ret                                   'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine for disconnecting a socket
'-----------------------------------------------------------------------------------------------------
sDISCON
              mov       t0,     paramA          'Move the socket number into t0 ($000s)
              shl       t0,     #8              'Move the socket number to the third digit ($0s00). This is the offset to use for below ops.

              'set the port to disconnect
              mov       reg,    _S0_CR_d        'Move the register address into a variable for processing
              add       reg,    t0              'Add in the offset for the particular socket to be worked on
              mov       data,   #_DISCON        'Move over the command
              call      #WriteSingle            'Write the byte to the W5200

sDISCON_ret ret                                 'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine for closing a socket
'-----------------------------------------------------------------------------------------------------
sCLOSE
              mov       t0,     paramA          'Move the socket number into t0 ($000s)
              shl       t0,     #8              'Move the socket number to the third digit ($0s00). This is the offset to use for below ops.

              'set the port close
              mov       reg,    _S0_CR_d        'Move the register address into a variable for processing
              add       reg,    t0              'Add in the offset for the particular socket to be worked on
              mov       data,   #_CLOSE         'Move over the command
              call      #WriteSingle            'Write the byte to the W5200

sCLOSE_ret ret                                  'Command execution complete

'-----------------------------------------------------------------------------------------------------
'Command sub-routine holding place
'-----------------------------------------------------------------------------------------------------
LastCMD

LastCMD_ret ret                                 'Command execution complete

'=====================================================================================================

'-----------------------------------------------------------------------------------------------------
'Sub-routine to map write to SPI
' NOTE: Data and Reg setup must be done before calling this routine
'-----------------------------------------------------------------------------------------------------
WriteSingle
              mov       dataLen, #1             'Single byte of data
              call      #wSPI                   'Clock the data out
              call      #wSPI_Data              'Write the data byte
              or        outa,scsmask            'De-assert CS 
WriteSingle_ret ret                             'Return to the calling code

'-----------------------------------------------------------------------------------------------------
'Sub-routine to map read to SPI 
' NOTE: Reg setup must be done before calling this routine   
'-----------------------------------------------------------------------------------------------------
ReadSingle
              mov       dataLen, #1             'Single byte of data 
              call      #rSPI                   'send the read command
              call      #rSPI_Data              'Read the data byte 
              and       data,   _bytemask       'Ensure there is only a byte
              or        outa,scsmask            'De-assert CS 
ReadSingle_ret ret                              'Return to the calling code
'-----------------------------------------------------------------------------------------------------
'Sub-routine to map write to SPI and to loop through bytes
' NOTE: RAM, Reg, and CTR setup must be done before calling this routine
'-----------------------------------------------------------------------------------------------------
WriteMulti
              'mov      datalen,#1
              mov       dataLen, ctr            'data length for burst write  
              call      #wSPI                   'send the burst write command
                 
:bytes        
              rdbyte    data,   ram             'Read the byte/octet from hubram           
              call      #wSPI_Data              'write one byte to W5200
              
              add       reg,    #1              'Increment the register address by one byte
              add       ram,    #1              'Increment the hubram address by one byte
              djnz      ctr,    #:bytes         'Check if there is another byte, if so, process it
              or        outa,scsmask            'De-assert CS  
WriteMulti_ret ret                              'Return to the calling code

'-----------------------------------------------------------------------------------------------------
'Sub-routine to map read to SPI and to loop through bytes
' NOTE: Reg, and CTR setup must be done before calling this routine
'-----------------------------------------------------------------------------------------------------

ReadMulti     mov       dataLen, ctr            '# of bytes to read in one burst
              call      #rSPI                   'send the burst read command to the W5200
:bytes         
              call      #rSPI_Data              'read one data byte from the W5200   1.15us
              and       data,   _bytemask       'Ensure there is only a byte   +20 clocks in this loop = 1.4us/byte
              wrbyte    data,   ram             'Write the byte to hubram
              add       reg,    #1              'Increment the register address by one byte
              add       ram,    #1              'Increment the hubram address by one byte
              djnz      ctr,    #:bytes         'Check if there is another if so, process it
              or        outa,scsmask            'finally de-assert CS 

ReadMulti_ret ret                               'Return to the calling code

'-----------------------------------------------------------------------------------------------------
'Sub-routine to write data to W5200 via SPI
'-----------------------------------------------------------------------------------------------------
wSPI
'High speed serial driver utilizing the counter modules. Counter A is the clock while Counter B is used as a special register
'to get the data on the output line in one clock cycle. This code is meant to run on 80MHz. processor and the code clocks data
'at 20MHz. Populate reg and data before calling this routine.

              andn      outa,   SCLKmask        'turn the clock off, ensure it is low before placing data on the line
              
              'Preamble
              mov       phsb,   reg             'Add register address (16 bits) to the packet
              shl       phsb,   #1              'Make room (1 bit) for the write operation (OpCode)
              or        phsb,   #1              'Add in a write operation in phsb (OpCode)   
              shl       phsb,   #15             'Make room (15 bits) for the and Data Length
              or        phsb,   dataLen         'Add Data Length - 32 bits added, buffer full!
              
              andn      outa,   SCSmask         'Begin the data transmission by enabling SPI mode - making line go low

              mov       frqa,   frq20           'Setup the writing frequency for 20mhz 08/15/2012
              mov       phsa,   phs20           'Setup the writing phase of data/clock
              
              mov       ctra,   ctramode        'Turn on Counter A to start clocking                                                                                                                                                                                                                                            
              rol       phsb,   #1              'NOTE: First bit is clocked just as soon as the clock turns on
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              mov       ctra,   #0              '32 bits sent - Turn off the clocking                                          
wSPI_ret      ret                               'wSPI return

wSPI_Data
              mov       phsb,   #0
              mov       phsb,   data            'Add in the data, to be clocked out
              shl       phsb,   #24
              mov       frqa,   frq20           'Setup the writing frequency  08/15/2012 modified for 20mhz writes
              mov       phsa,   phs20           'Setup the writing phase of data/clock
              mov       ctra,   ctramode        'Turn on Counter A to start clocking
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              mov       ctra,   #0              '8 bits sent - Turn off the clocking
wSPI_Data_ret ret                               'Return to the calling loop

'-----------------------------------------------------------------------------------------------------
'Sub-routine to read data from W5200 via SPI (Note that it must write in order to read)
'-----------------------------------------------------------------------------------------------------
rSPI
'High speed serial driver utilizing the counter modules. Counter A is the clock while Counter B is used as a special register
'to get the data on the output line in one clock cycle. This code is meant to run on 80MHz. processor and the code clocks data
'at 10MHz. 

              andn      outa,   SCLKmask        'turn the clock off, ensure it is low before placing data on the line

              mov       phsb,   reg             'Add register address (16 bits) to the packet
              shl       phsb,   #1              'Make room (1 bit) for the write operation (OpCode)
              or        phsb,   #0              'Add in a read operation in phsb (OpCode)    
              shl       phsb,   #15             'Make room (15 bits) for the and Data Length
              or        phsb,   dataLen         'Add Data Length - 32 bits added, buffer full!   

              andn      outa,   SCSmask         'Begin the data transmission by enabling SPI mode - making line go low

              mov       frqa,   frq20           'Setup the writing frequency  for 20mhz 08/15/2012
              mov       phsa,   phs20           'Setup the writing phase of data/clock for 20mhz 08/15/2012
              
              mov       ctra,   ctramode        'Turn on Counter A to start clocking                                                                                                                                                         
              rol       phsb,   #1              'NOTE: First bit is clocked just as soon as the clock turns on
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              rol       phsb,   #1
              mov       ctra,   #0              '32 bits sent - Turn off the clocking
rSPI_ret      ret

rSPI_Data
              mov       frqa, frq10             '10MHz read frequency  read speed the same 'cause we can't shorten the 
              mov       phsa, phs10             'start phs for clock   2-instructions per bit read code 08/15/2012
              nop
              mov       ctra, ctramode          'start clocking
              test      MISOmask, ina wc        'Gather data, to be clocked in       
              rcl       data, #1                'Data bit 0
              test      MISOmask, ina wc        
              rcl       data, #1                'Data bit 1 
              test      MISOmask, ina wc        
              rcl       data, #1                'Data bit 2 
              test      MISOmask, ina wc        
              rcl       data, #1                'Data bit 3  
              test      MISOmask, ina wc        
              rcl       data, #1                'Data bit 4 
              test      MISOmask, ina wc        
              rcl       data, #1                'Data bit 5 
              test      MISOmask, ina wc        
              rcl       data, #1                'Data bit 6 
              test      MISOmask, ina wc        
              mov       ctra, #0                'Turn off the clocking immediately, otherwise might get odd behavior 
              rcl       data, #1                'Data bit 7 
rSPI_Data_ret ret                               'Return to the calling loop

'==========================================================================================================
'Defined data
_zero         long      0       'Zero
_bytemask     long      $FF     'Byte mask
_rstTime      long      200     'Time to hold in reset  (2.5us)
_UnrstTime    long      16_000_000 'Time to wait after coming out of reset  (200ms)

'Pin/mask definitions are initianlized in SPIN and program/memory modified here before the COG is started
SCSmask       long      0-0     'W5200 SPI slave select - active low, output
SCLKmask      long      0-0     'W5200 SPI clock - output
MOSImask      long      0-0     'W5200 Master out slave in - output
MISOmask      long      0-0     'W5200 Master in slave out - input
RESETmask     long      0-0     'W5200 Reset - active low, output

'NOTE: Data that is initialized in SPIN and program/memory modified here before COG is started
ctramode      long      0-0     'Counter A for the COG is used a serial clock line = SCLK
                                'Counter A has phsa and frqa loaded appropriately to create a clock cycle
                                'on the configured APIN

ctrbmode      long      0-0     'Counter B for the COG is used as the data output = MOSI
                                'Counter B isn't really used as a counter per se, but as a special register
                                'that can quickly output data onto an I/O pin in one instruction using the
                                'behavior of the phsb register where phsb[31] = APIN of the counter

frq20         long      $4000_0000             'Counter A & B's frqa register setting for reading data from W5200. 08/15/2012
                                               'This value is the system clock divided by 4 i.e. CLKFREQ/4 (80MHz clk = 20MHz)
phs20         long      $5000_0000             'Counter A & B's phsa register setting for reading data from W5200.   08/15/2012
                                                'This sets the relationship of the MOSI line to the clock line.  Note have not tried
                                                'other values to determine if there is a "sweet sdpot" for phase... 08/15/2012
frq10         long      $2000_0000              'need to keep 10mhz vaues also, because read is maxed at 10mhz
phs10         long      $6000_0000              '08/15/2012

'Data defined in constant section, but needed in the ASM for program operation
_S0_MR_d      long      _S0_MR
_S0_PORT1_d   long      _S0_PORT1
_S0_DPORT1_d  long      _S0_DPORT1
_S0_DIPR0_d   long      _S0_DIPR0
_S0_CR_d      long      _S0_CR


'==========================================================================================================
'Uninitialized data - temporary variables
t0            res 1     'temp0
t1            res 1     'temp1

'Parameters read from commands passed into the ASM routine
cmdAdrLen     res 1     'Combo of address, ocommand and data length into ASM
paramA        res 1     'Parameter A
paramB        res 1     'Parameter B
paramC        res 1     'Parameter C
paramD        res 1     'Parameter D
paramE        res 1     'Parameter E

reg           res 1     'Register address of W5200 for processing
dataLen       res 1     'Data Length for packet
data          res 1     'Data read to/from the W5200  
ram           res 1     'Ram address of Prop Hubram for reading/writing data from
ctr           res 1     'Counter of bytes for looping

              fit 496   'Ensure the ASM program and defined/res variables fit in a single COG.

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