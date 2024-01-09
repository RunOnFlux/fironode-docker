#!/usr/bin/env bash
CONFIG_FILE="/root/.firo/firo.conf"
function get_ip() {
    WANIP=$(curl --silent -m 15 https://api4.my-ip.io/ip | tr -dc '[:alnum:].')
    if [[ "$WANIP" == "" || "$WANIP" = *htmlhead* ]]; then
        WANIP=$(curl --silent -m 15 https://checkip.amazonaws.com | tr -dc '[:alnum:].')
    fi
    if [[ "$WANIP" == "" || "$WANIP" = *htmlhead* ]]; then
        WANIP=$(curl --silent -m 15 https://api.ipify.org | tr -dc '[:alnum:].')
    fi
}

if [[ ! -f $CONFIG_FILE ]]; then
  get_ip
  RPCUSER=$(pwgen -1 8 -n)
  PASSWORD=$(pwgen -1 20 -n)
  # Append or create lines in the configuration file
  echo "rpcuser=$RPCUSER" >> $CONFIG_FILE
  echo "rpcpassword=$PASSWORD" >> $CONFIG_FILE
  echo "rpcallowip=127.0.0.1" >> $CONFIG_FILE
  echo "listen=1" >> $CONFIG_FILE
  echo "server=1" >> $CONFIG_FILE
  echo "daemon=1" >> $CONFIG_FILE
  echo "logtimestamps=1" >> $CONFIG_FILE
  echo "txindex=1" >> $CONFIG_FILE
  echo "znode=1" >> $CONFIG_FILE
  echo "externalip=$WANIP:8168" >> $CONFIG_FILE
  echo "znodeblsprivkey=$KEY" >> $CONFIG_FILE
fi

# Check if znodeblsprivkey is empty or not
if grep -q "^znodeblsprivkey=$" $CONFIG_FILE; then
    # Replace with the provided key
    sed -i "s/^znodeblsprivkey=$/znodeblsprivkey=$KEY/" $CONFIG_FILE
fi

while true; do
 if [[ $(pgrep firod) == "" ]]; then 
   firod -daemon
 fi
sleep 120
done
