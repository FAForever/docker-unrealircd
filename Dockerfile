FROM ubuntu:trusty
ENV LC_ALL C
ENV UNREAL_VERSION="4.0.17"
ENV ANOPE_VERSION="2.0.6"
ENV MOTD="Welcome to Forged Alliance Forever chat"
ENV RULES=""
ENV TERM="vt100"
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
 wget build-essential curl cmake file expect libssl-dev libmysqlclient-dev mysql-client-5.6
RUN groupadd -r unreal && useradd -r -g unreal unreal
RUN mkdir -p /home/unreal
RUN chown unreal:unreal /home/unreal


WORKDIR /home/unreal
COPY --chown=unreal:unreal anope-make.expect /home/unreal/anope-make.expect
COPY --chown=unreal:unreal deploy-anope.sh /home/unreal/deploy-anope.sh
RUN chmod +x /home/unreal/deploy-anope.sh

USER unreal
WORKDIR /home/unreal
RUN wget https://www.unrealircd.org/unrealircd4/unrealircd-$UNREAL_VERSION.tar.gz
RUN tar -zxvf unrealircd-$UNREAL_VERSION.tar.gz
WORKDIR unrealircd-$UNREAL_VERSION
COPY --chown=unreal:unreal config.settings ./config.settings

RUN ./Config
RUN make
RUN make install
RUN echo $MOTD > ircd.motd
RUN echo $RULES > ircd.rules

WORKDIR /home/unreal
RUN /home/unreal/deploy-anope.sh

USER root
COPY --chown=unreal:unreal unrealircd.conf.template /home/unreal/unrealircd.conf.template
COPY --chown=unreal:unreal services.conf.template /home/unreal/services.conf.template
COPY --chown=unreal:unreal default-cmd.sh /home/unreal/default-cmd.sh
COPY --chown=unreal:unreal run_anope.sh /home/unreal/run_anope.sh
RUN chmod +x /home/unreal/default-cmd.sh
RUN chmod +x /home/unreal/run_anope.sh

USER unreal
ENV HOME /home/unreal

RUN sh default-cmd.sh

HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD ["./healthcheck.sh"]

