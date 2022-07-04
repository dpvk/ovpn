FROM alpine:3.16.0

LABEL maintainer="Dmitry Pervukhin <dmpvkhn@gmail.com>"

RUN apk add --no-cache openvpn iptables easy-rsa bash netcat-openbsd zip dnsmasq

RUN mkdir -p /opt/ovpn && mkdir -p /opt/ovpn_data/clients


COPY config/openvpn/server/* /opt/ovpn/
COPY config/openvpn/client/* /opt/ovpn/
COPY config/dnsmasq/* /opt/ovpn/
COPY scripts/* /opt/ovpn/

WORKDIR /opt/ovpn

ENTRYPOINT [ "./entrypoint.sh" ]
