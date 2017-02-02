#!/bin/bash

SERVICE_SOURCE_CONF=/home/unreal/services.conf.template
SERVICE_TARGET_CONF=/home/unreal/unrealircd/services/conf/services.conf

if [ ! -f "${SERVICE_TARGET_CONF}" ]; then
  mkdir -p $(dirname "${SERVICE_TARGET_CONF}")
  cp "${SERVICE_SOURCE_CONF}" "${SERVICE_TARGET_CONF}"
  sed -i "s/%SECRET_SERV_PASS%/${SECRET_SERV_PASS}/" ${SERVICE_TARGET_CONF}
  sed -i "s/%SECRET_MYSQL_SERVER%/${SECRET_MYSQL_SERVER}/" ${SERVICE_TARGET_CONF}
fi

/home/unreal/unrealircd/services/bin/services -nofork -debug
