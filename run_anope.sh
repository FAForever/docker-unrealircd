#!/bin/bash

#
# Sets up config file and runs anope in foreground
#

# services.conf.tpl contains placeholders for secrets
cp /home/unreal/services/conf/services.conf.tpl /home/unreal/services/conf/services.conf
# env vars sourced from env file
sed -i s"/%SECRET_IRC_SERVICE_PASSWORD%/${SECRET_IRC_SERVICE_PASSWORD}/" /home/unreal/unrealircd/conf/unrealircd.conf
sed -i s"/%SECRET_IRC_DB_USER%/${SECRET_IRC_DB_USER}/" /home/unreal/unrealircd/conf/unrealircd.conf
sed -i s"/%SECRET_IRC_DB_PASSWORD%/${SECRET_IRC_DB_PASSWORD}/" /home/unreal/unrealircd/conf/unrealircd.conf

/home/unreal/unrealircd/services/bin/services -nofork -debug
