#!/bin/bash
CONFIG_FILE="/root/.firo/firo.conf"
sed -i "s/^znodeblsprivkey=$/znodeblsprivkey=$1/" $CONFIG_FILE
echo -e "New znodeblsprivkey created - $1"
echo -e ""
