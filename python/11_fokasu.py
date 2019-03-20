#!/usr/bin/env python3

import sys
import os
import time
import contextlib

with contextlib.redirect_stdout(None):
	from pygame import mixer


def main(args):
    if len(args[1:]) != 2:
       print("\nUsage : %s work_time rest_time\n" % args[0])
       return -1

    def countdown(t, alarm):
        while t >= 0:
            mins, secs = divmod(t, 60)
            timeformat = '{:02d}:{:02d}'.format(mins, secs)
            print(" > " + timeformat, end='\r')
            time.sleep(1)
            t -= 1

        mixer.init()
        mixer.music.load(alarm)
        mixer.music.set_volume(0.6)
        mixer.music.play(-1)
        try:
            input("")
        except SyntaxError:
            pass
        mixer.music.stop()


    twork, trest = args[1:]
    pwd = os.path.dirname(__file__)
    work = os.path.join(pwd, "sounds/chip.mp3")
    nap = os.path.join(pwd, "sounds/alarm.mp3")

    count = 1

    while True:
        clock = time.strftime("%H:%M")
        if count == 1:
            os.system('clear')
            print("\n\nStart To Work!: %s" % clock)
            countdown(int(twork) * 60, nap)
        elif count % 2 == 0:
            os.system('clear')
            print("\n\nTake A Break!: %s" % clock)
            countdown(int(trest) * 60, work)
        else:
            os.system('clear')
            print("\n\nBack To Work!: %s" % clock)
            countdown(int(twork) * 60, nap)
        count += 1

if __name__ == '__main__':
    sys.exit(main(sys.argv))


