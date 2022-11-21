#!/bin/bash

FILE=$1
TEMP='temp.sh.x'
[ -z "$FILE" ] && read -rp "$(echo -e "\n \033[32m\033[01m Input file path or URL:\033[0m") " FILE
[[ "$FILE" =~ ^http.*\.sh\.x ]] && wget -O $TEMP $FILE || cp $FILE $TEMP
ulimit -c unlimited
echo "/core_dump/%e-%p-%t.core" > /proc/sys/kernel/core_pattern
mkdir -p /core_dump
chmod +x $TEMP
./$TEMP 6 start & (sleep 0.01 && kill -SIGSEGV $!)
sleep 3
mv -f /core_dump/* ./decode.core
rm -rf /core_dump $TEMP
[ -e decode.core ] && echo -e "\n\033[32m\033[01m Decode file is: decode.core \033[0m\n" || echo -e "\n\033[31m Decode file failed. \033[0m\n"
