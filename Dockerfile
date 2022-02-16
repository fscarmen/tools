FROM    alpine

ENV     PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
        LANG=zh_CN.UTF-8 \
        DIR=/etc/wireguard

WORKDIR ${DIR}

RUN     apk add --no-cache tzdata net-tools iproute2 openresolv wireguard-tools openrc iptables curl \
        && rm -rf /var/cache/apk/* \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && arch=$(arch | sed s/aarch64/armv8/ | sed s/x86_64/amd64/) \
        && latest=$(curl -sSL "https://api.github.com/repos/ginuerzh/gost/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g') \
        && latest=${latest:-'2.11.1'} \
        && wget -O $DIR/gost.gz https://github.com/ginuerzh/gost/releases/download/v$latest/gost-linux-$arch-$latest.gz \
        && gzip -d $DIR/gost.gz \
        && curl -fsSL git.io/wireguard-go.sh | bash \
        && echo "*/5 * * * * nohup bash $DIR/warp_unlock.sh >/dev/null 2>&1 &" >> /etc/crontabs/root \
        && echo 'null' > $DIR/status.log \
        && cat >$DIR/run.sh <EOF
        until [[ -e wgcf-account.toml ]] >/dev/null 2>&1; do wgcf register --accept-tos && break; done
        [[ -e wgcf-account.toml ]] && wgcf generate -p $DIR/wgcf.conf
        sed -i "s/^.*\:\:\/0/#&/g;s/engage.cloudflareclient.com/162.159.192.1/g" $DIR/wgcf.conf
        wg-quick up wgcf\ncrond\n$DIR/gost -L :40000" > $DIR/run.sh
        EOF \
        && chmod +x $DIR/gost $DIR/run.sh

  
#COPY    wgcf.conf warp_unlock.sh $DIR/

ENTRYPOINT $DIR/run.sh
