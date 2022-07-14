# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

>### Ответ:

>Настроим [Docker манифест](docker/Dockerfile)
```dockerfile
FROM centos:7

RUN yum -y update &&  \
    yum clean all &&  \
    yum -y install wget && \
    yum -y install perl-Digest-SHA && \
    yum -y install java-11-openjdk

RUN curl -x "socks5://127.0.0.1:9050" -O  https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz && \
    curl -x "socks5://127.0.0.1:9050" -O  https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 &&  \
    tar -xzf elasticsearch-8.2.0-linux-x86_64.tar.gz

RUN groupadd elasticsearch  && \
    useradd elasticsearch -g elasticsearch -p elasticsearch

RUN chown -R elasticsearch:elasticsearch /elasticsearch-8.2.0/ && \
    mkdir /var/lib/logs &&  \
    mkdir /var/lib/data && \
    chown elasticsearch:elasticsearch /var/lib/logs && \
    chown elasticsearch:elasticsearch /var/lib/data && \
    chown -R elasticsearch:elasticsearch /elasticsearch-8.2.0

COPY  elasticsearch.yml /elasticsearch-8.2.0/config/

USER elasticsearch
ENV ES_PATH_CONF=/elasticsearch-8.2.0/config/
CMD ["/elasticsearch-8.2.0/bin/elasticsearch"]
```
> используя [конфигурацию](docker/elasticsearch.yml) Elasticsearch.
```yml
discovery.type: single-node
node.name: netology_test
path.data: /var/lib/data
path.logs: /var/lib/logs
network.host: 0.0.0.0
xpack.security.enabled: false
xpack.security.transport.ssl.enabled: false
```
> Запустим `docker build`:

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/06-db-05-elasticsearch/docker$ sudo docker build --network=host .
[sudo] пароль для user:
Sending build context to Docker daemon   5.12kB
Step 1/9 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/9 : RUN yum -y update &&      yum clean all &&      yum -y install wget &&     yum -y install perl-Digest-SHA &&     yum -y install java-11-openjdk
 ---> Using cache
 ---> 90e2dac4494f
Step 3/9 : RUN curl -x "socks5://127.0.0.1:9050" -O  https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz &&     curl -x "socks5://127.0.0.1:9050" -O  https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 &&     shasum -a 512 -c elasticsearch-8.2.0-linux-x86_64.tar.gz.sha512 &&      tar -xzf elasticsearch-8.2.0-linux-x86_64.tar.gz
 ---> Using cache
 ---> d39006f1a650
Step 4/9 : RUN groupadd elasticsearch  &&     useradd elasticsearch -g elasticsearch -p elasticsearch
 ---> Using cache
 ---> 1e0694392b2d
Step 5/9 : COPY  elasticconfig.yml /elasticsearch-8.2.0/config/
 ---> Using cache
 ---> 998ce10628ff
Step 6/9 : RUN chown -R elasticsearch:elasticsearch /elasticsearch-8.2.0/ &&     mkdir /var/lib/logs &&      mkdir /var/lib/data &&     chown elasticsearch:elasticsearch /var/lib/logs &&     chown elasticsearch:elasticsearch /var/lib/data &&     chown -R elasticsearch:elasticsearch /elasticsearch-8.2.0
 ---> Using cache
 ---> 5b172a5153db
Step 7/9 : USER elasticsearch
 ---> Using cache
 ---> 4d7f470a4385
Step 8/9 : ENV ES_PATH_CONF=/elasticsearch-8.2.0/config/
 ---> Using cache
 ---> c06af4424038
Step 9/9 : CMD ["/elasticsearch-8.2.0/bin/elasticsearch"]
 ---> Using cache
 ---> 5fc659d77b9c
Successfully built 5fc659d77b9c
user@user-Aspire-5750G:~$ sudo docker image ls
REPOSITORY         TAG                  IMAGE ID       CREATED         SIZE
jjvod/elastic      home                 5fc659d77b9c   12 hours ago    3.52GB
```

>На хостовой машине выполним команду `curl http://localhost:9200` и получим JSON:

```json
user@user-Aspire-5750G:~$ curl http://localhost:9200
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "epPfR8K9SYq85xTNaMmU8w",
  "version" : {
    "number" : "8.2.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "b174af62e8dd9f4ac4d25875e9381ffe2b9282c5",
    "build_date" : "2022-04-20T10:35:10.180408517Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

>Образ в dockerhub доступен по [ссылке](https://hub.docker.com/layers/elastic/jjvod/elastic/home/images/sha256-23d6c8a3079a66dd0e01cfe628d0d02bc8864ec8e85cbd0882026fec50c0ab56?context=repo).


## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

>### Ответ:

>С помощью Elasticsearch API добавим 3 индекса:

```bash
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}, {"acknowledged" : true, "shards_acknowledged" : true, "index" : "ind-1"}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 2, "number_of_replicas": 1}}}, {"acknowledged" : true, "shards_acknowledged" : true, "index" : "ind-2"}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{"settings": {"index": {"number_of_shards": 4, "number_of_replicas": 2}}}, {"acknowledged" : true, "shards_acknowledged" : true, "index" : "ind-3"}'
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}
```

>Выведем список индексов с помощью команды API `_cat/indices`:

```bash
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_cat/indices/ind-*
green  open ind-1 wlkCAMAxRiacw9oJAALOWA 1 0 0 0 225b 225b
yellow open ind-3 F0N94QuIR-mGHXyWmTDPzQ 4 2 0 0 900b 900b
yellow open ind-2 PFnKQ53_SzysEqc2BvL5Jw 2 1 0 0 450b 450b
```

>Состояние кластера с помощью команды API `_cluster/health`:

```bash
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_cluster/health?pretty
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 8,
  "active_shards" : 8,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 44.44444444444444
}
```

>Удалим все индексы с помощью `DELETE`-запроса: 

```bash
user@user-Aspire-5750G:~$ curl -X DELETE localhost:9200/ind-1
{"acknowledged":true}
user@user-Aspire-5750G:~$ curl -X DELETE localhost:9200/ind-2
{"acknowledged":true}
user@user-Aspire-5750G:~$ curl -X DELETE localhost:9200/ind-3
{"acknowledged":true}
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_cat/indices/ind-*
user@user-Aspire-5750G:~$
```

>Кластер находится в состоянии `yellow`, так как нода одна и есть риск потери данных.


## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

>### Ответ:

>Создадим директорию `snapshots`:

```shell
user@user-Aspire-5750G:~$ sudo docker exec -it netology mkdir /elasticsearch-8.2.0/snapshots
user@user-Aspire-5750G:~$ sudo docker exec -it netology bash -c 'echo "path.repo: /elasticsearch-8.2.0/snapshots" >> /elasticsearch-8.2.0/config/elasticsearch.yml'
user@user-Aspire-5750G:~$ sudo docker restart netology
netology
```

>Зарегистрируем директорию как `snapshot repository`:

```shell
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/_snapshot/netology_backup -H 'Content-Type: application/json' -d '{"type": "fs", "settings": {"location": "/elasticsearch-8.2.0/snapshots"}}{"acknowledged" : true}'
{"acknowledged":true}
```

>Выведем результат вызова API для репозитория:

```shell
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/elasticsearch-8.2.0/snapshots"
    }
  }
}
```

>Создадим индекс `test` с 0 реплик и 1 шардом:

```shell
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}{"acknowledged" : true, "shards_acknowledged" : true, "index" : "test"}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_cat/indices?v=true
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  i2Jew39FR26mr1fqUB-3aA   1   0          0            0       225b           225b
```

>Создадим snapshot состояния кластера:

```bash
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/_snapshot/netology_backup/snapshot1
{"accepted":true}
user@user-Aspire-5750G:~$ sudo docker exec -it netology ls -la /elasticsearch-8.2.0/snapshots
total 48
drwxr-xr-x 3 elasticsearch elasticsearch  4096 Jul 14 06:16 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Jul 14 06:11 ..
-rw-r--r-- 1 elasticsearch elasticsearch   842 Jul 14 06:16 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Jul 14 06:16 index.latest
drwxr-xr-x 4 elasticsearch elasticsearch  4096 Jul 14 06:16 indices
-rw-r--r-- 1 elasticsearch elasticsearch 18334 Jul 14 06:16 meta-LR6a8LQ8ScW93ftzsoPcpg.dat
-rw-r--r-- 1 elasticsearch elasticsearch   353 Jul 14 06:16 snap-LR6a8LQ8ScW93ftzsoPcpg.dat
```

>Удалим индекс `test`, создадим индекс `test-2`:

```shell
user@user-Aspire-5750G:~$ curl -X DELETE localhost:9200/test
{"acknowledged":true}
user@user-Aspire-5750G:~$ curl -X PUT localhost:9200/test-2 -H 'Content-Type: application/json' -d '{"settings": {"index": {"number_of_shards": 1, "number_of_replicas": 0}}}{"acknowledged" : true, "shards_acknowledged" : true, "index" : "test-2"}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_cat/indices?v=true
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 OpahXVOHQvSZHBfYVjVUpw   1   0          0            0       225b           225b
```

>Восстановим состояние кластера из `snapshot` и выведем список индексов:

```shell
user@user-Aspire-5750G:~$ curl -X POST localhost:9200/_snapshot/netology_backup/snapshot1/_restore?pretty -H 'Content-Type: application/json' -d '{"indices": "*", "include_global_state": true}{"accepted" : true}'
{
  "accepted" : true
}
user@user-Aspire-5750G:~$ curl -X GET localhost:9200/_cat/indices?v=true
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 OpahXVOHQvSZHBfYVjVUpw   1   0          0            0       225b           225b
green  open   test   RGvkqHNUREOgPHiUtbGbkg   1   0          0            0       225b           225b
```

>Видим два индекса: раннее созданный `test-2` и восстановленный `test`.  

