FROM ubuntu:latest AS runner

ENV \
	RUNNER_PATH=/runner \
	RUNNER_URL=https://github.com/actions/runner/releases/download/v2.307.1/actions-runner-linux-x64-2.307.1.tar.gz

WORKDIR $RUNNER_PATH

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		ca-certificates \
		curl  \
	&& curl -f -o actions-runner-linux-x64-2.307.1.tar.gz -L ${RUNNER_URL} \
	&& tar xzf ./actions-runner-linux-x64-2.307.1.tar.gz \
	&& rm -f ./actions-runner-linux-x64-2.307.1.tar.gz \
	&& rm -rf /var/lib/apt/lists/*

FROM ubuntu:latest AS builder

RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		git \
		ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

ENV \
	USER=runner \
	USER_PATH=/root \
 	RUNNER_PATH=/root/runner \
	DEBIAN_FRONTEND=noninteractive \
	DEBCONF_NONINTERACTIVE_SEEN=true

RUN mkdir -p ${RUNNER_PATH} \
	&& useradd -d ${USER_PATH} -s /bin/bash -m ${USER} \
	&& chown -R ${USER}:${USER} ${USER_PATH} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
	&& chown -R ${USER}:${USER} ${USER_PATH} \
	&& chmod -R 777 ${USER_PATH}

COPY --from=runner ${USER} ${RUNNER_PATH}

COPY ./entrypoint.sh ${RUNNER_PATH}/entrypoint.sh

WORKDIR ${RUNNER_PATH}

ENV \
	RUNNER_ALLOW_RUNASROOT=0 \
	RUNNER_ORGANIZATION=dolorestec \
	RUNNER_NAME=dlrs-runner-1 \
	RUNNER_WORKDIR=${RUNNER_PATH}/_work \
	RUNNER_REPLACE_EXISTING=1 \
	RUNNER_LABELS=dlrs \
	RUNNER_GROUP=default \
	RUNNER_URL=https://github.com/dolorestec \
	RUNNER_TOKEN=${RUNNER_TOKEN}

	
RUN chmod +x ${RUNNER_PATH}/entrypoint.sh \
	&& chmod +x ${RUNNER_PATH}/bin/installdependencies.sh \
	&& ./bin/installdependencies.sh

USER ${USER}
ENTRYPOINT [ "./entrypoint.sh" ]