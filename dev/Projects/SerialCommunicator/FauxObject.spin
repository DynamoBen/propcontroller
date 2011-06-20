CON
  NUMOPTIONS = 6
VAR
'Output Variables
  long bffrPtrFaux[NUMOPTIONS]  'Holds pointer to options
  byte numToOutput              'Number of options to output this time around
  word tier                     'The level that the menu is currently on                        
PUB start
  tier := 1
  updateBffrs 
PUB updateBffrs | idx
  case tier
    1: numToOutput := NumTier1
       bffrPtrFaux[0] := @Tier11
       bffrPtrFaux[1] := @Tier12
       bffrPtrFaux[2] := @Tier13 
    11: numtoOutput := NumTier11
        bffrPtrFaux[0] := @Tier111
        bffrPtrFaux[1] := @Tier112
    12: numtoOutput := NumTier12
        bffrPtrFaux[0] := @Tier121
        bffrPtrFaux[1] := @Tier122
        bffrPtrFaux[2] := @Tier123
        bffrPtrFaux[3] := @Tier124
        bffrPtrFaux[4] := @Tier125
' Updates the numbers stored in the bffrPtrFaux to hold the correct addresses of strings.    
PUB getAddress(_num)
' return pointer to option string number
  result := bffrPtrFaux[_num]
PUB getNumToOutput
  result := numToOutput
' return number of options to output
PUB getTier
  result := tier
' returns current tier
PUB choiceMade(_choice)
  'Account for ascii offset
  _choice := _choice - 48
  ' 0 is quit
  if _choice == 0
    tier := tier/10
   'multiply by 10 and add choice to create new tier level 
  else
    tier := tier * 10 + _choice      
DAT                                                
NumTier1      byte 3
Tier11        byte "User Settings", 0
Tier12        byte "Input Settigns", 0
Tier13        byte "Output Settings", 0

NumTier11     byte 2
Tier111       byte "Firmware Version", 0
Tier112       byte "Device Name", 0

NumTier12     byte 5
Tier121       byte "Socket Setup", 0
Tier122       byte "IP Address", 0
Tier123       byte "MAC Address", 0
Tier124       byte "Gateway", 0
Tier125       byte "Destination IP", 0
        