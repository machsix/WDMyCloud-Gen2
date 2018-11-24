#!/bin/sh

path=$1

echo 'export XDG_CONFIG_HOME='$path'/config' >> /home/root/.profile
