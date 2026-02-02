FROM alpine:3.22.0

RUN apk update && apk add --no-cache nginx openssl gettext

ARG DOMAIN_NAME

COPY tools/ssl.sh /usr/bin/ssl.sh
RUN chmod +x /usr/bin/ssl.sh && /usr/bin/ssl.sh "$DOMAIN_NAME"

COPY tools/entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

COPY conf/nginx.conf /etc/nginx/http.d/default.conf.template

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
