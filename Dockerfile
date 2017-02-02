FROM ubuntu:trusty
ENV LC_ALL C
# Set up system and user
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

# Install anope
ARG anope_version
ENV ANOPE_VERSION ${anope_version:-2.0.3}
WORKDIR /home/unreal
RUN wget -O anope-${ANOPE_VERSION}-source.tar.gz https://github.com/anope/anope/releases/download/${ANOPE_VERSION}/anope-${ANOPE_VERSION}-source.tar.gz
RUN tar -zxvf anope-${ANOPE_VERSION}-source.tar.gz
WORKDIR /home/unreal/anope-${ANOPE_VERSION}-source
# enable mysql module
RUN cp modules/extra/m_mysql.cpp modules/m_mysql.cpp
# run config script
ADD config.cache ./config.cache
RUN ./Config -quick
WORKDIR /home/unreal/anope-${ANOPE_VERSION}-source/build
RUN make
RUN make install

ADD default-cmd.sh /home/unreal/default-cmd.sh

CMD ./default-cmd.sh

HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD ["./healthcheck.sh"]
