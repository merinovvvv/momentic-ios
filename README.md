# momentic-ios
iOS Mobile part of the "Momentic" mobile application - social network, a mixture of TikTok and BeReal.

## Краткое описание
**Momentic** — социальное мобильное приложение для коротких видео под рандомный музыкальный трек (momentic). Пользователи записывают 15-секундные видео, публикуют их по таймеру, получают очки за активность, собирают бейджи и соревнуются в недельных топах. Приложение включает ленты (друзей и глобальную), камеру, реакции (эмодзи + комментарии), рейтинги и систему штрафов/бонусов.

## Стек технологий
- Язык: **Swift 5+**
- UI: **UIKit**
- Архитектура: **MVVM + Coordinator**
- Асинхронность: **Combine / Swift Concurrency (async/await) / GCD**
- Сетевой слой: **URLSession / Codable**
- Видео: **AVFoundation**
- Хранение: **Core Data / Keychain (токены)**
- Тесты: **XCTest** (unit + UI)

## Ссылки на прототипы
- Figma (прототипы UI/UX): [MOMENTIC](https://www.figma.com/design/EOl0MH5xv2DqoqALgzI1ew/Momentic?node-id=0-1&t=w9eHQ8b6ScK1PpHu-1)

## Ссылка на API сервера
- Базовый URL API: https://api.momentic.app/v1  
- Документация API (OpenAPI/Swagger): https://api.momentic.app/docs

**Ключевые эндпоинты (пример):**
- `POST https://api.momentic.app/v1/auth/login` — авторизация (студ. почта)
- `GET  https://api.momentic.app/v1/feed/global` — глобальная лента
- `GET  https://api.momentic.app/v1/feed/friends` — лента друзей
- `POST https://api.momentic.app/v1/videos` — загрузка видео
- `POST https://api.momentic.app/v1/reactions` — реакция/комментарий
- `GET  https://api.momentic.app/v1/ranking` — рейтинг
- `GET  https://api.momentic.app/v1/users/{id}` — профиль пользователя
