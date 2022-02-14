FROM alpine

WORKDIR /wgcf

VOLUME /wgcf

RUN apk add net-tools iproute2 openresolv wireguard-tools openrc iptables curl \
  

#COPY entry.sh /entry.sh
#RUN chmod +x /entry.sh

#ENTRYPOINT ["/entry.sh"]
