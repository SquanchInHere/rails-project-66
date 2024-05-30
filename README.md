### Hexlet tests and linter status:
[![Actions Status](https://github.com/SquanchInHere/rails-project-66/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/SquanchInHere/rails-project-66/actions)
[![Actions Status](https://github.com/SquanchInHere/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/SquanchInHere/rails-project-66/actions)

# Проект "Анализатор качества репозиториев"
Этот проект отображает результаты работы линтеров для публичных репозиториев пользователей. Анализируются репозитории, в которых GitHub определил основной язык как Ruby или JavaScript. Для просмотра результатов необходимо авторизоваться через GitHub и выбрать нужный репозиторий из списка. При добавлении репозитория устанавливается вебхук, который автоматически запускает проверку кода при каждом новом коммите на событие "push".

## Ссылки на проект
- [Рабочая версия проекта](https://repository-quality-analyzer-l7qg.onrender.com/)
- [Проект-образец](https://rails-github-quality-ru.hexlet.app)

## Технические условия и требования
- Ruby версии 3.2.2
- Rails версии 7.1.3
- Ngrok для разработки, чтобы работали вебхуки
- CI с использованием GitHub Actions для тестирования и линтинга с помощью RuboCop и Slim-Lint
- CD через Render (автодеплой)
- Использование шаблонизатора Slim
- Аутентификация через GitHub
- Bootstrap для стилизации
- Все текстовые сообщения реализованы через i18n
- PostgreSQL для production среды