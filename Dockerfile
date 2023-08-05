FROM ubuntu:latest AS runner

ARG VERSION

ENV \
	RUNNER_PATH=/runner \
	RUNNER_URL=https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-linux-x64-${VERSION}.tar.gz

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
	&& apt-get install -y --no-install-recommends \
		curl \
		ca-certificates \
		gnupg \
		git \
		systemd \
		dotnet-runtime-7.0 \
	&& install -m 0755 -d /etc/apt/keyrings \
	&& curl -f -sSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
	&& chmod a+r /etc/apt/keyrings/docker.gpg \
	&& echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu focal stable" > /etc/apt/sources.list.d/docker.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends \
		docker-ce \
		docker-ce-cli \
		containerd.io \
		docker-buildx-plugin \
		docker-compose-plugin \
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
	&& chmod -R 777 ${USER_PATH} \
	&& mkdir /var/run/docker.sock \
	&& chmod 777 /var/run/docker.sock \
	&& systemctl enable docker
	
COPY --from=runner ${USER} ${RUNNER_PATH}

COPY ./entrypoint.sh ${RUNNER_PATH}/entrypoint.sh

WORKDIR ${RUNNER_PATH}

ARG TOKEN

ENV \
	RUNNER_ALLOW_RUNASROOT=0 \
	RUNNER_ORGANIZATION=dolorestec \
	RUNNER_NAME=dlrs-runner-${TOKEN} \
	RUNNER_WORKDIR=${RUNNER_PATH}/_work \
	RUNNER_REPLACE_EXISTING=1 \
	RUNNER_LABELS=dlrs \
	RUNNER_GROUP=default \
	RUNNER_URL=https://github.com/dolorestec \
	RUNNER_TOKEN=${TOKEN}

	
RUN chmod +x entrypoint.sh

USER ${USER}
ENTRYPOINT [ "./entrypoint.sh" ]