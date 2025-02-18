FROM silentmecha/steamcmd:latest

LABEL maintainer="silent@silentmecha.co.za"

ENV STEAMAPP_ID=233780
ENV STEAMAPP=Arma3
ENV STEAMAPPDIR="${HOME}/${STEAMAPP}-dedicated"
ENV STEAM_SAVEDIR="${HOME}/.local/share/Arma 3"
ENV STEAM_BACKUPDIR="${STEAM_SAVEDIR}/backup"
ENV AUTO_UPDATE=True
ENV STEAM_LOGIN=anonymous

USER root

COPY ./src/entry.sh ${HOME}/entry.sh

COPY ./src/server.cfg ${STEAMAPPDIR}/server.cfg.template

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& mkdir -p "${STEAMAPPDIR}/mods" \
	&& mkdir -p "${STEAMAPPDIR}/config" \
	&& mkdir -p "${STEAM_SAVEDIR}" \
    && wget -q --show-progress -O /usr/local/bin/bercon https://github.com/WoozyMasta/bercon/releases/latest/download/bercon \
    && chmod 755 "/usr/local/bin/bercon" "${HOME}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOME}/entry.sh" "${STEAMAPPDIR}" "${HOME}" "${STEAM_SAVEDIR}"

ENV SERVER_NAME="Arma 3 Docker" \
	PORT=2302 \
	QUERYPORT=2303 \
	MASTERPORT=2304 \
	VONPORT=2305 \
	BEPORT=2306 \
	SERVER_PASSWORD=secret \
	ADMIN_PASSWORD=ChangeMe \
	ADDITIONAL_ARGS=

# Switch to user
USER ${USER}

VOLUME ${STEAM_SAVEDIR}

WORKDIR ${HOME}

EXPOSE 	${PORT}/udp \
        ${QUERYPORT}/udp \
        ${MASTERPORT}/udp \
        ${VONPORT}/udp \
        ${BEPORT}/udp

CMD ["bash", "entry.sh"]
