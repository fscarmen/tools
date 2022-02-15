FROM    alpine

#ENV     PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
#        LANG=zh_CN.UTF-8 \
#        DIR=/etc/wireguard

#WORKDIR ${DIR}
WORKDIR /etc/wireguard

RUN     apk add --no-cache tzdata net-tools iproute2 openresolv wireguard-tools openrc iptables curl \
        && rm -rf /var/cache/apk/* \
        && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
        && echo "Asia/Shanghai" > /etc/timezone \
        && arch=$(arch | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) \
        && latest=$(curl -sSL "https://api.github.com/repos/ginuerzh/gost/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g') \
        && latest=${latest:-'2.11.1'} \
        && wget -O $DIR/gost.gz https://github.com/ginuerzh/gost/releases/download/v$latest/gost-linux-$arch-$latest.gz \
        && gzip -d $DIR/gost.gz \
        && curl -fsSL git.io/wireguard-go.sh | bash \
        && echo '*/5 * * * * nohup bash /etc/wireguard/warp_unlock.sh >/dev/null 2>&1 &' >> /etc/crontabs/root \
        && echo 'null' > /etc/wireguard/status.log \
        && echo -e "wg-quick up wgcf\ncrond\n/etc/wireguard/gost -L :40000" > $DIR/run.sh \
        && chmod +x $DIR/gost $DIR/run.sh
  

COPY    wgcf.conf warp_unlock.sh $DIR/

ENTRYPOINT  ["bash /etc/wireguard/run.sh"]
