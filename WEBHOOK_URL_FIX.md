# Решение проблемы: n8n использует localhost для webhook

## Проблема

В узле Telegram Trigger показывается URL вида:
```
http://localhost:5678/webhook-test/f473e529-b7cf-4d83-938a-7597898e2e86/webhook
```

Это поле не редактируется, и n8n автоматически формирует его на основе базового URL.

## Решение

n8n нужно запустить с переменной окружения `WEBHOOK_URL`, которая указывает на публичный URL от ngrok.

### Способ 1: Использовать обновленный скрипт (рекомендуется)

Просто используйте обновленный `start-ngrok.bat` или `start-ngrok.ps1`:
- Они автоматически получат URL от ngrok
- Установят переменные окружения
- Запустят n8n с правильными настройками

**Важно:** Сначала запустите ngrok, затем используйте скрипт.

### Способ 2: Вручную через переменные окружения

1. Получите публичный URL от ngrok:
```powershell
.\get-ngrok-url.ps1
```

2. Запустите n8n с переменными окружения:
```powershell
$env:WEBHOOK_URL = "https://incredulous-mensal-siobhan.ngrok-free.dev"
$env:N8N_HOST = "incredulous-mensal-siobhan.ngrok-free.dev"
$env:N8N_PROTOCOL = "https"
npm start
```

Или в CMD:
```cmd
set WEBHOOK_URL=https://incredulous-mensal-siobhan.ngrok-free.dev
set N8N_HOST=incredulous-mensal-siobhan.ngrok-free.dev
set N8N_PROTOCOL=https
npm start
```

### Способ 3: Создать .env файл

Создайте файл `.env` в корне проекта:
```
WEBHOOK_URL=https://incredulous-mensal-siobhan.ngrok-free.dev
N8N_HOST=incredulous-mensal-siobhan.ngrok-free.dev
N8N_PROTOCOL=https
```

n8n автоматически загрузит переменные из `.env` файла.

**Важно:** URL в `.env` нужно обновлять при каждом перезапуске ngrok (если URL меняется).

## Проверка

После запуска n8n с правильными переменными:

1. Откройте workflow в n8n
2. Откройте узел Telegram Trigger
3. Проверьте webhook URL - он должен начинаться с `https://` и содержать ваш ngrok домен
4. Активируйте workflow
5. Проверьте, что ошибка исчезла

## Автоматизация

Для автоматического получения URL при каждом запуске используйте скрипт `start-n8n-with-webhook.bat` или `start-n8n-with-webhook.ps1` - они автоматически получат URL от ngrok и запустят n8n с правильными настройками.
