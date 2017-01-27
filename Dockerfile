FROM ubuntu:trusty
ENV LC_ALL C
ENV UNREAL_VERSION="4.0.1"
ENV ANOPE_VERSION="2.0.2"
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
USER unreal
ENV HOME /home/unreal
WORKDIR /home/unreal
ADD deploy-unrealirc.sh /usr/bin/deploy-unrealirc
ADD config /home/unreal/config
ADD anope-make.expect /home/unreal/anope-make.expect
COPY deploy-anope /usr/bin/deploy-anope
USER root
RUN chmod +x /usr/bin/deploy-unrealirc
RUN chmod +x /usr/bin/deploy-anope
USER unreal

RUN wget https://www.unrealircd.org/unrealircd4/unrealircd-4.0.1.tar.gz
RUN tar -zxvf unrealircd-$UNREAL_VERSION.tar.gz
WORKDIR unrealircd-$UNREAL_VERSION
ADD config.settings ./config.settings
RUN ./Config
RUN make
RUN make install
RUN echo $MOTD > ircd.motd
RUN echo $RULES > ircd.rules

WORKDIR /home/unreal
RUN deploy-anope
ADD unrealircd.conf.template /home/unreal/unrealircd.conf.template
ADD services.conf.template /home/unreal/services.conf.template
ADD default-cmd.sh /home/unreal/default-cmd.sh
ADD run_anope.sh /home/unreal/run_anope.sh
USER root
RUN chmod +x /home/unreal/default-cmd.sh
RUN chmod +x /home/unreal/run_anope.sh
USER unreal

CMD ./default-cmd.sh

HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD ["./healthcheck.sh"]
