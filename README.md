# DLRS Runner
## Description
Imagem Docker para runner do github.

### Dockerfile

#### ARGS
- VERSION: Versão do runner a ser instalado. Ex: 2.263.0
- TOKEN: Token de acesso do github.

#### ENV
docker build --tag dlrs-runner --load --build-arg TOKEN=<TOKEN> --build-arg VERSION=2.307.1 .
