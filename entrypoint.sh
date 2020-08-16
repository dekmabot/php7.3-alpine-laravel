#!/bin/bash

mkdir -p /var/run/sshd /var/log/supervisor /var/www/bootstrap/cache /var/www/storage/logs /var/www/storage/framework
chmod -R 0777 /var/www/bootstrap/cache /var/www/storage/logs /var/www/storage/framework

chown -R www-data:www-data /var/www/bootstrap/cache && chmod -R 0777 /var/www/bootstrap/cache
chown -R www-data:www-data /var/www/storage && chmod -R 0775 /var/www/storage

php artisan storage:link
php artisan migrate

#crontab -u www-data /var/www/cron.txt

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf