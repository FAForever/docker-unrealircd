#!/bin/bash

SERVICE_SOURCE_CONF=/home/unreal/services.conf.template
SERVICE_TARGET_CONF=/home/unreal/unrealircd/services/conf/services.conf

UNREAL_SOURCE_CONF=/home/unreal/unrealircd.conf.template
UNREAL_TARGET_CONF=/home/unreal/unrealircd/conf/unrealircd.conf

if [ ! -f "${SERVICE_TARGET_CONF}" ]; then
  mkdir -p $(dirname "${SERVICE_TARGET_CONF}")
  cp "${SERVICE_SOURCE_CONF}" "${SERVICE_TARGET_CONF}"
  sed -i "s/%SECRET_SERV_PASS%/${SECRET_SERV_PASS}/" ${SERVICE_TARGET_CONF}
  sed -i "s/%SECRET_MYSQL_SERVER%/${SECRET_MYSQL_SERVER}/" ${SERVICE_TARGET_CONF}
fi

if [ ! -f "${UNREAL_TARGET_CONF}" ]; then
  mkdir -p $(dirname "${UNREAL_TARGET_CONF}")
  cp "${UNREAL_SOURCE_CONF}" "${UNREAL_TARGET_CONF}"
  sed -i "s/%SECRET_OPER_PASS%/${SECRET_OPER_PASS}/" ${UNREAL_TARGET_CONF}
  sed -i "s/%SECRET_SERV_PASS%/${SECRET_SERV_PASS}/" ${UNREAL_TARGET_CONF}
  sed -i "s/%SECRET_CLOAK_KEY_1%/${SECRET_CLOAK_KEY_1}/" ${UNREAL_TARGET_CONF}
  sed -i "s/%SECRET_CLOAK_KEY_2%/${SECRET_CLOAK_KEY_2}/" ${UNREAL_TARGET_CONF}
  sed -i "s/%SECRET_CLOAK_KEY_3%/${SECRET_CLOAK_KEY_3}/" ${UNREAL_TARGET_CONF}
fi

/home/unreal/unrealircd/unrealircd start && /home/unreal/run_anope.sh
