# Raspberry Pi Documentation 

### Authors: Samuel Hernandez, Dania Santiago, Pedro Castaneda 

## Introduction
Setting up a Raspberry Pi for image/video capturing.

## Disabling Wifi, Bluetooth, and led Permanently 
In the terminal, run the command `Sudo nano /boot/config.txt`. This will open the config text file that will let us edit the Raspi's configuration file. Scroll all the way down to Under [all]:
```
[all]
Add dtoverlay=disable-wifi //disable Wi-Fi.
Add dtoverlay=disable-bt //disable Bluetooth.
dtparam=act_led_trigger=none //disable led
```
## SSH to the Pi Locally
Make sure both the machine you're trying to access the pi from and the pi are connected to the same wifi. If you're running the pi with no desktop enviroment, you're going to want to connect the pi to the wifi by creating a `wpa_supplicant.conf` file in the pi's sd card and editing it to:
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev  
update_config=1
country=<Insert 2 letter ISO 3166-1 country code here>
network={
    ssid="WIFI_NAME"
    psk="WIFI_PASSWORD"
}
```  
In order to get the IP address of the Raspberry pi, in the terminal of your local machine run: `ping raspberrypi.local`. This command will infinetly display the IP address of the Raspberry pi, so make sure to `ctrl+c` out of it. With this information, you are able to ssh into the raspberry locally by running from your local terminal:`ssh pi@<IP_ADDRESS>`. It's going to ask you if you're sure that you want to continue connecting, go ahead and type yes. It's then going to prompt us for the password. Go ahead and type that in. The default password is `raspberry` in case you don't have that configured. There you go, you should be able to ssh locally.

## Making a Shell Script
Navigate to the directory where you want to save the script, or alternatively add the absolute path. Then open the Nano text editor and create a new file named example.sh by entering this at the command prompt:  
`sudo nano example.sh`  
Now, you are able to add code into your bash file:  
```
#!/bin/bash

<CODE_GOES_HERE>
```
The first line of this program, #!/bin/sh, is called a shebang. Every shell script you create will need this on the first line of the script. This tells the BASH shell to execute the commands in the script.

Exit and save the file in Nano by pressing `Ctrl+X` to save and exit. To make this command executable, enter this in the command prompt:  
`sudo chmod +x example.sh`  
Now that the shell script has been made executable, we can run it. Navigate to the directory where the file is saved or alternatively the absolute path, and enter this:

`sh example.sh`

or

`./example.sh`


## Bash Script to Record
```
#!/bin/bash

set -e

DATE=$(date +"%Y-%m-%d %H:%M:%S")
echo "$DATE" 
SNAPSHOTS_DIR=/home/pi/vids
SNAPSHOT_PATH="$SNAPSHOTS_DIR/$DATE.h264"
SNAPSHOT_PATH_MP4="$SNAPSHOTS_DIR/$DATE.mp4"

mkdir -p "$SNAPSHOTS_DIR"

libcamera-vid --width 1280 --height 720 --level 4.2 --denoise cdn_off --framerate 120  -n -t 30000 -o "$SNAPSHOT_PATH" 
ffmpeg -framerate 120 -i "$SNAPSHOT_PATH" -c copy "$SNAPSHOT_PATH_MP4" 
rm "$SNAPSHOT_PATH"
```
`set -e`: This command tells the shell to immediately exit if any command returns a non-zero exit status, which is typically used to ensure that the script stops running if any errors occur.

`DATE=$(date +"%Y-%m-%d %H:%M:%S")`: This line captures the current date and time using the date command with the specified format, and stores it in the DATE variable.

`SNAPSHOT_PATH="$SNAPSHOTS_DIR/$DATE.h264"`: This line constructs the file path for the video snapshot file using the current date and time.

`SNAPSHOT_PATH_MP4="$SNAPSHOTS_DIR/$DATE.mp4"`: This line sets the file path for the converted MP4 version of the snapshot.

`mkdir -p "$SNAPSHOTS_DIR"`: This command creates the directory specified by SNAPSHOTS_DIR if it does not already exist. The -p option ensures that the command does not return an error if the directory already exists.

`libcamera-vid ...`: This command captures a video snapshot using the libcamera-vid utility with the specified parameters such as width, height, denoise level, framerate, duration, and output file path ("$SNAPSHOT_PATH").

`ffmpeg ...`: This command converts the captured H.264 video snapshot ("$SNAPSHOT_PATH") to MP4 format ("$SNAPSHOT_PATH_MP4") using ffmpeg without any transcoding (-c copy). It preserves the original quality and avoids unnecessary processing.

`rm "$SNAPSHOT_PATH"`: This command removes the original H.264 video snapshot file after it has been converted to MP4 format to save disk space.

## Running a Shell script Indefinite at Boot
Create a new Shell Script (in this example i'll call it forever.sh) and inside add the following code:  
```
#!/bin/bash

while :; do
        sh /home/pi/videolapse.sh
        sleep 1 
done
```  
This script runs an infinite loop that executes `videolapse.sh` and has a 1 second delay between each itteration (don't forget to `ctrl+x` to save and exit).  

Open the root crontab file for editing the following command:
`sudo crontab -e` at the end of the file add: 
```
@reboot sh /home/pi/forever.sh >> /home/pi/forever.log 2>&1
```
`@reboot`: This is a special string recognized by the cron scheduler, indicating that the command following it should be executed when the system is rebooted.

`sh /home/pi/forever.sh`: This is the command that will be executed. It runs the shell script named forever.sh located in the /home/pi/ directory.

`>> /home/pi/forever.log 2>&1`: This redirects both standard output and standard error to the file /home/pi/forever.log, appending any output produced by the script to this log file.

## Connecting to the Wifi Via Terminal 
To confirm that your wifi network is in your area you should run:  
`sudo iwlist wlan0 scan`   
This lets you see all the wifi networks in you area.  
To add your wifi network:  
`sudo nano /etc/wpa_supplicant/wpa_supplicant.conf`   
Go to the bottom of the file and add the following:  
```
network={ ssid="the_name_of_your_router"

psk="our_wifi_password"

}
```
To restart the wpa-supplicant run:  
`sudo wpa_cli reconfigure`

To finish it all off, restart the Raspberry pi by running:  
`sudo reboot`

## Overclocking the Raspberry Pi
We will be Overclocking the Raspberry Pi by changing the CPU and GPU speed settings. Open the config.txt file by running:  
`sudo nano /boot/config.txt`  
At the bottom of the page, under [all] add the following lines:  
```
[all]
arm_freq=1200
core_freq=500
over_voltage=2 //optional
```
We're setting the arm_freq (the CPU clock speed) to 1200MHz (1.2GHz), while also using core_freq (the GPU core speed) to 500MHz. If the latest firmware doesn't automatically scale up the voltage if the system is overclocked, you can manually scale up the voltage by adding `over_volatge=2` Save the settings by pressing `ctrl+s` and then exit the settings by pressing `ctrl+x`. To finish it all off, restart the Raspberry pi by running `sudo reboot`

Now that you overclocked the Raspberry Pi, you're going to need to install a heatsync

## Problems We Encounterd 
In the beginning (for whatever reason) we were getting no picture when trying to connect it to any monitor. We fixed this by editing the `config.txt` via a sd card reader and following the advice that it gave us as shown:
```
# uncomment if you get no picture on HDMI for a default "safe" mode
hdmi_safe=1
```
Another thing that set us back was resin printing a Raspberry Pi clip. 

A good rule of thumb when it comes to resin is: If it looks dirty, clean it. if it looks clean, clean it.
