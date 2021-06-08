if [[ $(hostnamectl) =~ .*arm.* ]]
  then file=besttracearm
  else file=besttrace
fi

read -p "当地IP:" ip
wget -nc https://github.com/fscarmen/tools/raw/main/$file
chmod +x $file
./$file $ip -g cn
