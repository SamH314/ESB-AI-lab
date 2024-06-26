# Real Time Clock Documentation

#### Author: Sammy Hernandez 

## Introduction
To keep them affordable, Raspberry Pi's do not inclued a Real Time Clock (RTC). An RTC is necessary for devices that won't be able to to connect to the wifi to retrieve the time. 

## Settings
`Run sudo raspi-config` 
<br>Under interfacing options enable I2C and exit.
<br>`Sudo reboot` to enable changes.
<br>Connect RTC to the Raspberry Pi.

## Helper Software
`Sudo apt-get install python-smbus i2c-tools`
<br> The packages provides a set of command-line tools for interacting with I2C devices.
<br> Running ` sudo i2cdetect -y 1` should return the I2C bus 1 for devices and display a grid showing which addresses are currently in use by connected devices. In our case we will see 68.

## Modifications 
Check what RTC model you have. It should say at top corner, next to the battery. 
<br>`sudo nano /boot/config.txt` to edit the Raspberry Pi's config text file.
<br>At the end of the file, add `dtoverlay=i2c-rtc,[Specific RTC model` to enable support for the RTC module by overlaying the necessary device tree configuration onto the base device tree.
<br>`sudo reboot` so that the Raspberry Pi system loads the necessary drivers and configurations.
<br>You should now get "UU" instead of 68 when you run `sudoi2cdetect -y 1` again. The "UU" indicates that the I2C address is in use by a driver and is currently unavailable for use by other devices. It's often used as a placeholder to show that the address is claimed.

## Hwclock

We need to disable the "fake-hwclock" software and their associated startup configuration by running the following commands:
```
sudo apt-get -y remove fake-hwclock
sudo update-rc.d -f fake-hwclock remove
sudo systemctl disable fake-hwclock
```
<br>`sudo nano /lib/udev/hwclock-set` and comment out the following lines by adding a “#” to the front. By commenting out these lines, you prevent the script from exiting prematurely based on the presence of systemd, which would interfere with the hardware clock setup.
```
#if [ -e /run/systemd/system ] ; then
# exit 0
#fi
```
<br> If this lines are present, comment them out too. They are responsible for setting the hardware clock (hwclock) from the system time (systz). We do not want the hardware clock to be synchronized with the system time during boot-up.
<br>`/sbin/hwclock --rtc=$dev --systz --badyear` 
<br>`/sbin/hwclock --rtc=$dev --systz`

Run `sudo hwclock -r` which returns the current time on the RTC. Most likely it is the wrong time. 
<br>We can manually set the time by running `sudo hwclock --set --date=[YYYY-MM-DD HH:MM:SS]`
<br>Congratulations, that's it!


