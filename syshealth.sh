#!/usr/bin/env bash

# the shebang (!#) tells the OS which interpreter to use to run this file
# We use "/usr/bin/env" instead of hardcoding "/bin/bash" beacause env
# searches the user's path for bash, so the script still runs correctly
# even if bash is installed in a different location on another system. 
# This makes the script more portable across different machines
   
# ==============================================
# syshealth.sh - System Health & Log Analysis Toolkit
# Lab 1 - Data Collector
# Author: Your Name
# Date: $(date +%Y-%m-%d)
# ==============================================

# --- Variables and quoting demonstration ---
HOSTNAME=$(hostname)

# 1) Command substitution: $(...) runs the command inside the parantheses
# and replaces it with that command's output, which we then store in a variable. 

# 2) $(hostname) runs the "hostname" command, which prints the machine's 
# network name (e.g "vm"). Wrapping it in $(...) captures that output
# and stores it in the HOSTNAME variable instead of printing it directly.

# 3) HOSTNAME stores the machine's network name, captured from the output
# of the "hostname" command via command substitution. e.g: "vm"

# 4) In Bash, "$" means "give me the value stored in this variable."
# when we assign a value, we're not reading it yet, we are creating/
# naming the variable, so we just use its plain name: HOSTNAME=...
# if we wrote $HOSTNAME=..., Bash would first try to read the value of HOSTNAME (which doesnt exist yet) and use that as the name,
# this breaks the assignment. So: no "$" when assigning, "$" when assigning, 
# "$" only wehn reading the value later (e.g. echo "$HOSTNAME").

CURRENT_DATE=$(date '+%Y-%m-%d %H:%S')

# $(...) is a command substitution again, it runs the "date" command and 
# captures whatever it prints, storing that result in CURRENT_DATE.

# '+%Y-%m-%d %H:%S' is not a seperate command, its an argument being 
# passed to "date" telling it exactly how to format its output. The + tells
# date that a custom format string follows, and each %X piece stands for 
# a specific value: %Y is the four-digit year, %m is the month, %d is the day,
# and %H:%M:%S gives hours, minutes, and seconds. Quoting this whole string 
# keeps it as one argument, since it contains spaces and bash would otherwise
# try to split it into multiple separate arguments.

# NOTE ON QUOTING: This section shows why we should get into the habit 
# of quoting variables in Bash even when it seems to work fine without them. 
# if a varible's value ever contains a space (or multiple values), leaving 
# it unquoted can cause Bash to teat it as several separate words instead
# of one, this is called word-splitting, and it's a common source of bugs. 
# Wrapping a variable in double quote keeps its value together as a single 
# unit, which is why its considered the safer, standard practice in Bash. 
echo "Hostname without quotes: $HOSTNAME"   # happens to work here, but risky as a habit
echo "Hostname with qoutes: \"$HOSTNAME\""  # safer approach

cat << EOF
# Coming from Python or Java, its easy to assume variables just work
# the same way everywhere, but Bash treats them differently. If a 
# variable holds a value with spaces in it and you use it without 
# quotes, Bash will split that value into seperate words at each space
# ,tab or newline , which can silently break your script. Wrapping the 
# variable in double quotes prevents this splitting and keeps its value
# intact, so quoting should be the default habit.
EOF

# cat << EOF ... EOF is a "heredoc" (here document)
# it lets us feed multiple lines of text into a command at once, instead
# of writing several separate echo statements. 

# cat : normally prints file contents, but here it just prints whatever 
# text is given to it. 
# << : tells Bash "read input from the following lines, not from a file or the keyboard".
# EOF : just a marker (delimeter) we chose to mark where the block starts and ends (any word workks here not necessarily EOF). Bash stops
# reading once it sees EOF alone on its own line. 

# Note: inside this cat block, the # symbols are NOT treated at comments, 
# they are just plain text being printed to the screen analog with 
# everything else between the two EOF markers. 

# --- System metrics collection ---
UPTIME=$(uptime -p)
DISK_USAGE=$(df -h / | tail -1)
MEMORY_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
PROCESS_COUNT=$(ps -e | wc -l)

# UPTIME=$(uptime -p): "uptime" is a command that reports how long the
# system has been running since it waaas last booted/restarted. By default
# it also shows extra info like the current time, number of logged-in users 
# and load averages. the "-p" flag ("pretty") strips all that away  and gives 
# just a simple phrase like "up 2 hours, 15 minutes". $(...) captures 
# that phrase and stores it in the UPTIME variable . 

# DISK USAGE=$(df -h / | tail -1): 
# "df" (disk free) reports how much disk space is used and available on
# mounted filesystem. The "-h" flag means "human-readable", it shows 
# sizes like 8.6G instead of raw byte counts. which are hard to read.
# the "/" tells df to report specifically on the root filesystem, not 
# every mounted drive. Normally  df's output includes a header row
# (Filesystem, Size, Used..) followed by the actual data row. Piping "|" into
# "tail -1" keeps only the last line of output (the data row) and 
# discards the header, since we only care about the numbers 
# the "|" symbol is called a apipe. it takes the output of  one command 
# and feeds it directly as an input to the next command, instead of 
# printing it to the screen. 

# MEMORY_USAGE=$(free -h | awk '/Mem:/ {print $3 "/" $2}')
# "free" reports how much RAM is used vs available on the system. "-h" 
# again means human-readable.free's output nnnormally has multiple rows
# (Mem:, Swap:, ...), so we pipe it into "awk", a text-processing tool
# that lets us search for and manipulate specific lines/columns. '/Mem:/'
# tells awk to only look at the line that starts with "Mem:". Within that 
# line, {print $3 "/" $2} means "print the 3rd column, then slash, then 
# the 2nd column", infree's output, solumn 2 is total memory and column 3 is used memory,
# so this builds a "used/total" string. 

# PROCESS_COUNT=$(ps -e | wc -l):
# "ps" lists information about currently running processes. The "-e" flag
# means "show every process on the system", not just ones tied to the
# current terminal session. Each running process gets printed as one line
# of output. Piping that into "wc -l" ("word count", with -l for "lines")
# counts how many lines were produced, which effectivelyy counts how many
# processes are running. That number is stored in PROCESS_COOUNT.

