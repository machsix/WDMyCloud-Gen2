#!/bin/sh
path=$1
sed -i '/export XDG_CONFIG_HOME.*/d' /home/root/.profile
