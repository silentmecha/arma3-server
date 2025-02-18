FROM silentmecha/arma-3-server:latest

ENV AUTO_UPDATE=False

RUN bash steamcmd \
	+force_install_dir "${STEAMAPPDIR}" \
	+login "${STEAM_LOGIN}" \
	+app_update "${STEAMAPP_ID}" validate \
	+quit