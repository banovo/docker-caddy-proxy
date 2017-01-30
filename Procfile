caddy: caddy -conf /etc/Caddyfile --pid /var/run/caddy.pid ${ENV_CADDY_OPTIONS}
dockergen: docker-gen -watch -notify "kill -USR1 $(cat /var/run/caddy.pid)" /app/Caddyfile.tmpl /etc/Caddyfile
