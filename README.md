unrealircd for FAF
==============

UnrealIRCD without(!) Anope Services based on dockerimages/docker-unrealircd

# docker-compose


    faf-unrealircd:
      container_name: faf-unrealircd
      build:
        context: ./docker-unrealircd
        args:
          unreal_version: '4.0.1'
          maxconnections: '5000'
      ulimits:
        nofile:
          soft: 8192
          hard: 8192
      networks:
        faf:
          aliases:
            - "faf-irc"
            - "irc.faforever.com"
            - "services.faforever.com"
      depends_on:
        faf-db:
          condition: service_healthy
      volumes:
        - ./config/faf-unrealircd/ssl:/home/unreal/unrealircd/conf/ssl
        - ./config/faf-unrealircd/services.conf:/home/unreal/unrealircd/services/conf/services.conf
        - ./config/faf-unrealircd/unrealircd.conf:/home/unreal/unrealircd/conf/unrealircd.conf
      restart: always
      ports:
        - "6667:6667"
        - "6697:6697"
        - "6665:6665"
        - "6666:6666"
        - "8067:8067"
        - "7070:7070"
        - "8167:8167"

# preparation

## SSL

Put SSL cert and key to `server.cert.pem` and `server.key.pem`.

For testing, create self-signed certificate:

    openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout server.key.pem -out server.cert.pem

# build

    docker build -t unrealirc

Available args:

* `unreal_version': Version of unreal tarball to pull
* `maxconnections`: MAXCONNECTIONS setting in `config.settings`

# usage

Test/Inspection:

    docker run -ti unrealirc /bin/bash

Production:

    docker run unrealirc
