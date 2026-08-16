---
title: "Apache Airflow"
ring: trial
quadrant: tools
tags: [new, BS1, BS2, BS3, orchestration]
---

Оркестратор доменных DAG: расписания, зависимости, повторные запуски, SLA и алерты. Тяжёлые преобразования выполняются отдельными SQL/Python/Spark jobs.

**Бизнес-сценарии:** BS1, BS2, BS3.

**Почему Trial:** нужно подтвердить изоляцию доменов, масштабирование scheduler/worker, обновление без простоя и восстановление metadata DB.

PostgreSQL хранит только служебное состояние Airflow и не становится новым корпоративным DWH.
