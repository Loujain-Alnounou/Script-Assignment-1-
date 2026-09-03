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

# PURPOSE:
# This script checks the current state of the machine its run on and
# puts together a short, readable summary of that informtion. It looks
# at things like the computers name, how long its been running, how 
# much disk space and memory are currently in use, and how many processes
# are active at the moment. The report can either be shown right on the 
# screen or saved to a file, depending on whether a filename is given when
# the script is run. the goal is to have a quick, one-command way to check
# ona systems's basic health without having to run several separarte 
# commands manually each time.


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

# --- Output handling ---
OUTPUT_FILE="${1:-}" 

# $1 refers to the first argument passed to the script on the command 
# line. e.g. if you run "./syshealth.sh collector_output.txt", then
# $1 holds the value "collector_output.txt" inside the script.

# ${1:-} is a safer way to use that argument. The ":-" part means 
# "if this variable is unset or empty, use this fallback value instead"
# (here, the fallback is nothing - an empty string). So this line means:
# "if an argument was given, use it; otherwise, just use an empty value"

# If no argument is supplied when running the script, $1 simply doesnt 
# exist. Using $1 directly in that case can trigger an error under
# strict settings, since bash treats referencing an unset variable as
# a problem. ${1:-} avoids this by safely falling back to an empty string
# instead of failing

# This is why ${1:-} is safer than $1 : it lets the script handle the 
# "no argument given" case gracefully (falling back to printing the report
# on screen instead of writing to a file), rather than risking an error
# or unexpected behavior when the argument is missing.

print_report() { 
printf "=======================================\n"
printf "System Health Report - %s\n" "$CURRENT_DATE"
printf "Hostname     : %s\n" "$HOSTNAME"
printf "Uptime       : %s\n" "$UPTIME"
printf "Disk /       : %s\n" "$DISK_USAGE"
printf "Memory used  : %s\n" "$MEMORY_USAGE"
printf "Total processes : %s\n" "$PROCESS_COUNT"
printf "======================================\n"
}

# the code above defines a function called print_report which is a reusable
# block of code that when called later in the script, prints out a nicley
# formatted report using all the variable we collected earlier

# printf works like a template, the first part in quotes is the format
# string, and %s is a placeholder meaning "insert a string value here".
# whatever comes afdter the formar string fills in that placeholder


if [ -n "$OUTPUT_FILE" ]; then 
   print_report > "$OUTPUT_FILE"
   echo "Report written to $OUTPUT_FILE"
else 
	print_report
fi


exit 0

# EXPLANATION
# if [ -n "$OUTPUT_FILE" ]; then
# "if" starts a conditioonal check. [...] is a test command that evaluates 
# whether something is true or false. "-n" checks whether teh string that 
# follows is not empty (n= nonzero length). "; then" marks the start
# of the code that runs if this is true. 

# print_report > "$OUTPUT_FILE"
# this calls teh print_report function we defined earlier, but instead
# if letting its output go to the screen, the ">" symbol redirects that 
# output into a file, specifically the filename stored in OUTPUT_FILE.
# if teh file doesnt exits yet, it gets created; if it already exists,
# its content gets overwritten. 

# echo "Report written to $OUTPUT_FILE"
# prints a simple confirmation message to the screen, letting the user 
# know the report was saved and showing them the filename it was saved 
# to. This just prints to teh screen normally (not redirected) 

# else 
# Marks the start of the code that runs only if the condition above was false

# print_report 
# Calls the same function again, but this time with no ">" redirection,
# so its output just prints normally to the screen instead of file

# fi
# Closes the if/else block. ("fi" is just "if" spelled backwards, Bash's
# way of marking where a conditional statement ends.)

# exit 0 
# Ends the script and returns an exit status of 0 to the operating 
# system. In Linux/Unix convention, an exit status of 0 means the 
# script finished successfully with no errors. This isnt required for 
# the script work, but its good practice, especially if this script 
# is ever called by another script.

# explanation of .gitignore file:
# the .gitignore file tells git to ignore all .txt files in the reposito>
# except for a specific list of files that must still be tracked and sub>
# *.txt : ignores every .txt file by default 
# lines starting with ! are exceptions - they un-ignore specific files, 
# forcing Git to still track them even though they end in .txt


