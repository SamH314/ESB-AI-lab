from gpiozero import Button
import os
import time

button = Button(17)
wifi_button = Button(4)

button_off = False
wifi_button_on = False

while True:

#switching wifi on and off
  if(wifi_button.is_pressed and not wifi_button_on):
    print('wifi on')
    wifi_button_on = True
    os.system('sudo ifconfig wlan0 up')
  elif(not wifi_button.is_pressed and wifi_button_on):
    print('wifi off')
    wifi_button_on = False
    os.system('sudo ifconfig wlan0 down')

#switching recording of camera
  if(button.is_pressed):
    button_off = False
    print("new recording")
    os.system("bash videolapse2.sh")
    print("recording ended")
  else:
    if (button_off == False):
      print("button released")
      button_off = True
