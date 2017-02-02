FROM ubuntu:trusty
# Set up system and unreal user
ENV LC_ALL C
ENV TERM="vt100"
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y \
 wget build-essential curl cmake file expect libssl-dev
RUN groupadd -r unreal && useradd -r -g unreal unreal
RUN mkdir -p /home/unreal
RUN chown unreal:unreal /home/unreal
USER unreal
ENV HOME /home/unreal
WORKDIR /home/unreal

# Build unreal
ARG unreal_version
ENV UNREAL_VERSION ${unreal_version:-4.0.1}
RUN wget https://www.unrealircd.org/unrealircd4/unrealircd-${UNREAL_VERSION}.tar.gz
RUN tar -zxvf unrealircd-${UNREAL_VERSION}.tar.gz
WORKDIR unrealircd-${UNREAL_VERSION}
ADD config.settings ./config.settings
RUN ./Config
RUN make
RUN make install

CMD /home/unreal/unrealircd/unrealircd start
