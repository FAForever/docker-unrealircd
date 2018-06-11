#!/bin/bash
## dependencys

## Install anope
wget -O anope-$ANOPE_VERSION-source.tar.gz https://github.com/anope/anope/releases/download/$ANOPE_VERSION/anope-$ANOPE_VERSION-source.tar.gz
tar -zxvf anope-$ANOPE_VERSION-source.tar.gz
cd anope-$ANOPE_VERSION-source
cp modules/extra/m_mysql.cpp modules/m_mysql.cpp
/usr/bin/expect /home/unreal/anope-make.expect
cd build
make
make install

cp /home/unreal/unrealircd/services/conf/example.conf /home/unreal/unrealircd/services/conf/services.conf
#Make a edit for unrealircd linking
#Run Anope:
#./services
