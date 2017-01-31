FROM alpine:3.5
MAINTAINER Patrick Kaiser <docker@pk.banovo.de>

ENV DOCKER_HOST unix:///tmp/docker.sock
ENV DOCKER_GEN_VERSION 0.7.3
ENV FOREGO_VERSION v0.16.1

# Install base packages
RUN apk --no-cache add ca-certificates openssl bash tar curl wget

# Install Caddy Server, and middleware: cors, expires, filter, ipfilter, minify, ratelimit, realip
RUN mkdir -p /tmp/docker && mkdir -p /app && cd /tmp/docker && wget -O caddy.tar.gz "https://caddyserver.com/download/build?os=linux&arch=amd64&features=cors%2Cexpires%2Cfilter%2Cipfilter%2Cminify%2Cratelimit%2Crealip" && \
    tar xfz caddy.tar.gz && mv caddy /usr/local/bin && rm -rf /tmp/docker

# Install docker-gen
RUN mkdir -p /tmp/docker && cd /tmp/docker && wget -O docker-gen.tar.gz "https://github.com/jwilder/docker-gen/releases/download/${DOCKER_GEN_VERSION}/docker-gen-alpine-linux-amd64-${DOCKER_GEN_VERSION}.tar.gz" && \
    tar xfz docker-gen.tar.gz && mv docker-gen /usr/local/bin && rm -rf /tmp/docker

# Install Forego
RUN wget -O /usr/local/bin/forego https://github.com/jwilder/forego/releases/download/${FOREGO_VERSION}/forego

# Copy default Caddyfile + docker-gen Caddyfile.tmpl
COPY ./Caddyfile /etc/Caddyfile

# Copy docker entrypoint
COPY ./Procfile ./Caddyfile.tmpl ./docker-entrypoint.sh /app/
WORKDIR /app/

# Set perms
RUN chmod u+x /usr/local/bin/* /app/docker-entrypoint.sh

# EXPOSE default ports
EXPOSE 80 443 2015

# Default volume to store ssl certs
VOLUME /root/.caddy

# Entrypoint to check for docker socket
ENTRYPOINT ["/app/docker-entrypoint.sh"]

# See Procfile for process start instructions
CMD ["forego", "start", "-r"]
