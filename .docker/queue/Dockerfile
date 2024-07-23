### Base Image Build ###
FROM php:8.2.2-fpm AS base
WORKDIR /app
RUN echo "Australia/Brisbane" >/etc/timezone && dpkg-reconfigure -f noninteractive tzdata

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
  libssl-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libzip-dev libfontconfig libxml2-dev libxrender1 libxtst6 libfreetype6-dev libxtst6 curl wkhtmltopdf wget \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
  && ln -s /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf \
  && mkdir -p /etc/ssl/certs \
  && wget https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -O /etc/ssl/certs/rds-combined-ca-bundle.pem \
  && chmod 664 /etc/ssl/certs/rds-combined-ca-bundle.pem

RUN pecl install redis \
  && docker-php-ext-install pdo_mysql gd zip soap xml \
  && docker-php-ext-enable opcache redis pdo_mysql gd

### Only for Production ###
FROM base AS application

WORKDIR /app
COPY . /app

# Prime the cache directory.
RUN chgrp -R www-data /app/storage /app/bootstrap/cache \
  && chmod -R ug+rwx /app/storage /app/bootstrap/cache

ADD .docker/queue/queue.sh /usr/local/bin/queue.sh
# link script in root directory
RUN chmod 777 /usr/local/bin/queue.sh \
  && ln -s /usr/local/bin/queue.sh /
ENTRYPOINT ["queue.sh"]
