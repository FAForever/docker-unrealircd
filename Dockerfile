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
COPY anope-make.expect /home/unreal/anope-make.expect
COPY deploy-anope.sh /home/unreal/deploy-anope.sh
RUN chmod +x /home/unreal/deploy-anope.sh

RUN wget https://www.unrealircd.org/unrealircd4/unrealircd-$UNREAL_VERSION.tar.gz
RUN tar -zxvf unrealircd-$UNREAL_VERSION.tar.gz
WORKDIR unrealircd-$UNREAL_VERSION
COPY config.settings ./config.settings
RUN ./Config
RUN make
RUN make install
RUN echo $MOTD > ircd.motd
RUN echo $RULES > ircd.rules

WORKDIR /home/unreal
RUN /home/unreal/deploy-anope.sh
COPY unrealircd.conf.template /home/unreal/unrealircd.conf.template
COPY services.conf.template /home/unreal/services.conf.template
COPY default-cmd.sh /home/unreal/default-cmd.sh
COPY run_anope.sh /home/unreal/run_anope.sh
RUN chmod +x /home/unreal/default-cmd.sh
RUN chmod +x /home/unreal/run_anope.sh
RUN chown -R unreal:unreal /home/unreal

USER unreal:unreal
ENV HOME /home/unreal
CMD ./default-cmd.sh

HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD ["./healthcheck.sh"]
