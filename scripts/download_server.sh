#!/bin/sh -e

: "${STEAM_USERNAME:=$1}"
: "${STEAM_TAR:=$2}"

if [ -z "${STEAM_USERNAME}" ]
then
        echo "ERROR: You need to provide a Steam username you want to download the server as"
        exit 1
fi

container_name="steam_dayzserver_$(date +%s)"
trap 'docker rm -f "${container_name}" >/dev/null' EXIT

mkdir -p /tmp/steam
cp "${STEAM_TAR}" /tmp/userdata.tar
tar -C /tmp/steam -xf /tmp/userdata.tar

docker run --name "${container_name}" \
        -v "/tmp/steam/Steam:/home/steam/Steam" -v "/opt/dayzserver:/opt/dayzserver" \
        -it cm2network/steamcmd \
        /home/steam/steamcmd/steamcmd.sh \
        +@ShutdownOnFailedCommand 1 \
        +@NoPromptForPassword 1 \
        +@sSteamCmdForcePlatformType windows \
        +login ${STEAM_USERNAME} \
        +force_install_dir /opt/dayzserver \
        +app_update 223350 validate \
        +quit

rm -rf /tmp/userdata.tar /tmp/steam