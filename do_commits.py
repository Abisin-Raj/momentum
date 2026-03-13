import subprocess
import datetime
import os

repo_dir = "/home/abisin/momentum"
commit_date = "2026-03-05T12:00:00"

def run(cmd):
    print("Running:", cmd)
    res = subprocess.run(cmd, shell=True, cwd=repo_dir, capture_output=True, text=True)
    if res.stdout: print("STDOUT:", res.stdout)
    if res.stderr: print("STDERR:", res.stderr)

run("git config user.email 'abisin@test.local'")
run("git config user.name 'Abisin'")
run("git add .")

for i in range(1, 62):
    env = f"GIT_AUTHOR_DATE='{commit_date}' GIT_COMMITTER_DATE='{commit_date}'"
    cmd = f"{env} git commit --allow-empty -m 'chore: routine update {i}'"
    run(cmd)

print("Done making 61 commits.")
