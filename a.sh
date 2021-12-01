#bin/bash!

#Github @luoxue-bot
#Blog https://ty.al

region_area(){
	region=`tr [:lower:] [:upper:] <<< $(curl --user-agent "${UA_Browser}" -fs --max-time 10 --write-out %{redirect_url} --output /dev/null "https://www.netflix.com/title/80018499" | cut -d '/' -f4 | cut -d '-' -f1)` 
	region=${region:-US}
        if [[ "$region" != "$area" ]]; then
            echo -e "Region: ${region} Not match, Changing IP..."
            systemctl restart wg-quick@wgcf
            sleep 3
        else
            echo -e "Region: ${region} Done, monitoring..."
            sleep 6
        fi
        }

output=("404" "403" "000" "200")
display=("Originals Only, Changing IP..." "No, Changing IP..." "Failed, retrying..." "Matching the region...")
sleep_sec=("3" "3" "0" "0")
cmd=("systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "systemctl restart wg-quick@wgcf" "region_area")

UA_Browser="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36"
read -r -p "Is warp installed? [y/n] " input
[[ "$input" == "n" ]] && bash <(curl -fsSL https://raw.githubusercontent.com/fscarmen/warp/main/menu.sh) || read -rp "Input the region you want(e.g. HK,SG):" area

while [[ "$input" != "n" ]]; do
	result=$(curl --user-agent "${UA_Browser}" -fsL --write-out %{http_code} --output /dev/null --max-time 10 "https://www.netflix.com/title/81215567" 2>&1)
		for ((i=0; i<${#output[@]}; i++)); do
		[[ "$result" == ${output[i]} ]] && break
		done
	echo -e ${display[i]} && sleep ${sleep_sec[i]} && ${cmd[i]} 
done
