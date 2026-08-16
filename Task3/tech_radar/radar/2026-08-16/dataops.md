---
title: "DataOps: CI/CD, IaC и quality gates"
ring: adopt
quadrant: methods-and-patterns
tags: [new, BS1, BS2, BS4, BS5, BS6]
---

Код pipeline, контракты и инфраструктура хранятся в Git, проходят тесты и разворачиваются воспроизводимо. Публикация блокируется при ошибке схемы, качества или политики безопасности.

**Бизнес-сценарии:** BS1, BS2, BS4, BS5, BS6.

**Почему Adopt:** ручные настройки плохо масштабируются на несколько доменов и создают непроверяемые отличия между окружениями.

Минимальный pipeline включает lint, contract test, data quality test, security check и контролируемое развёртывание.
