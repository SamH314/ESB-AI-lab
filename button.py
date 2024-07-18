from gpiozero import Button
import os
import time

button = Button(17)
wifi_button = Button(4)
on_off_button = Button(22)  # Add a button for on/off

button_off = False
wifi_button_on = False
system_on = False  # State for the on/off button

while True:
    # Switching system on and off
    if on_off_button.is_pressed and not system_on:
        print('System on')
        system_on = True
    elif not on_off_button.is_pressed and system_on:
        print('System off')
        system_on = False

    if system_on:
        # Switching wifi on and off
        if wifi_button.is_pressed and not wifi_button_on:
            print('WiFi on')
            wifi_button_on = True
            os.system('sudo ifconfig wlan0 up')
        elif not wifi_button.is_pressed and wifi_button_on:
            print('WiFi off')
            wifi_button_on = False
            os.system('sudo ifconfig wlan0 down')

        # Switching recording of camera
        if button.is_pressed:
            button_off = False
            print("New recording")
            os.system("bash videolapse2.sh")
            print("Recording ended")
        else:
            if not button_off:
                print("Button released")
                button_off = True
