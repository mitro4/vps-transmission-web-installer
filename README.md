# Установщик Transmission для VPS

Этот скрипт автоматически устанавливает и настраивает торрент-клиент Transmission с веб-интерфейсом на ваш VPS сервер с операционной системой Debian/Ubuntu.

## Возможности

- Автоматическая установка Transmission
- Настройка веб-интерфейса с базовой защитой
- Создание директории для загрузок
- Настройка автозапуска сервиса
- Удобный скрипт для смены пароля

## Требования

- VPS сервер с Debian или Ubuntu
- Права root
- Доступ по SSH

## Установка

1. Загрузите скрипт на ваш сервер:
```bash
wget https://raw.githubusercontent.com/mitro4/vps-transmission-web-installer/refs/heads/main/install.sh
```

2. Сделайте скрипт исполняемым:
```bash
chmod +x install.sh
```

3. Запустите скрипт:
```bash
sudo ./install.sh
```

## После установки

После успешной установки:

1. Веб-интерфейс будет доступен по адресу: `http://YOUR_SERVER_IP:9091`
2. Данные для входа:
   - Логин: `admin`
   - Пароль: `transmission`

## Смена пароля

Для смены пароля используйте команду:
```bash
transmission-password <новый_пароль>
```

## Директории

- Загрузки: `/var/lib/transmission-daemon/downloads`
- Конфигурация: `/etc/transmission-daemon/settings.json`

## Безопасность

- Веб-интерфейс защищен паролем
- Доступ ограничен по IP (127.0.0.1 и 192.168.*.*)
- Используется базовая аутентификация

## Управление сервисом

```bash
# Остановить сервис
sudo systemctl stop transmission-daemon

# Запустить сервис
sudo systemctl start transmission-daemon

# Перезапустить сервис
sudo systemctl restart transmission-daemon

# Проверить статус
sudo systemctl status transmission-daemon
```

## Решение проблем

1. Если веб-интерфейс недоступен:
   - Проверьте статус сервиса
   - Убедитесь, что порт 9091 открыт в файрволле
   - Проверьте логи: `sudo journalctl -u transmission-daemon`

2. Если нет прав на загрузку:
   - Проверьте права на директорию загрузок
   - Перезапустите сервис

## Поддержка

При возникновении проблем:
1. Проверьте логи системы
2. Убедитесь, что все требования соблюдены
3. Создайте issue в репозитории с описанием проблемы

Также проверьте значения:
```json
{  "rpc-enabled": true, 
   "rpc-password": "{38608669907758f46616b5f309e619068b56ae20nVSUUPnI", 
   "rpc-port": 9091, 
   "rpc-url": "/transmission/", 
   "rpc-username": "", 
   "rpc-whitelist": "127.0.0.1,192.168.0.*", "rpc-whitelist-enabled": true 
}
```

При возникновении ошибки 
```js
transmission-daemon[9607]: [yyyy-mm-dd hh:mm:ss.sss] UDP Failed to set receive buffer: requested 4194304, got 425984 (tr-udp.c:84)
```

Добавьте в  ```/etc/sysctl.conf```
```
net.core.rmem_max = 16777216
net.core.wmem_max = 4194304
```
и выполните 
```sysctl -pd```
