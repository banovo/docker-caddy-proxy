# docker-caddy-proxy
Automated Caddy Reverse Proxy for Docker - based on jwilder/nginx-proxy and BlackGlory/caddy-proxy

docker-caddy-proxy sets up a container running caddy and [docker-gen][1].  docker-gen generates reverse proxy configs for caddy and reloads caddy when containers are started and stopped.


### Usage

To run it:

    $ docker run -d -p 80:80 -v /var/run/docker.sock:/tmp/docker.sock:ro banovo/docker-caddy-proxy

Then start any containers you want proxied with an env var `VIRTUAL_HOST=subdomain.youdomain.com`

    $ docker run -e VIRTUAL_HOST=foo.bar.com  ...

The containers being proxied must [expose](https://docs.docker.com/engine/reference/run/#expose-incoming-ports) the port to be proxied, either by using the `EXPOSE` directive in their `Dockerfile` or by using the `--expose` flag to `docker run` or `docker create`.

Provided your DNS is setup to forward foo.bar.com to the a host running caddy-proxy, the request will be routed to a container with the VIRTUAL_HOST env var set.
