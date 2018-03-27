FROM ubuntu:16.04

ARG user=developer
ARG group=developer
ARG uid=2000
ARG gid=2000

RUN \
  apt-get update \
  && apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  openjdk-8-jre-headless \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) \
  stable" \
  && apt-get update \
  && apt-get install -y docker-ce \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/docker/compose/releases/download/1.20.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Add a user
ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group} \
  && useradd -d "$HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER ${user}
WORKDIR ${HOME}
