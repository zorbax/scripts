#!/usr/bin/env python3
import subprocess
import time
from datetime import datetime
from pathlib import Path

wd = Path.home() / "data/05_mapping"
(Path(wd) / "init.done").touch(exist_ok=True)


def update():
    while True:
        now = datetime.now()
        dt_string = now.strftime("%H:%M")
        files_done = len(list(Path(wd).glob("*.done"))) - 1
        cmd = f"python3 send_status.py -m 'Mapped: {files_done}'"
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
        out, error = p.communicate()
        print(f"{dt_string}: {files_done}\n{out}\n{error}\n####################")
        time.sleep(7200)


def update2():
    while True:
        now = datetime.now()
        dt_string = now.strftime("%H:%M")
        get_last_log_lines = f"tail -6 {wd}/spades.log > {wd}/last_lines.log"
        push_log = f"python3 send_status.py -f {wd}/last_lines.log"
        cmd = f"{get_last_log_lines}; {push_log}"
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, shell=True)
        out, error = p.communicate()
        print(dt_string, out, error, sep="\t")
        time.sleep(1800)


if __name__ == "__main__":
    update()
    update2()
