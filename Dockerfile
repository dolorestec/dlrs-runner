FROM alpine:latest AS runner

ENV RUNNER_PATH=/runner

WORKDIR $RUNNER_PATH

RUN apk add --no-cache curl \
	&& curl -f -o actions-runner-linux-x64-2.307.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.307.1/actions-runner-linux-x64-2.307.1.tar.gz \
	&& tar xzf ./actions-runner-linux-x64-2.307.1.tar.gz

CMD ["sh", "-c", "./config.sh", "--url", "https://github.com/dolorestec", "--token", "${RUNNER_TOKEN}"]

ENTRYPOINT [ "sh", "-c", "exec ./run.sh" ]
