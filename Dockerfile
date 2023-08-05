FROM alpine:latest AS runner

ENV RUNNER_PATH=/runner
ENV RUNNER_VERSION="2.307.1"
ENV RUNNER_URL=https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

WORKDIR ${RUNNER_PATH}

RUN apk add --no-cache \
	ca-certificates \
	curl \
	&& curl -sSL ${RUNNER_URL} | tar -xz \
	&& rm -rf /var/cache/apk/* \
	&& rm -rf *.tar.gz

FROM alpine:latest AS builder

ENV RUNNER_PATH=/runner

COPY --from=runner ${RUNNER_PATH} ${RUNNER_PATH}

RUN apk add --no-cache \
	git \
	curl \
	ca-certificates \
	openrc \
	docker \
	docker-cli \
	docker-cli-buildx \
	docker-cli-compose \
	&& rm -rf /var/cache/apk/* \
	&& rc-update add docker boot

WORKDIR ${RUNNER_PATH}

COPY ./entrypoint.sh ${RUNNER_PATH}

RUN chmod +x ${RUNNER_PATH}/*.sh

#ENTRYPOINT [ "sh", "entrypoint.sh" ]
ENTRYPOINT [ "/bin/sh" ]