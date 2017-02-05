#!/bin/bash

#
# Sets up config file, starts unrealircd and loops as long as it runs
#

# unrealircd.conf.tpl contains placeholders for secrets
cp /home/unreal/unrealircd/conf/unrealircd.conf.tpl /home/unreal/unrealircd/conf/unrealircd.conf
# env vars sourced from env file
sed -i s"/%SECRET_IRC_OPER_PASSWORD%/${SECRET_IRC_OPER_PASSWORD}/" /home/unreal/unrealircd/conf/unrealircd.conf
sed -i s"/%SECRET_IRC_SERVICE_PASSWORD%/${SECRET_IRC_SERVICE_PASSWORD}/" /home/unreal/unrealircd/conf/unrealircd.conf
sed -i s"/%SECRET_IRC_CLOAK_KEY1%/${SECRET_IRC_CLOAK_KEY1}/" /home/unreal/unrealircd/conf/unrealircd.conf
sed -i s"/%SECRET_IRC_CLOAK_KEY2%/${SECRET_IRC_CLOAK_KEY2}/" /home/unreal/unrealircd/conf/unrealircd.conf
sed -i s"/%SECRET_IRC_CLOAK_KEY3%/${SECRET_IRC_CLOAK_KEY3}/" /home/unreal/unrealircd/conf/unrealircd.conf

/home/unreal/unrealircd/unrealircd start

while true
do
	if pgrep -f unrealircd 1> /dev/null;then
		sleep 1
	else
		echo SERVER CRASHED
		exit 1
	fi
done
