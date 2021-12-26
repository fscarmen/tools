#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin && export PATH
# unlimited GB on Warp+ ： bash this_one.sh 30
## 使用脚本前先将curl请求中的 abda0c91-6b67-4432-913a-fedb60b9bc7b 改为你自己邀请链接的值,获取方式： curl -m 10 -sI "https://warp.plus/GEXF1" | grep -oE "referrer=.*$" | cut -f2 -d=
### 为啥没在curl请求里面直接填这个变量!?因为不知道啥原因填进去总是错，猜测是-符号的引起的?!

flowdata=${1:-10}
license=$2

########
for((i = 0; i < ${flowdata}; i++)); do
    [[ $i == 0 ]] && sleep_try=30 && sleep_min=20 && sleep_max=600 && echo $(date) Mission $flowdata GB
    install_id=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 22) && \
    curl -X POST -m 10 -sA "okhttp/3.12.1" -H 'content-type: application/json' -H 'Host: api.cloudflareclient.com' \
    --data "{\"key\": \"$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 43)=\",\"install_id\": \"$install_id\",\"fcm_token\": \"APA91b$install_id$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 134)\",\"referrer\": \"$license\",\"warp_enabled\": false,\"tos\": \"$(date -u +%FT%T.$(tr -dc '0-9' </dev/urandom | head -c 3)Z)\",\"type\": \"Android\",\"locale\": \"en_US\"}" \
    --url "https://api.cloudflareclient.com/v0a$(shuf -i 100-999 -n 1)/reg" | grep -qE "referral_count\":1" && status=0 || status=1
    # cloudflare限制了请求频率,目前测试大概在20秒,失败时因延长sleep时间
    [[ $sleep_try > $sleep_max ]] && sleep_try=300
    [[ $sleep_try == $sleep_min ]] && sleep_try=$((sleep_try+1))
    [[ $status == 0 ]] && sleep_try=$((sleep_try-1)) && sleep $sleep_try && rit[i]=$i && echo -n $i-o- && continue
    [[ $status == 1 ]] && sleep_try=$((sleep_try+2)) && sleep $sleep_try && bad[i]=$i && echo -n $i-x- && continue
done

echo; echo $(date) 此次运行共有warp+流量 ${#rit[*]} GB 获取成功
