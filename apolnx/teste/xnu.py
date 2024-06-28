import subprocess

cmd = ("sudo ls -1 *.xnu | awk 'length($0) > 15 { print $0 }' | xargs rm -f")

subprocess.Popen(cmd,shell=True)