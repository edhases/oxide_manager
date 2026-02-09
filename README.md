Oxide Manager
=============

Oxide Manager — кросплатформенний менеджер пакетів для екосистеми "Oxide". Мета: стати альтернативою Windows Store / Google Play для додатків Oxide (наприклад, Oxide Player, Oxide Film): знаходження, завантаження, встановлення та оновлення релізів, що публікуються на GitHub Releases.

Ця текa містить повну технічну документацію для розробника: від дорожньої карти до інструкцій CI/CD, форматів інсталяторів та тестування.

Ключові рішення (поточні):

- Платформи: Windows, Linux (desktop), Android
- Інсталяція: per-user та system-wide (опція під час інсталяції)
- Джерело релізів: GitHub Releases (інтеграція з Oxide Releaser)
- Оновлення: користувацьке підтвердження (не silent)
- Підпис артефактів: відкладено (потрібні сертифікати для production)

Файли документації (детальні шаблони в репозиторії):

- `ROADMAP.md`
- `TECHNICAL_SPEC.md`
- `ARCHITECTURE.md`
- `INSTALLERS.md`
- `UPDATES.md`
- `CI_CD.md`
- `DEV_SETUP.md`
- `SECURITY.md`
- `TESTING.md`
- `UI_SPEC.md`
- `CONTRIBUTING.md`
- `ONBOARDING.md`
- `CHANGELOG.md`
- `RELEASES.md`
- `PRIVACY.md`
- `MVP_CHECKLIST.md`

Що я можу зробити далі:

1. Сгенерувати Flutter scaffold (ініціалізація проекту з `pubspec.yaml`, `lib/main.dart`) та minimal UI.
2. Додати рекомендований GitHub Actions workflow для збірки desktop та Android артефактів.
3. Підготувати mock-сервер для симуляції GitHub Releases під час розробки.

Якщо підтверджуєте, я зараз додам інші детальні Markdown-файли у репозиторій.
