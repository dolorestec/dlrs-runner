FROM alpine:latest AS build
LABEL maintainer="Lucas Cantarelli"
# Environment Variables
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV APP_PATH=/app
ENV POETRY_VIRTUALENV_PATH=${APP_PATH}/.venv
ENV POETRY_CACHE_DIR=${POETRY_VIRTUALENV_PATH}/.cache
ENV PATH="${POETRY_VIRTUALENV_PATH}/bin:${PATH}"
# Workdir
WORKDIR ${APP_PATH}
COPY ./entrypoint.sh ${APP_PATH}/entrypoint.sh

RUN apk add --no-cache \
	openrc \
	docker \
	docker-cli \
	docker-cli-buildx \
	docker-cli-compose \
	python3 \
	&& chmod +x ${APP_PATH}/entrypoint.sh \
	&& rc-update add docker boot

ENTRYPOINT [ "sh", "entrypoint.sh" ]
