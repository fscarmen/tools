#!/bin/bash

FILE="$1"

[ -z "$FILE" ] && read -rp "$(echo -e "\n \033[32m\033[01m Input file path or URL:\033[0m") " FILE
if [[ "$FILE" =~ .*\.sh\.x$ ]]; then
  TEMP='temp.sh.x'
  rm -f $TEMP
  if [[ "$FILE" =~ ^http ]]; then
    wget -O $TEMP $FILE
    [ "$?" != 0 ] && rm -f $TEMP && echo -e "\n \033[31m\033[01m Could not download the file. The script is exit！\033[0m \n" && exit 1
  else
    [ ! -f "$FILE" ] && echo -e "\n \033[31m\033[01m $FILE is empty. The script is exit！\033[0m \n" && exit 1 || cp $FILE $TEMP
  fi
  ulimit -c unlimited
  echo "/core_dump/%e-%p-%t.core" > /proc/sys/kernel/core_pattern
  mkdir -p /core_dump
  chmod +x $TEMP
  ./$TEMP 6 start & (sleep 0.01 && kill -SIGSEGV $!)
  sleep 3
  mv -f /core_dump/* ./decode.core
  rm -rf /core_dump $TEMP
  [ -e decode.core ] && echo -e "\n\033[32m\033[01m Decode file is: decode.core \033[0m\n" || echo -e "\n\033[31m Decode file failed. \033[0m\n"

elif [[ "$FILE" =~ .*\.sh$ ]]; then
  TEMP='temp.sh'
  rm -f $TEMP
  if [[ "$FILE" =~ ^http ]]; then
    wget -O $TEMP $FILE
    [ "$?" != 0 ] && rm -f $TEMP && echo -e "\n \033[31m\033[01m Could not download the file. The script is exit！\033[0m \n" && exit 1
  else
    [ ! -f "$FILE" ] && echo -e "\n \033[31m\033[01m $FILE is empty. The script is exit！\033[0m \n" && exit 1 || cp $FILE $TEMP
  fi

  awk -F 'eval' '{print $1}' $TEMP > $TEMP.1
  . $TEMP.1
  eval echo $(awk -F 'eval' '{print $2}' $TEMP) > $TEMP.2
  i=2
  while [[ "$(head -n 1 $TEMP.$i)" =~ ^"bash -c" && "$(tail -n 1 $TEMP.$i)" =~ 'bash "$@"'$ ]]; do
    sed '1d; s#")" bash "$@"##g' $TEMP.$i | base64 -d > $TEMP.$[i+1]
    (( i++ )) || true
  done
    cp $TEMP.$i $TEMP-decode
    rm -rf $TEMP.*
    echo -e "\n\033[32m\033[01m Decode file is: $TEMP-decode \033[0m\n"

else
  echo -e "\n \033[31m\033[01m $FILE is unavailable. The script is exit！\033[0m \n" && exit 1
fi
