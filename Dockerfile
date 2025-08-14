FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Dependências equivalentes ao workflow
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      libcurl4-openssl-dev \
      libssl-dev \
      ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Script de build
COPY build_harbour.sh /usr/local/bin/build-harbour
RUN chmod +x /usr/local/bin/build-harbour

# Ponto de montagem para o seu fork
RUN mkdir -p /work/harbour /output
VOLUME ["/work/harbour", "/output"]

CMD ["/usr/local/bin/build-harbour"]
