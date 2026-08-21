from evdev import InputDevice, ecodes, list_devices
import time
import subprocess

last_press = 0
delay = 0.3

device = None

for path in list_devices():
    dev = InputDevice(path)

    if dev.name == "AT Translated Set 2 keyboard":
        device = dev
        break

if device is None:
    raise Exception("Keyboard device not found")

for event in device.read_loop():
    if event.type == ecodes.EV_KEY:
        if event.code == ecodes.KEY_LEFTMETA and event.value == 1:
            now = time.time()

            if now - last_press < delay:
                subprocess.Popen(["swaync-client", "-t"])
                last_press = 0
            else:
                last_press = now
