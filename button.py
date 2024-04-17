from gpiozero import Button
import os
import time
button = Button(17)

while True:
        button.wait_for_press()
        print("Taking Picture")
        os.system("bash timelapse.sh")
        time.sleep(0.5)
