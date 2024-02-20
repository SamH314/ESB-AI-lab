# Real Time Clock Documentation

#### Author: Sammy Hernandez 

## Introduction
To keep them affordable, Raspberry Pi's do not inclued a Real Time Clock (RTC). An RTC is necessary for devices that won't be able to to connect to the wifi to retrieve the time. 

## Settings
`Run sudo raspi-config` 
<br>Under interfacing options enable I2C and exit
`Sudo reboot` to enable changes 
<br>Connect RTC to the Raspberry Pi 

## Helper Software
`Sudo apt-get install python-smbus i2c-tools`
<br> The packages provides a set of command-line tools for interacting with I2C devices.
<br> Running ` sudo i2cdetect -y 1` should return the I2C bus 1 for devices and display a grid showing which addresses are currently in use by connected devices. In our case we will see 68.

##
