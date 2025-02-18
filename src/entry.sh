#!/bin/bash
# NOTE: Without the wait the script exists before giving the server time to properly stop
function clean_up {
	kill -SIGINT $serverPID
	wait
}

# Setup trap
trap "clean_up" SIGINT SIGTERM

cd ${STEAMAPPDIR}

if [ $AUTO_UPDATE]; then
    steamcmd \
	+force_install_dir "${STEAMAPPDIR}" \
	+login ${STEAM_LOGIN} \
	+app_update "${STEAMAPP_ID}" validate \
	+quit
fi

# We assume that if the config is missing, that this is a fresh container
if [ ! -f "${STEAM_SAVEDIR}/server.cfg" ]; then
    cp "${STEAMAPPDIR}/server.cfg" "${STEAM_SAVEDIR}"
    # Add in config file modification using environment variables
	sed -i "s/[[SERVER_NAME]]/${SERVER_NAME}/g" "${STEAM_SAVEDIR}/server.cfg"
	sed -i "s/[[SERVER_PASSWORD]]/${SERVER_PASSWORD}/g" "${STEAM_SAVEDIR}/server.cfg"
	sed -i "s/[[ADMIN_PASSWORD]]/${ADMIN_PASSWORD}/g" "${STEAM_SAVEDIR}/server.cfg"
fi

#list all mods inside of mods folder with @ infront
filearray=(./mods/@*)
mod_string=""

for i in "${filearray[@]}"
do
	mod_string="${mod_string}${i};"
done

#build full launch string
# example launch string 	./arma3server -name=server -config=server.cfg
./arma3server -name=${SERVER_NAME} -config=./config/server.cfg -mod="${mod_string}" & serverPID=$!

wait $serverPID

exit 0