#!/bin/bash
cp .env.example .env

docker stop db webserver app
docker rm db webserver app
docker-compose down
docker run --rm -v $(pwd):/app composer install
sudo chown -R $USER:$USER $(pwd)
docker-compose up -d
docker-compose exec app php artisan key:generate
docker-compose exec app php artisan config:cache
echo "line 11"

#if you want to just want to connect to the sql server and get a prompt it is :
# docker-compose exec db mysql -u root -ppassword
# command " use laravel" uses the laravel database

docker-compose exec db mysql -u root -ppassword -Bse "
GRANT ALL ON laravel.* TO 'laraveluser'@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
"

# Not sure if I want to always perform a php artisan migrate everytime
docker-compose exec app php artisan migrate 