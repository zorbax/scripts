#!/usr/bin/env python


import contextlib
import subprocess
import signal
import sys
import time
from pathlib import Path

with contextlib.redirect_stdout(None):
    from pygame import mixer

# brew install SDL
# brew install SDL2
# brew install leveldb


def main(args):
    if len(args[1:]) == 1:
        print(f"\nUsage : {Path(sys.argv[0]).name} work_time rest_time\n")
    elif len(args[1:]) == 0:
        twork, trest = 52, 17
    else:
        twork, trest = args[1:]

    def countdown(t, alarm):
        while t >= 0:
            mins, secs = divmod(t, 60)
            timeformat = f"{mins:02d}:{secs:02d}"
            print(f" > {timeformat}", end="\r")
            time.sleep(1)
            t -= 1

        mixer.init()
        mixer.music.load(alarm)
        mixer.music.set_volume(0.3)
        mixer.music.play(-1)

        def handler():
            print(f"Timeout for {Path(sys.argv[0]).name}")
            sys.exit()

        signal.signal(signal.SIGALRM, handler)
        signal.alarm(240)

        try:
            input("")
        except SyntaxError:
            pass
        mixer.music.stop()
        signal.alarm(0)

    pwd = Path(__file__).resolve().parent
    work = pwd / "sounds/chip.mp3"
    nap = pwd / "sounds/alarm.mp3"

    count = 1

    while True:
        clock = time.strftime("%H:%M")
        if count == 1:
            subprocess.run("clear")
            print(f"\n\nWorking!: {clock}")
            countdown(int(twork) * 60, str(nap))
        elif count % 2 == 0:
            subprocess.run("clear")
            print(f"\n\nBreak!: {clock}")
            countdown(int(trest) * 60, str(work))
        else:
            subprocess.run("clear")
            print(f"\n\nBack To Work!: {clock}")
            countdown(int(twork) * 60, str(nap))
        count += 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
