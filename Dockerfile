FROM ubuntu:22.04

# To most basic version of Harbour, no extra contribs using external dependency.

# for apt to be noninteractive
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

# Used by running apps to detect if inside a docker container. Testing for existence of /.dockerenv may not always work.
ENV InDocker=True

ARG HB_GIT_URL
ARG HB_REF
ENV HB_GIT_URL=${HB_GIT_URL}
ENV HB_REF=${HB_REF}

RUN apt-get update && apt-get install -y apt-utils

# Run update again to work around git install failure introduced around April 2023
RUN apt-get update

RUN apt-get install -y \
  git \
  build-essential \
  libgpm2 \
  gnupg \
  wget \
  psmisc \
  curl \
  libcurl4-openssl-dev \
  libssl-dev \
  gcc \
  ca-certificates

RUN cp -r /usr/include/x86_64-linux-gnu/curl /usr/include

RUN apt-get update && apt-get -y upgrade
