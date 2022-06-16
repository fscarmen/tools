#!/usr/bin/env bash
ip=$1
TEMP_FILE='ip.temp'
FILE=$(uname -m | sed "s/x86_64/besttrace/" | sed "s/aarch64/besttracearm/")

[[ -z "$ip" ]] && echo -e "请填入上对端 IP" && exit 1

[[ ! -e "$FILE" ]] && wget -qN https://cdn.jsdelivr.net/gh/fscarmen/tools/besttrace/$FILE
chmod +x "$FILE" >/dev/null 2>&1
./"$FILE" "$ip" -g cn > $TEMP_FILE
cat $TEMP_FILE | cut -d \* -f2 | sed "s/.*\(  AS[0-9]\)/\1/" | sed "/\*$/d;/^$/d;1d" | uniq | awk '{printf("%d.%s\n"),NR,$0}'
rm -f $TEMP_FILE
