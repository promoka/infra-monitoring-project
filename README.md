# Infra Monitoring Project

Практическое задание: проверка доступности API, анализ access-логов и запуск echo-сервиса с Nginx через Docker Compose.

## Состав проекта

- `check_api.sh` — проверяет доступность URL и код HTTP-ответа.
- `analyze_logs.sh` — создаёт тестовый `access.log` из 300 записей и считает статистику.
- `docker-compose.yml` и `nginx/default.conf` — запускают API и обратный прокси Nginx.
- `.github/workflows/ci.yml` — проверяет Bash-скрипты при создании Pull Request.

## Запуск Bash-скриптов

```bash
chmod +x check_api.sh analyze_logs.sh
./check_api.sh https://httpbin.org/status/200
./check_api.sh invalid-url
./analyze_logs.sh
```

`analyze_logs.sh` создаёт файл `access.log` в текущей директории. Этот файл исключён из Git.

## Запуск контейнеров

Требуется Docker с поддержкой Docker Compose.

```bash
docker-compose up -d
curl http://localhost:80
docker-compose ps
docker-compose down
```

При успешном запросе `curl` выводит `Monitoring Service Active`.

## Передача проекта на сервер по SSH/SCP

Сначала создайте SSH-ключ на своей машине:

```bash
ssh-keygen -t ed25519 -C "student@example.com"
```

Скопируйте открытый ключ на сервер (замените пользователя и адрес сервера на свои):

```bash
ssh-copy-id user@server.example.com
```

После настройки доступа создайте архив проекта, исключив локальные служебные файлы, и передайте его на сервер:

```bash
tar --exclude=.git --exclude=access.log -czf infra-monitoring-project.tar.gz .
scp infra-monitoring-project.tar.gz user@server.example.com:~/
```

Распакуйте архив и запустите сервисы на сервере:

```bash
ssh user@server.example.com
mkdir -p ~/infra-monitoring-project
 tar -xzf ~/infra-monitoring-project.tar.gz -C ~/infra-monitoring-project
cd ~/infra-monitoring-project
chmod +x check_api.sh analyze_logs.sh
docker-compose up -d
```

Перед выполнением команд укажите реальные имя пользователя и адрес сервера.
