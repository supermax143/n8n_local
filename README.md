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
   - **n8n: Start with Tunnel** - запуск с туннелем (для webhooks)
   - **n8n: Stop** - остановка n8n
   - **n8n: Open in Browser** - открыть в браузере

Или используйте меню: **Terminal → Run Task**

### Способ 2: Использование скриптов

**Windows (BAT):**
- Двойной клик по `start.bat` для запуска (обычный режим)
- Двойной клик по `start-tunnel.bat` для запуска с туннелем (для webhooks)
- Двойной клик по `stop.bat` для остановки
- Двойной клик по `open.bat` для открытия в браузере

**Windows (PowerShell):**
```powershell
.\start.ps1         # Запуск (обычный режим)
.\start-tunnel.ps1   # Запуск с туннелем (для webhooks)
.\stop.ps1           # Остановка
.\open.ps1           # Открыть в браузере
```

### Способ 3: Через npm

```bash
npm start
```

После запуска n8n будет доступен по адресу: http://localhost:5678

## Запуск с туннелем (для webhooks, например Telegram)

**Важно:** Для работы Telegram Trigger и других webhook'ов нужен публичный URL.

**Способ 1: Через Cursor Tasks (рекомендуется)**
- `Ctrl+Shift+P` → `Tasks: Run Task` → **n8n: Start with Tunnel**

**Способ 2: Через скрипт**
- Двойной клик по `start-tunnel.bat`
- Или выполните `.\start-tunnel.ps1` в PowerShell

**Способ 3: Через npm**
```bash
npm run start:tunnel
```

После запуска в консоли будет показан публичный URL для webhooks (например: `https://xxxxx.app.n8n.cloud`). Используйте этот URL в настройках Telegram Trigger.

## Остановка

- Используйте `stop.bat` или `stop.ps1`
- Или нажмите `Ctrl+C` в терминале, если запущено через `npm start`
