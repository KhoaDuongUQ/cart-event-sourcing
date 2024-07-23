#!/bin/sh
set -e

php /app/artisan migrate --force
php /app/artisan db:seed --force --class=ProductionDatabaseSeeder

# queue, restart on failure
while [ true ]
do
    php /app/artisan queue:work --queue=high,default --verbose --no-interaction --tries=3 --timeout=90
done
