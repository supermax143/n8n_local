# Настройка стабильного webhook для n8n

## Проблема с встроенным туннелем n8n

Встроенный туннель n8n (`--tunnel`) имеет ограничения:
- ❌ URL меняется при каждом запуске
- ❌ Может закрыться через некоторое время
- ❌ Нестабилен для production

## Решение: Использование ngrok (рекомендуется)

ngrok предоставляет стабильный туннель с постоянным URL.

### Установка ngrok

1. Скачайте ngrok: https://ngrok.com/download
2. Распакуйте `ngrok.exe` в папку проекта или добавьте в PATH
3. Зарегистрируйтесь на https://ngrok.com (бесплатно) и получите authtoken

### Настройка ngrok

1. Авторизуйтесь:
```bash
ngrok config add-authtoken YOUR_AUTH_TOKEN
```

2. Создайте конфигурационный файл `ngrok.yml`:
```yaml
version: "2"
authtoken: YOUR_AUTH_TOKEN
tunnels:
  n8n:
    addr: 5678
    proto: http
    subdomain: your-custom-name  # Опционально, для постоянного URL (требует платный план)
```

### Запуск с ngrok

**Вариант 1: Через скрипт (автоматически)**
- Используйте `start-ngrok.bat` или `start-ngrok.ps1`

**Вариант 2: Вручную**
1. Запустите n8n: `npm start` или `start.bat`
2. В отдельном терминале запустите ngrok:
```bash
ngrok http 5678
```

3. Скопируйте URL из ngrok (например: `https://xxxxx.ngrok-free.app`)
4. Используйте этот URL в настройках Telegram webhook

## Альтернативные решения

### 1. Cloudflare Tunnel (бесплатно, стабильно)

```bash
# Установка
npm install -g cloudflared

# Запуск
cloudflared tunnel --url http://localhost:5678
```

### 2. Локальный сервер с постоянным доменом

Если у вас есть VPS или сервер, можно настроить reverse proxy.

### 3. Использование переменных окружения

Можно настроить n8n для использования внешнего URL через переменные окружения.

## Рекомендации

1. **Для разработки:** Используйте ngrok (бесплатный план)
2. **Для production:** Используйте VPS с постоянным доменом или Cloudflare Tunnel
3. **Для тестирования:** Встроенный туннель n8n подойдет, но помните про ограничения

## Проверка webhook

После настройки проверьте доступность webhook:
```bash
curl https://your-webhook-url.com/webhook/test
```

Или используйте онлайн-сервисы для проверки доступности URL.
