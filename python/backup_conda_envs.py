#!/usr/bin/env python3
import shutil
import subprocess as sub
import tempfile
from pathlib import Path

with tempfile.NamedTemporaryFile() as f:
    with open(f.name, "r", encoding="utf-8") as file:
        res = sub.run("conda env list", shell=True, check=True, capture_output=True)
        envs = res.stdout.decode("utf-8").split("\n")[3:-2]
        env_names = [x.split()[0] for x in envs]

        out_dir = Path.cwd() / "conda_envs"
        out_dir.mkdir(parents=True, exist_ok=True)

        for env in env_names:
            print(f"Backing up... {env}")
            env_file = out_dir / f"conda_{env}"
            cmd = f"conda env export --no-builds -n {env} > {env_file}.yml"
            sub.run(cmd, shell=True, check=True)

            print(f"Locking up... {env}")
            cmd_lock = f"conda-lock -f {env_file}.yml -p osx-64 -p linux-64"
            sub.run(cmd_lock, shell=True, check=True)
            shutil.move(Path.cwd() / "conda-lock.yml", f"{env_file}.lock.yml")
