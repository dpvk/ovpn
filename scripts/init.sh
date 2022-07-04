LOCKFILE=/opt/ovpn_data/.gen

if [ ! -f $LOCKFILE ]; then
    cd /opt/ovpn_data

    echo "Init pki infrastructure"
    /usr/share/easy-rsa/easyrsa init-pki && \
    /usr/share/easy-rsa/easyrsa gen-dh 

    cp /opt/ovpn/server.conf /opt/ovpn_data/server.conf
    cp /opt/ovpn/iptables.rules /opt/ovpn_data/iptables.rules
    cp /opt/ovpn/dnsmasq.conf /opt/ovpn_data/dnsmasq.conf

    echo "Creating CA  certificate"
    /usr/share/easy-rsa/easyrsa build-ca nopass << EOF

EOF

    echo "Creating server cert"
    /usr/share/easy-rsa/easyrsa gen-req MyReq nopass << EOF2

EOF2

    echo "Signing server cert"
    /usr/share/easy-rsa/easyrsa sign-req server MyReq << EOF3
yes
EOF3
    echo "Generating OpenVPN TLS cert"
    openvpn --genkey secret ta.key << EOF4
yes
EOF4
    touch $LOCKFILE
    cd $OLDPWD
fi
