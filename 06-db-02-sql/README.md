# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

>### Ответ:

Скачаем образ `postgres:12`:

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-02-sql/docker$ sudo docker pull postgres:12
[sudo] пароль для user:         
12: Pulling from library/postgres
42c077c10790: Already exists 
3c2843bc3122: Pull complete 
12e1d6a2dd60: Pull complete 
9ae1101c4068: Pull complete 
fb05d2fd4701: Pull complete 
9785a964a677: Pull complete 
16fc798b0e72: Pull complete 
f1a0bfa2327a: Pull complete 
f1e20d84ae82: Pull complete 
8b37d1e969e5: Pull complete 
7261decb0bcf: Pull complete 
76fd4336668c: Pull complete 
50b8a43577a4: Pull complete 
Digest: sha256:fe84844ef27aaaa52f6ec68d6b3c225d19eb4f54200a93466aa67798c99aa462
Status: Downloaded newer image for postgres:12
```

Настроим [YAML-манифест](docker/docker-compose.yaml) и запустим `docker-compose`:

```yaml
# version: "3.8"

services:
  postgres:
    image: postgres:12
    container_name: netology_postgres
    volumes:
      - netology_pgdata:/var/lib/postgresql/data
      - netology_pgbackup:/dump
      - ./sql/init.sql:/docker-entrypoint-initdb.d/init.sql
      - ./sql/insert.sql:/docker-entrypoint-initdb.d/insert.sql
      - ./sql/update.sql:/docker-entrypoint-initdb.d/update.sql
    restart: always
    environment:
      POSTGRES_DB: postgres
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "127.0.0.1:5432:5432"

  postgres_copy:
    image: postgres:12
    container_name: netology_postgres_copy
    volumes:
      - netology_pgdata_copy:/var/lib/postgresql/data
      - netology_pgbackup:/dump
    restart: always
    environment:
      POSTGRES_DB: postgres
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
    ports:
      - "127.0.0.2:5432:5432"

volumes:
  netology_pgdata: {}
  netology_pgbackup: {}
  netology_pgdata_copy: {}
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

>### Ответ:

Для создания таблиц, пользователей и присвоения прав воспользуемся [скриптом](docker/sql/init.sql). Перезапустим `docker-compose` и зайдём в `psql`:

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-02-sql/docker$ sudo docker exec -it netology_postgres /bin/bash -c "psql -U postgres"

```

1. Итоговый список БД:

```sql
postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges   
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 | 
(4 rows)

```

2. Описание таблиц (describe)

```sql
test_db=# \d clients
                                          Table "public.clients"
    Column    |          Type          | Collation | Nullable |                  Default
--------------+------------------------+-----------+----------+--------------------------------------------
 client_id    | integer                |           | not null | nextval('clients_client_id_seq'::regclass)
 last_name    | character varying(256) |           | not null |
 country_name | character varying(256) |           | not null |
 order_id     | integer                |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (client_id)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)
                         
test_db=# \d orders
                                        Table "public.orders"
  Column  |          Type          | Collation | Nullable |                 Default
----------+------------------------+-----------+----------+------------------------------------------
 order_id | integer                |           | not null | nextval('orders_order_id_seq'::regclass)
 name     | character varying(256) |           | not null |
 price    | integer                |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (order_id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(order_id)
```
3. SQL-запрос для выдачи списка пользователей с правами над таблицами test_db

```sql
SELECT table_name, grantee, privilege_type 
FROM information_schema.role_table_grants 
WHERE table_name IN ('clients', 'orders')
  AND grantee <> 'postgres';
```

4. Список пользователей с правами над таблицами test_db

```sql
 table_name |     grantee      | privilege_type
------------+------------------+----------------
 orders     | test-simple-user | INSERT
 orders     | test-simple-user | SELECT
 orders     | test-simple-user | UPDATE
 orders     | test-simple-user | DELETE
 orders     | test-admin-user  | INSERT
 orders     | test-admin-user  | SELECT
 orders     | test-admin-user  | UPDATE
 orders     | test-admin-user  | DELETE
 orders     | test-admin-user  | TRUNCATE
 orders     | test-admin-user  | REFERENCES
 orders     | test-admin-user  | TRIGGER
 clients    | test-simple-user | INSERT
 clients    | test-simple-user | SELECT
 clients    | test-simple-user | UPDATE
 clients    | test-simple-user | DELETE
 clients    | test-admin-user  | INSERT
 clients    | test-admin-user  | SELECT
 clients    | test-admin-user  | UPDATE
 clients    | test-admin-user  | DELETE
 clients    | test-admin-user  | TRUNCATE
 clients    | test-admin-user  | REFERENCES
 clients    | test-admin-user  | TRIGGER
(22 rows)
```
## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
    - запросы 
    - результаты их выполнения.

>### Ответ:


Добавим SQL-скрипт [insert.sql](docker/sql/init.sql), скопируем его в контейнер и запустим команду:

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-02-sql/docker$ sudo  docker exec -it netology_postgres /bin/bash -c "psql -U postgres -d test_db -f '/docker-entrypoint-initdb.d/insert.sql'"
You are now connected to database "test_db" as user "postgres".
INSERT 0 5
INSERT 0 5
```

Выполним запросы:

```sql
test_db=# SELECT count(*) FROM Orders;
 count
-------
     5
(1 row)

test_db=# SELECT count(*) FROM Clients;
 count
-------
     5
(1 row)
```


## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

>### Ответ:

Добавим SQL-скрипт [update.sql](docker/sql/update.sql), скопируем его в контейнер и запустим команду:

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-02-sql/docker$ sudo  docker exec -it netology_postgres /bin/bash -c "psql -U postgres -d test_db -f '/docker-entrypoint-initdb.d/update.sql'"
You are now connected to database "test_db" as user "postgres".
UPDATE 0
UPDATE 0
UPDATE 0
```

Запрос:

```sql
SELECT c.last_name, o.name
FROM Clients c
INNER JOIN Orders o
        ON o.order_id = c.order_id;
```

Результат:

```sql
      last_name       |  name
----------------------+---------
 Иванов Иван Иванович | Книга
 Петров Петр Петрович | Монитор
 Иоганн Себастьян Бах | Гитара
(3 rows)
```


## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

>### Ответ:

```sql
EXPLAIN 
SELECT c.last_name, o.name
FROM Clients c
INNER JOIN Orders o
        ON o.order_id = c.order_id;
```

Результат

```sql
                              QUERY PLAN
----------------------------------------------------------------------
 Hash Join  (cost=1.11..2.19 rows=5 width=1032)
   Hash Cond: (c.order_id = o.order_id)
   ->  Seq Scan on clients c  (cost=0.00..1.05 rows=5 width=520)
   ->  Hash  (cost=1.05..1.05 rows=5 width=520)
         ->  Seq Scan on orders o  (cost=0.00..1.05 rows=5 width=520)
(5 rows)
```

Видим план выполнения запроса. Ключевые операторы: 
- `Seq Scan` — последовательный перебор строк таблицы;
- `Hash Cond` — условие для соединения с помощью хеш-таблицы;
- `Hash Join` — соединение с помощью хеш-таблицы.

План запроса измеряется в так называемых (условных) единицах стоимости (`cost`). Чем выше значения стоимости, тем дольше будет выполняться запрос. Атрибут `rows` указывает на количество обрабатываемых строк. Запрос читается снизу вверх.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

>### Ответ:

Создадим dump БД `test_db` в контейнере `netology_postgres`: 

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-02-sql/docker$ sudo docker exec -it netology_postgres /bin/bash

root@dc5753595747:/# pg_dump -U postgres -W test_db > /dump/test_db.sql
```

Затем зайдём в консоль контейнера `netology_postgres_copy` и восстановим БД в контейнере `netology_postgres_copy`:

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-02-sql/docker$ sudo docker exec -it netology_postgres_copy /bin/bash
root@666e602b834c:/# psql -U postgres -c 'create database test_db;'
CREATE DATABASE
root@666e602b834c:/# psql -U postgres test_db < /dump/test_db.sql

```

Проверим данные в `test_db.clients`:

```sql
psql -U postgres test_db -c "select * from clients;"
 client_id |      last_name       | country_name | order_id
-----------+----------------------+--------------+----------
         4 | Ронни Джеймс Дио     | Russia       |
         5 | Ritchie Blackmore    | Russia       |
         1 | Иванов Иван Иванович | USA          |        3
         2 | Петров Петр Петрович | Canada       |        4
         3 | Иоганн Себастьян Бах | Japan        |        5
```

---
