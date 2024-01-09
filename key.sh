#!/bin/bash
CONFIG_FILE="/root/.firo/firo.conf"
KEY_PLACEHOLDER="znodeblsprivkey"
sed -i "/^$KEY_PLACEHOLDER/d" "$CONFIG_FILE"
echo "$KEY_PLACEHOLDER=$1" >> $CONFIG_FILE
echo -e "[NEW] ${KEY_PLACEHOLDER} created - $1"
echo -e ""
