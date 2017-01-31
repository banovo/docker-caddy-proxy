caddy: caddy -conf /etc/Caddyfile -pidfile /var/run/caddy.pid ${ENV_CADDY_OPTIONS}
dockergen: sleep 2 && docker-gen -watch -notify "kill -USR1 $(cat /var/run/caddy.pid)" /app/Caddyfile.tmpl /etc/Caddyfile
