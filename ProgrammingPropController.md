# Programming the PropController #
There are two ways to program the PropController using source code. The first method is with the Propeller/Spin Tool Software. The second method is with Propellent Executable. Both methods require you to download all the source files to a local folder on your PC.

### With Propeller/Spin Tool Software (IDE) ###
Download Propeller/Spin Tool Software from the Parallax website:
http://www.parallax.com/ProductInfo/Microcontrollers/PropellerGeneralInformation/PropellerMediaPage/tabid/832/Default.aspx#Software

Please review the Parallax Propeller user manual for details about compiling the code and programming the Propeller's RAM and EEPROM.

### With Propellent (Non-IDE) ###
Download Propellent from the Parallax website:
http://www.parallax.com/ProductInfo/Microcontrollers/PropellerGeneralInformation/PropellerMediaPage/tabid/832/Default.aspx#Software

**NOTE: The USB driver must be installed before this application can program the PropController. The USB driver is part of the downloaded zip.**

To Compile and download PropController application to Propeller's RAM and EEPROM from the C:\DMX\_128 or C:\ETH\_128 folders type the following at a command prompt.

PropController (DMX):
> Propellent.exe /eeprom C:\DMX\_128\PropControllerDMX.spin

PropController (Ethernet):
> Propellent.exe /eeprom C:\ETH\_128\PropControllerEth.spin

