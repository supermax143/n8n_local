# n8n Local

Локальная установка n8n для разработки и тестирования.

## Установка

```bash
npm install
```

## Запуск

### Способ 1: Через Cursor Tasks (самый удобный)

1. Нажмите `Ctrl+Shift+P` (или `F1`)
2. Введите `Tasks: Run Task`
3. Выберите нужную задачу:
   - **n8n: Start** - запуск n8n
   - **n8n: Start with Tunnel** - запуск с встроенным туннелем (нестабильно)
   - **n8n: Start with ngrok** - запуск с ngrok (рекомендуется для webhooks)
   - **n8n: Stop** - остановка n8n
   - **n8n: Open in Browser** - открыть в браузере

Или используйте меню: **Terminal → Run Task**

### Способ 2: Использование скриптов

**Windows (BAT):**
- Двойной клик по `start.bat` для запуска (обычный режим)
- Двойной клик по `start-tunnel.bat` для запуска с встроенным туннелем
- Двойной клик по `start-ngrok.bat` для запуска с ngrok (рекомендуется)
- Двойной клик по `stop.bat` для остановки
- Двойной клик по `open.bat` для открытия в браузере

**Windows (PowerShell):**
```powershell
.\start.ps1          # Запуск (обычный режим)
.\start-tunnel.ps1    # Запуск с встроенным туннелем
.\start-ngrok.ps1     # Запуск с ngrok (рекомендуется)
.\stop.ps1            # Остановка
.\open.ps1            # Открыть в браузере
```

### Способ 3: Через npm

```bash
npm start
```

После запуска n8n будет доступен по адресу: http://localhost:5678

## Запуск с туннелем (для webhooks, например Telegram)

**Важно:** Для работы Telegram Trigger и других webhook'ов нужен публичный URL.

### ⚠️ Проблема с встроенным туннелем n8n

Встроенный туннель (`--tunnel`) может быть нестабильным:
- URL меняется при каждом запуске
- Может закрыться через некоторое время
- Не подходит для постоянного использования

### ✅ Решение: Использование ngrok (рекомендуется)

**Способ 1: Через Cursor Tasks**
- `Ctrl+Shift+P` → `Tasks: Run Task` → **n8n: Start with ngrok**

**Способ 2: Через скрипт**
- Двойной клик по `start-ngrok.bat`
- Или выполните `.\start-ngrok.ps1` в PowerShell

**Установка ngrok:**
1. Скачайте: https://ngrok.com/download
2. Получите authtoken: https://dashboard.ngrok.com/get-started/your-authtoken
3. Выполните: `ngrok config add-authtoken YOUR_TOKEN`

**Подробная инструкция:** См. файл `WEBHOOK_SETUP.md`

### Альтернатива: Встроенный туннель n8n

**Способ 1: Через Cursor Tasks**
- `Ctrl+Shift+P` → `Tasks: Run Task` → **n8n: Start with Tunnel**

**Способ 2: Через скрипт**
- Двойной клик по `start-tunnel.bat`
- Или выполните `.\start-tunnel.ps1` в PowerShell

**Способ 3: Через npm**
```bash
npm run start:tunnel
```

После запуска в консоли будет показан публичный URL для webhooks. Используйте этот URL в настройках Telegram Trigger.

## Остановка

- Используйте `stop.bat` или `stop.ps1`
- Или нажмите `Ctrl+C` в терминале, если запущено через `npm start`
