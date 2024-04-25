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
  TEMP=$(awk -F / '{print $NF}' <<< "$FILE")
  rm -f decode-$TEMP
  if [[ "$FILE" =~ ^http ]]; then
    wget -O $TEMP $FILE
    [ "$?" != 0 ] && rm -f $TEMP && echo -e "\n \033[31m\033[01m Could not download the file. The script is exit！\033[0m \n" && exit 1
  else
    [ ! -s "$FILE" ] && echo -e "\n \033[31m\033[01m $FILE is empty. The script is exit！\033[0m \n" && exit 1
  fi

  decode[0]=$(bash <(sed "s#eval#echo#" $TEMP))
  while [[ "$(head -c 7 <<< "${decode[$((${#decode[*]}-1))]}")" = "bash -c" && "$(tail -c 10 <<< "${decode[$((${#decode[*]}-1))]}")" = 'bash "$@"' ]]; do
    decode[${#decode[*]}]=$(bash <(sed 's/bash -c/echo/; s/bash "$@"//'  <<< "${decode[$((${#decode[*]}-1))]}"))
  done
  if [[ "$(wc -l <<< "${decode[-1]}")" > 80 ]]; then
    echo "${decode[-1]}" > decode-$TEMP
  else
    if [ ! $(type -p bunzip2) ]; then
      if [ $(type -p yum) ]; then
        yum install -y bzip2
      elif [ $(type -p apt) ]; then
        apt install -y bzip2
      elif [ $(type -p apk) ]; then
        apk add -y bzip2
      fi
    fi
    REAL_FILE_ONLINE=$(grep -E '(wget|curl).*http.*.sh' <<< "${decode[-1]}" | grep -o 'http[^ ]*.sh' | sed -n 1p)
    wget -qO- $REAL_FILE_ONLINE | sed '1,/fi; exit \$res/d' | bunzip2 > decode-$TEMP
  fi
  echo -e "\n\033[32m\033[01m Decode file is: decode-$TEMP \033[0m\n"

else
  echo -e "\n \033[31m\033[01m $FILE is unavailable. The script is exit！\033[0m \n" && exit 1
fi
