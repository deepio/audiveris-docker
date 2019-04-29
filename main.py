# -*- coding: utf-8 -*-
import concurrent.futures as cf
import os
import subprocess
import shlex


def audiveris_worker(filename):
  print(f"[+] Working on: {filename}")
  subprocess.call(
    shlex.split(f"/Audiveris/bin/Audiveris -batch -export -save -output /finished/ /to_do/{filename}"),
    stdout=subprocess.DEVNULL,
    stderr=subprocess.DEVNULL
  )
  print(f"[+] Finished: {filename}")

file_list = []
for root, directories, filenames in os.walk("./to_do"):
  for filename in filenames:
    if filename != ".keep":
      file_list.append(filename)

with cf.ProcessPoolExecutor(max_workers=3) as run:
  run.map(audiveris_worker, file_list)
