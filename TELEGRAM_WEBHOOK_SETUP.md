# Настройка Telegram Webhook в n8n

## Проблема: "Bad Request: bad webhook: An HTTPS URL must be provided for webhook"

Эта ошибка возникает, когда в Telegram Trigger не указан правильный HTTPS URL для webhook.

## Решение

### Шаг 1: Получите публичный URL от ngrok

**Способ 1: Через скрипт (рекомендуется)**
- Двойной клик по `get-ngrok-url.bat`
- Или выполните `.\get-ngrok-url.ps1` в PowerShell
- URL будет скопирован в буфер обмена

**Способ 2: Вручную**
1. Откройте браузер: http://localhost:4040
2. На странице ngrok найдите строку "Forwarding"
3. Скопируйте HTTPS URL (например: `https://xxxxx.ngrok-free.app`)

**Способ 3: Через API**
```powershell
$response = Invoke-RestMethod -Uri "http://localhost:4040/api/tunnels"
$tunnel = $response.tunnels | Where-Object { $_.proto -eq "https" } | Select-Object -First 1
$tunnel.public_url
```

### Шаг 2: Настройте Telegram Trigger в n8n

1. Откройте ваш workflow в n8n
2. Найдите узел **Telegram Trigger**
3. Откройте настройки узла
4. В поле **Webhook URL** или **Webhook Path**:
   - Если есть поле "Webhook URL" - вставьте полный URL: `https://xxxxx.ngrok-free.app/webhook/xxxxx`
   - Если есть только "Webhook Path" - n8n автоматически добавит базовый URL
5. Убедитесь, что указан правильный **Bot Token**
6. Сохраните настройки

### Шаг 3: Активируйте workflow

1. Включите workflow (переключатель в правом верхнем углу)
2. n8n автоматически зарегистрирует webhook в Telegram
3. Проверьте статус - должно быть "Active"

## Текущий публичный URL

Если ngrok запущен, ваш текущий URL:
```
https://incredulous-mensal-siobhan.ngrok-free.dev
```

**Важно:** Этот URL может измениться при перезапуске ngrok. Используйте скрипт `get-ngrok-url.bat` для получения актуального URL.

## Проверка настройки

После настройки:
1. Убедитесь, что workflow активен
2. Отправьте сообщение боту в Telegram
3. Проверьте, что workflow срабатывает

## Частые ошибки

❌ **"bad webhook: An HTTPS URL must be provided"**
- Убедитесь, что ngrok запущен
- Проверьте, что используется HTTPS URL (не HTTP)
- Убедитесь, что URL скопирован полностью

❌ **"Webhook is not available"**
- Проверьте, что n8n запущен
- Проверьте, что ngrok туннель активен
- Убедитесь, что workflow включен

❌ **"Invalid token"**
- Проверьте Bot Token в настройках Telegram Trigger
- Убедитесь, что токен скопирован полностью без пробелов

## Автоматическое получение URL

Для удобства создан скрипт `get-ngrok-url.bat`, который:
- Получает текущий публичный URL от ngrok
- Копирует его в буфер обмена
- Показывает URL в консоли

Используйте его каждый раз, когда нужно получить актуальный URL для webhook.
