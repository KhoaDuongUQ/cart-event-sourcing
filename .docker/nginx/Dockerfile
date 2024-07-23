FROM nginx:1.19.3 AS base

RUN apt-get update && apt-get install -y nginx-extras

ARG ENVIRONMENT="local"
ARG NGINX_DIR="/etc/nginx"
RUN rm "$NGINX_DIR/sites-enabled/default"
ADD ".docker/nginx/conf/local.conf" "$NGINX_DIR/conf.d/default.conf"

FROM base AS web
COPY . /app
