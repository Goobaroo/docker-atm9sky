#!/bin/bash

set -x

FORGE_VERSION=1.20.1-1.20.1-47.4.0
cd /data

if ! [[ "$EULA" = "false" ]]; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA to install."
	exit 99
fi

if ! [[ -f 'ServerFiles-1.1.6.zip' ]]; then
	rm -fr config defaultconfigs kubejs mods packmenu *.zip forge*
	curl -Lo 'ServerFiles-1.1.6.zip' 'https://edge.forgecdn.net/files/6556/943/ServerFiles-1.1.6.zip' || exit 9
	unzip -u -o 'ServerFiles-1.1.6.zip' -d /data
	if [[ $(find /data -maxdepth 2 -name 'mods' -type d | wc -c) -gt 11 ]]; then
	  INSTALL_SUBDIR=$(find /data -maxdepth 2 -name 'mods' -type d | sed 's/\/mods//')
	  mv -f $(echo $INSTALL_SUBDIR)/* /data
		rm -fr $(echo $INSTALL_SUBDIR)
	fi
	curl -Lo forge-${FORGE_VERSION}-installer.jar http://files.minecraftforge.net/maven/net/minecraftforge/forge/$FORGE_VERSION/forge-$FORGE_VERSION-installer.jar
	java -jar forge-${FORGE_VERSION}-installer.jar --installServer
fi

if [[ -n "$JVM_OPTS" ]]; then
	sed -i '/-Xm[s,x]/d' user_jvm_args.txt
	for j in ${JVM_OPTS}; do sed -i '$a\'$j'' user_jvm_args.txt; done
fi
if [[ -n "$MOTD" ]]; then
    sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' > ops.txt
fi
if [[ -n "$ALLOWLIST" ]]; then
    echo $ALLOWLIST | awk -v RS=, '{print}' > white-list.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties
chmod 755 run.sh

./run.sh