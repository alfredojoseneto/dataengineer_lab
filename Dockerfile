FROM python:3-slim-bullseye

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive && \
    pip install jupyterlab

RUN useradd -m -s /bin/bash nonroot

USER nonroot

WORKDIR /workdir/

CMD ["bash", "-c", "jupyter lab --port-retries=0 --ip 0.0.0.0 --port 8888 --allow-root --IdentityProvider.token='' --ServerApp.password=''"]
