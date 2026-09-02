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
