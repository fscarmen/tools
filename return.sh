if [[ $(hostnamectl) =~ .*arm.* ]]
  then file=besttrace
  else file=besttracearm
fi

read -p "当地IP:" ip
wget -nc https://github.com/fscarmen/tools/raw/main/$file
chmod +x $file
./$file $ip -g cn
