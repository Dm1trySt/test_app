# README

## Стек:
* Ruby 3.2
* Rails 7.1
* Docker, Docker Compose

## Развертывание ENV development:

* Заполнить в файле /.env DB_USER, DB_PASSWORD, DB_NAME (значения придумать свои), проверить значения UID `id -u` и GID `id -g`, они должны совпадать, если не совпадают - заменить на полученные значения из консоли;
* В файле ./env закоментировать строчку RAILS_MASTER_KEY=YOUR_RAILS_MASTER_KEY;
* Удалить старый файл /config/credentials.yml.enc он нужен только в качестве примера и без ключа (master.key), который использовался при его заполнении бесполезен;
* Сбор образа `docker compose up -d --build`;
* Генерация нового RAILS_MASTER_KEY `docker compose run --rm app bundle exec rails credentials:edit`, будет создан файл /config/master.key в котором и будет находиться новый ключ, который нужно будет подставить в ./env RAILS_MASTER_KEY и раскомментировать строку;
* Получение SECRET_KEY_BASE для /.env `docker compose run --rm app bundle exec rails secret`, в ответ на команду консоль отдаст длинный код это и будет нужный ключ;
* Запуск rails `docker compose up -d`
* Запуск миграции `docker compose exec app bundle exec rails db:prepare`;
