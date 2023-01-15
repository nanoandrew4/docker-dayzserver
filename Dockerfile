FROM jlesage/baseimage-gui:debian-11

# Stage 2: Add Wine and GUI stuff

# wine
#ADD https://dl.winehq.org/wine-builds/Release.key /wine-builds.key
RUN \
	export DEBIAN_FRONTEND=noninteractive \
	&& dpkg --add-architecture i386 \
	&& apt-get -y update \
	&& apt-get -y install gnupg2 apt-transport-https wget cabextract xz-utils winbind \
	&& mkdir -pm755 /etc/apt/keyrings \
	&& wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

RUN \
	export DEBIAN_FRONTEND=noninteractive \
	&& dpkg --add-architecture i386 \
	&& wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bullseye/winehq-bullseye.sources \
	&& apt-get -y update \
	&& add-pkg --allow-unauthenticated winehq-stable procps

RUN \
	wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks \
	&& chmod +x winetricks \
	&& cp winetricks /usr/local/bin/winetricks \
	&& winetricks faudio

# COPY --from=0 /opt/dayzserver/ /opt/dayzserver/

# RUN useradd -k /var/empty -G tty -m -N -r dayzserver

COPY ./docker/rootfs/ /
# RUN cp -va /opt/dayzserver/docker/rootfs/* / && rm -r /opt/dayzserver/docker
ADD https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 /usr/local/bin/gosu
RUN chmod -v a+x /usr/local/bin/* /*.sh
# RUN mv -v /opt/dayzserver/mpmissions /opt/dayzserver/mpmissions.template && ln -s /config/mpmissions /opt/dayzserver/mpmissions
ENV APP_NAME="DayZ Server"
WORKDIR /config