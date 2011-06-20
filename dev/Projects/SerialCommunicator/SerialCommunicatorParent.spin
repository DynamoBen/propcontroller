{{SerialCommunicator.spin
For Use with the PropController Ethernet and DMX boards,
and other boards based off the hardware design.
}}
CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000
CON
  MAX_NUM_OPTIONS = 8                                   'Define as the maximum number of options used
OBJ
  pst:          "Parallax Serial Terminal"
  object:       "FauxObject"                            ' random fake object to communicate with
  numFMT:          "Numbers"                               ' used for formatting etc.
  strFMT:       "ASCII0 String Engine"                  ' string engine                       
VAR
  long bffrPtr[MAX_NUM_OPTIONS]                         ' Stores pointers to strings to output to screen
  long tier                                             ' Stores current tier
  byte numToOutput                                      ' Stores the number of options to output to screen

'Serial Variables
  long rcvdGood                                         ' Holds number of stored good packets
                                                        ' currently holds number of recieved bytes since reset
  long rcvdBad                                          ' Holds number of stored bad packets

PUB Main
' Start Numbers
  numFMT.init

' Time to start Parallax Serial Terminal App
  waitcnt(cnt + clkfreq * 6)
' Start Serial Terminal
  pst.Start(115_200)

' Setup Variables
  tier := 1
  updateBufferArray
' Loop to print output and read input
  repeat
    writeMenu
    changeTier(pst.CharIn)
    rcvdGood++
  
PUB changeTier(_newChoice)
{{Called when input is given to update the current tier variable.
  -Calls updateBufferArray to load the new tier's data into the pointer array}}
  _newChoice := _newChoice - 48
  if _newChoice == 0
    if tier == 1
      tier := 1
    else
      tier /= 10
  else
    tier := (tier * 10) + _newChoice
    
  updateBufferArray
  
PUB writeMenu | idx
{{Writes the Current menu stored in the buffer to the computer
  -Uses numToOutput to print out only as many options as needed
  -Calls on pst object (Parallax Serial Terminal or Compatible
  -Requires Header to be defined as first line of output
  -Requires Config to be defined as second line of output
  -Prints 0 to exit option if not in tier 1 }}
  pst.Clear
  pst.Str(@Header)
  pst.NewLine
  pst.Str(@Config)
  pst.NewLine
  pst.NewLine
  'DEBUG
  'pst.Bin(tier, 8)

  repeat idx from 0 to numToOutput - 1
    writeItem(idx + 1, bffrPtr[idx])

  ifnot tier == 1
    writeItem(0, @Back)  

PUB writeItem(_num, _itemAddr)
{{Writes a single item to screen
  -_num is the number of the option to print out before
  -_itemAddr is the address of where the byte array of characters is
  -Colon must be defined as ":", 0 }}
  pst.Tab
  pst.Dec(_num)
  pst.Str(@Colon)
  pst.Str(_itemAddr)
  pst.NewLine
PUB updateBufferArray
{{Updates pointer array based on current tier
  -Object must be built by hand for each tier }}
  case tier
    1:  bffrPtr[0] := @Tier11
        bffrPtr[1] := @Tier12
        bffrPtr[2] := @Tier13
        numToOutput := NumTier1
    11:  bffrPtr[0] := @Tier111
         bffrPtr[1] := @Tier112
         numToOutput := NumTier11
    111:  numToOutput := NumTier111
          bffrPtr[0] := @Tier1111
          bffrPtr[1] := numFMT.ToStr(rcvdGood, numFMT#DDEC)
          bffrPtr[2] := @Tier1113
    1111, 1112: tier := 111
                updateBufferArray
    1113: rcvdGood := 0
          tier := 111
          updateBufferArray  
    12: 'Load from sACN
    13: 'Load from cog used
DAT
Header        byte      "PropController", 0
Config        byte      "Config: Serial Communicator    Author: Joshua Moyerman", 0
Back          byte      "Exit this level", 0
Colon         byte      ":", 0

' Main Tier
NumTier1      byte      3
Tier11        byte      "Controller Statistics", 0
Tier12        byte      "Input Settings", 0
Tier13        byte      "Output Settings", 0

' Controller Statistics
NumTier11     byte      2
Tier111       byte      "Recieved Packets Good", 0
Tier112       byte      "Recieved Packets Failed", 0
' Controller Statistics -> Recieved Packets Good
NumTier111    byte      3
Tier1111      byte      "Current Recieved Packets Good: ",  0
Tier1113      byte      "Reset Current Packet Count", 0

