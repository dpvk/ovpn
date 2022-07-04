#!/bin/bash
cd /opt/ovpn_data

CLIENT_ID=${1:-"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"}
CLIENT_PATH="/opt/ovpn_data/clients/$CLIENT_ID"

# Redirect stderr to the black hole
/usr/share/easy-rsa/easyrsa build-client-full "$CLIENT_ID" nopass &> /dev/null
# Writing new private key to '/usr/share/easy-rsa/pki/private/client.key
# Client sertificate /usr/share/easy-rsa/pki/issued/client.crt
# CA is by the path /usr/share/easy-rsa/pki/ca.crt

mkdir -p $CLIENT_PATH

cp "pki/private/$CLIENT_ID.key" "pki/issued/$CLIENT_ID.crt" pki/ca.crt ta.key $CLIENT_PATH

# Set default value to HOST_ADDR if it was not set from environment
if [ -z "$HOST_ADDR" ]
then
   HOST_ADDR='localhost'
fi


cp /opt/ovpn/client.tmpl $CLIENT_PATH/$CLIENT_ID.ovpn

echo -e "\nremote $HOST_ADDR 1194" >> "$CLIENT_PATH/$CLIENT_ID.ovpn"

# Embed client authentication files into config file
cat <(echo -e '<ca>') \
    "$CLIENT_PATH/ca.crt" <(echo -e '</ca>\n<cert>') \
    "$CLIENT_PATH/$CLIENT_ID.crt" <(echo -e '</cert>\n<key>') \
    "$CLIENT_PATH/$CLIENT_ID.key" <(echo -e '</key>\n<tls-auth>') \
    "$CLIENT_PATH/ta.key" <(echo -e '</tls-auth>') \
    >> "$CLIENT_PATH/$CLIENT_ID.ovpn"

echo "#$CLIENT_PATH"
cat $CLIENT_PATH/$CLIENT_ID.ovpn
