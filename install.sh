#!/bin/bash

# Проверяем, запущен ли скрипт от root
if [[ $EUID -ne 0 ]]; then
   echo "Этот скрипт должен быть запущен от root пользователя" 
   exit 1
fi

# Обновляем систему
apt-get update
apt-get upgrade -y

# Устанавливаем Transmission
apt-get install -y transmission-daemon

# Останавливаем сервис для изменения конфигурации
systemctl stop transmission-daemon

# Создаем директорию для загрузок
mkdir -p /var/lib/transmission-daemon/downloads
chown -R debian-transmission:debian-transmission /var/lib/transmission-daemon/downloads

# Настраиваем конфигурацию
cat > /etc/transmission-daemon/settings.json <<EOL
{
    "alt-speed-down": 50,
    "alt-speed-enabled": false,
    "alt-speed-time-begin": 540,
    "alt-speed-time-day": 127,
    "alt-speed-time-enabled": false,
    "alt-speed-time-end": 1020,
    "alt-speed-up": 50,
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": false,
    "cache-size-mb": 4,
    "dht-enabled": true,
    "download-dir": "/var/lib/transmission-daemon/downloads",
    "download-queue-enabled": true,
    "download-queue-size": 5,
    "encryption": 1,
    "idle-seeding-limit": 30,
    "idle-seeding-limit-enabled": false,
    "incomplete-dir": "/var/lib/transmission-daemon/downloads",
    "incomplete-dir-enabled": false,
    "lpd-enabled": false,
    "max-peers-global": 200,
    "message-level": 2,
    "peer-port": 51413,
    "peer-port-random-high": 65535,
    "peer-port-random-low": 49152,
    "peer-port-random-on-start": false,
    "peer-socket-tos": "default",
    "pex-enabled": true,
    "port-forwarding-enabled": true,
    "preallocation": 1,
    "prefetch-enabled": true,
    "queue-stalled-enabled": true,
    "queue-stalled-minutes": 30,
    "ratio-limit": 2,
    "ratio-limit-enabled": false,
    "rename-partial-files": true,
    "rpc-authentication-required": true,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-host-whitelist": "",
    "rpc-host-whitelist-enabled": false,
    "rpc-password": "{62b0c4b24a3b5e85b27d28ec8af023d27b31b859n5YkIxku",
    "rpc-port": 9091,
    "rpc-url": "/transmission/",
    "rpc-username": "admin",
    "rpc-whitelist": "127.0.0.1,192.168.*.*",
    "rpc-whitelist-enabled": true,
    "scrape-paused-torrents-enabled": true,
    "script-torrent-done-enabled": false,
    "script-torrent-done-filename": "",
    "seed-queue-enabled": false,
    "seed-queue-size": 10,
    "speed-limit-down": 100,
    "speed-limit-down-enabled": false,
    "speed-limit-up": 100,
    "speed-limit-up-enabled": false,
    "start-added-torrents": true,
    "trash-original-torrent-files": false,
    "umask": 18,
    "upload-slots-per-torrent": 14,
    "utp-enabled": true,
    "watch-dir": "/var/lib/transmission-daemon/watch",
    "watch-dir-enabled": false
}
EOL

# Устанавливаем правильные разрешения
chown -R debian-transmission:debian-transmission /etc/transmission-daemon/settings.json

# Создаем скрипт для генерации нового пароля
cat > /usr/local/bin/transmission-password <<EOL
#!/bin/bash
if [ -z "\$1" ]; then
    echo "Использование: \$0 <новый_пароль>"
    exit 1
fi
systemctl stop transmission-daemon
sed -i "s/\"rpc-password\": \".*\"/\"rpc-password\": \"\$1\"/" /etc/transmission-daemon/settings.json
systemctl start transmission-daemon
echo "Пароль успешно изменен"
EOL

# Делаем скрипт смены пароля исполняемым
chmod +x /usr/local/bin/transmission-password

# Запускаем сервис
systemctl start transmission-daemon
systemctl enable transmission-daemon

# Выводим информацию о доступе
echo "Установка Transmission завершена!"
echo "Веб-интерфейс доступен по адресу: http://YOUR_SERVER_IP:9091"
echo "Логин: admin"
echo "Пароль по умолчанию: transmission"
echo ""
echo "Для смены пароля используйте команду: transmission-password <новый_пароль>"
echo ""
echo "Торренты будут загружаться в: /var/lib/transmission-daemon/downloads"