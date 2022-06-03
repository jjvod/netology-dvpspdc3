
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"


## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

>## Ответ
>- Зарегистрировались и создали свой репозиторий [`jjvod/nginx-fork`](https://hub.docker.com/repository/docker/jjvod/nginx-fork)
>- Загрузили образ `nginx:stable`
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker pull nginx:stable
stable: Pulling from library/nginx
42c077c10790: Already exists 
dedc95281b4f: Pull complete 
919c6c8c0471: Pull complete 
7075bb870b9e: Pull complete 
e93f5d620ba9: Pull complete 
90a8adeea75b: Pull complete 
Digest: sha256:f00db45b878cd3c18671bcb062fce4bfb365b82fd97d89dfaff2ab7b9fb66b80
Status: Downloaded newer image for nginx:stable
docker.io/library/nginx:stable
```
>- Приготовили [`Dockerfile`](dockerfile/Dockerfile)
```dockerfile
FROM nginx:stable
COPY ./index.html /usr/share/nginx/html/index.html
```
>- Собрали свой образ
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker/dockerfile$ sudo docker build -t nginx-fork:tag1 ./
Sending build context to Docker daemon  3.072kB
Step 1/2 : FROM nginx:stable
 ---> f9c88cc1c21a
Step 2/2 : COPY ./index.html /usr/share/nginx/html/index.html
 ---> fb42c266c6ba
Successfully built fb42c266c6ba
Successfully tagged nginx-fork:tag1
```
>- Запускаем и проверяем работу
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker run -it --rm -d -p 8080:80 --name netology nginx-fork:tag1
2f7b5e1e7fe052b9fa73b045bc41b9f30988547a5a00c3d0319f0f1f3d1730bb

user@user-Aspire-5750G:~/netology-dvpspdc3$ curl http://localhost:8080
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I'm DevOps Engineer!</h1>
</body>
</html>
user@user-Aspire-5750G:~/netology-dvpspdc3$
```

>- Теперь опубликуем образ на `hub.docker.com`
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker tag nginx-fork:tag1 jjvod/nginx-fork:tag1

user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker push jjvod/nginx-fork:tag1
The push refers to repository [docker.io/jjvod/nginx-fork]
b46a764702f8: Pushed 
b470eef4f5d8: Pushed 
043c34f72e3d: Pushed 
daef241ddc79: Pushed 
53ae93fa7fcc: Pushed 
e83a53e226df: Pushed 
ad6562704f37: Pushed 
tag1: digest: sha256:ed244a4f6e0d668b89dc13bbf69cc7bd9e73688e4e487a739b4fcd0de0e6a410 size: 1777
user@user-Aspire-5750G:~/netology-dvpspdc3$ 
```

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
- Nodejs веб-приложение;
- Мобильное приложение c версиями для Android и iOS;
- Шина данных на базе Apache Kafka;
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- Мониторинг-стек на базе Prometheus и Grafana;
- MongoDB, как основное хранилище данных для java-приложения;
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

>## Ответ
>1. Высоконагруженное монолитное java веб-приложение;
>- Docker-контейнер удобен для реализации монолитного web-приложения. Высокая нагрузка не противоречит подходу к контенеризации. Вероятно с помощью контейнера можно будет распределять нагрузку.
>2. Nodejs веб-приложение;
>- Для развёртывания web-приложения удобно использовать Docker-контейнер. Перед релизом контейнер можно запускать на dev- и test- средах для тестирования. Можно воспользоваться [готовым образом](https://hub.docker.com/_/node).
>3. Мобильное приложение c версиями для Android и iOS;
>- Поверхностное изучение вопроса контейнеризации проектов мобильных приложений показало, что: Android-проект можно контейниризировать, a iOS — нельзя. 
В связи с чем предлагаю использовать виртуализацпю.
>4. Шина данных на базе Apache Kafka; 
>- Для конфигурации Apache Kafka можно использовать Docker-контейнер. В случае необходимости разворачивать шину на других, более мощных, серверах Docker-контейнер можно перенести.
>5. Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana; 
>- Так как предлагается разворачивать несколько нод приложения, а так же все приведённые проекта имеют официальные образы в Docker Hub ([Elasticsearch](https://hub.docker.com/_/elasticsearch), [Logstash](https://hub.docker.com/_/logstash), [Kibana](https://hub.docker.com/_/kibana)) предлагаю использовать Docker-контейнер. При этом Elasticsearch должен быть stateful-приложением, так как это база данных.
>6. Мониторинг-стек на базе Prometheus и Grafana; 
>- Prometheus и Grafana являются приложениями с web-интерфейсом. По сути те же web-приложения. В таких случаях удобно использовать Docker-контейнер.
>7. MongoDB, как основное хранилище данных для java-приложения; 
>- Для MongoDB так же можно использовать Docker-контейнер, например, с официального [образа](https://hub.docker.com/_/mongo). Как и в случае с Elasticsearch — это будет stateful-приложение, для сохранения данных после остановки контейнера. 
>8. Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
>- Gitlab сервер так же удобно разворачивать внутри Docker-контейнера. Такой контейнер легко переносить на различные машины, настраивать и тд.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

>## Ответ
> Загрузили образы и запустили контейнеры
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker$ sudo docker pull centos
[sudo] пароль для user:         
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker$ sudo docker pull debian
Using default tag: latest
latest: Pulling from library/debian
e756f3fdd6a3: Pull complete 
Digest: sha256:3f1d6c17773a45c97bd8f158d665c9709d7b29ed7917ac934086ad96f92e4510
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker$ dsuoo dcker run -it -d --name centos -v $(pwd)/data:/data centos
67bc429f9be40071247508679b7d4097eb24ac725b707b18b549edb4e80b5209

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker$ sudo docker run -it -d --name debian -v $(pwd)/data:/data debian
9c6d26e587ffdab57fa3bd96c4796f2ff646bda2740ef5cabbb8ed8357037334
```
> Создали файл в папке `data`
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker$ echo "file1" > ./data/file1
```
> Подключились к контейнеру и посмотрели что лежит в папке
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker exec centos ls -la /data
total 12
drwxrwxr-x 2 1000 1000 4096 Jun  3 13:49 .
drwxr-xr-x 1 root root 4096 Jun  3 13:48 ..
-rw-rw-r-- 1 1000 1000    6 Jun  3 13:49 file1
```
> Сделали то же самое на другом контейнере
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-03-docker$ echo "file2" > ./data/file2

user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker exec debian  ls -la /data
total 16
drwxrwxr-x 2 1000 1000 4096 Jun  3 13:52 .
drwxr-xr-x 1 root root 4096 Jun  3 13:48 ..
-rw-rw-r-- 1 1000 1000    6 Jun  3 13:49 file1
-rw-rw-r-- 1 1000 1000    6 Jun  3 13:52 file2
user@user-Aspire-5750G:~/netology-dvpspdc3$ 
```
## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

>## Ответ
> Собрали образ и загрузили на Docker Hub как [jjvod/ansible:alpine](https://hub.docker.com/repository/docker/jjvod/ansible)
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker build -t jjvod/ansible:alpine ./05-virt-03-docker/src/build/ansible/
Sending build context to Docker daemon   2.56kB
Step 1/5 : FROM alpine:3.14
 ---> e04c818066af
Step 2/5 : RUN CARGO_NET_GIT_FETCH_WITH_CLI=1 &&     apk --no-cache add         sudo         python3        py3-pip         openssl         ca-certificates         sshpass         openssh-client         rsync         git &&     apk --no-cache add --virtual build-dependencies         python3-dev         libffi-dev         musl-dev         gcc         cargo         openssl-dev         libressl-dev         build-base &&     pip install --upgrade pip wheel &&     pip install --upgrade cryptography cffi &&     pip install ansible==2.9.24 &&     pip install mitogen ansible-lint jmespath &&     pip install --upgrade pywinrm &&     apk del build-dependencies &&     rm -rf /var/cache/apk/* &&     rm -rf /root/.cache/pip &&     rm -rf /root/.cargo
 ---> Running in d89878423d68
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86_64/APKINDEX.tar.gz
(1/55) Installing ca-certificates (20211220-r0)
(2/55) Installing brotli-libs (1.0.9-r5)
(3/55) Installing nghttp2-libs (1.43.0-r0)
(4/55) Installing libcurl (7.79.1-r1)
(5/55) Installing expat (2.4.7-r0)
(6/55) Installing pcre2 (10.36-r0)
(7/55) Installing git (2.32.2-r0)
(8/55) Installing openssh-keygen (8.6_p1-r3)
(9/55) Installing ncurses-terminfo-base (6.2_p20210612-r0)
(10/55) Installing ncurses-libs (6.2_p20210612-r0)
(11/55) Installing libedit (20210216.3.1-r0)
(12/55) Installing openssh-client-common (8.6_p1-r3)
(13/55) Installing openssh-client-default (8.6_p1-r3)
(14/55) Installing openssl (1.1.1o-r0)
(15/55) Installing libbz2 (1.0.8-r1)
(16/55) Installing libffi (3.3-r2)
(17/55) Installing gdbm (1.19-r0)
(18/55) Installing xz-libs (5.2.5-r1)
(19/55) Installing libgcc (10.3.1_git20210424-r2)
(20/55) Installing libstdc++ (10.3.1_git20210424-r2)
(21/55) Installing mpdecimal (2.5.1-r1)
(22/55) Installing readline (8.1.0-r0)
(23/55) Installing sqlite-libs (3.35.5-r0)
(24/55) Installing python3 (3.9.5-r2)
(25/55) Installing py3-appdirs (1.4.4-r2)
(26/55) Installing py3-chardet (4.0.0-r2)
(27/55) Installing py3-idna (3.2-r0)
(28/55) Installing py3-urllib3 (1.26.5-r0)
(29/55) Installing py3-certifi (2020.12.5-r1)
(30/55) Installing py3-requests (2.25.1-r4)
(31/55) Installing py3-msgpack (1.0.2-r1)
(32/55) Installing py3-lockfile (0.12.2-r4)
(33/55) Installing py3-cachecontrol (0.12.6-r1)
(34/55) Installing py3-colorama (0.4.4-r1)
(35/55) Installing py3-contextlib2 (0.6.0-r1)
(36/55) Installing py3-distlib (0.3.1-r3)
(37/55) Installing py3-distro (1.5.0-r3)
(38/55) Installing py3-six (1.15.0-r1)
(39/55) Installing py3-webencodings (0.5.1-r4)
(40/55) Installing py3-html5lib (1.1-r1)
(41/55) Installing py3-parsing (2.4.7-r2)
(42/55) Installing py3-packaging (20.9-r1)
(43/55) Installing py3-toml (0.10.2-r2)
(44/55) Installing py3-pep517 (0.10.0-r2)
(45/55) Installing py3-progress (1.5-r2)
(46/55) Installing py3-retrying (1.3.3-r1)
(47/55) Installing py3-ordered-set (4.0.2-r1)
(48/55) Installing py3-setuptools (52.0.0-r3)
(49/55) Installing py3-pip (20.3.4-r1)
(50/55) Installing libacl (2.2.53-r0)
(51/55) Installing popt (1.18-r0)
(52/55) Installing zstd-libs (1.4.9-r1)
(53/55) Installing rsync (3.2.3-r4)
(54/55) Installing sshpass (1.09-r0)
(55/55) Installing sudo (1.9.7_p1-r1)
Executing busybox-1.33.1-r7.trigger
Executing ca-certificates-20211220-r0.trigger
OK: 98 MiB in 69 packages
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/main/x86_64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.14/community/x86_64/APKINDEX.tar.gz
(1/39) Upgrading libcrypto1.1 (1.1.1n-r0 -> 1.1.1o-r0)
(2/39) Upgrading libssl1.1 (1.1.1n-r0 -> 1.1.1o-r0)
(3/39) Installing pkgconf (1.7.4-r0)
(4/39) Installing python3-dev (3.9.5-r2)
(5/39) Installing linux-headers (5.10.41-r0)
(6/39) Installing libffi-dev (3.3-r2)
(7/39) Installing musl-dev (1.2.2-r3)
(8/39) Installing binutils (2.35.2-r2)
(9/39) Installing libgomp (10.3.1_git20210424-r2)
(10/39) Installing libatomic (10.3.1_git20210424-r2)
(11/39) Installing libgphobos (10.3.1_git20210424-r2)
(12/39) Installing gmp (6.2.1-r1)
(13/39) Installing isl22 (0.22-r0)
(14/39) Installing mpfr4 (4.1.0-r0)
(15/39) Installing mpc1 (1.2.1-r0)
(16/39) Installing gcc (10.3.1_git20210424-r2)
(17/39) Installing rust-stdlib (1.52.1-r1)
(18/39) Installing libxml2 (2.9.14-r0)
(19/39) Installing llvm11-libs (11.1.0-r2)
(20/39) Installing http-parser (2.9.4-r0)
(21/39) Installing pcre (8.44-r0)
(22/39) Installing libssh2 (1.9.0-r1)
(23/39) Installing libgit2 (1.1.0-r2)
(24/39) Installing rust (1.52.1-r1)
(25/39) Installing cargo (1.52.1-r1)
(26/39) Installing openssl-dev (1.1.1o-r0)
(27/39) Installing libressl3.3-libcrypto (3.3.6-r0)
(28/39) Installing libressl3.3-libssl (3.3.6-r0)
(29/39) Installing libressl3.3-libtls (3.3.6-r0)
(30/39) Installing libressl-dev (3.3.6-r0)
(31/39) Installing libmagic (5.40-r1)
(32/39) Installing file (5.40-r1)
(33/39) Installing libc-dev (0.7.2-r3)
(34/39) Installing g++ (10.3.1_git20210424-r2)
(35/39) Installing make (4.3-r0)
(36/39) Installing fortify-headers (1.1-r1)
(37/39) Installing patch (2.7.6-r7)
(38/39) Installing build-base (0.5-r2)
(39/39) Installing build-dependencies (20220603.140643)
Executing busybox-1.33.1-r7.trigger
Executing ca-certificates-20211220-r0.trigger
OK: 1110 MiB in 106 packages
Requirement already satisfied: pip in /usr/lib/python3.9/site-packages (20.3.4)
Collecting pip
  Downloading pip-22.1.2-py3-none-any.whl (2.1 MB)
Collecting wheel
  Downloading wheel-0.37.1-py2.py3-none-any.whl (35 kB)
Installing collected packages: wheel, pip
  Attempting uninstall: pip
    Found existing installation: pip 20.3.4
    Uninstalling pip-20.3.4:
      Successfully uninstalled pip-20.3.4
Successfully installed pip-22.1.2 wheel-0.37.1
Collecting cryptography
  Downloading cryptography-37.0.2-cp36-abi3-musllinux_1_1_x86_64.whl (4.2 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.2/4.2 MB 5.1 MB/s eta 0:00:00
Collecting cffi
  Downloading cffi-1.15.0.tar.gz (484 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 484.1/484.1 kB 1.3 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 kB 1.6 MB/s eta 0:00:00
Building wheels for collected packages: cffi
  Building wheel for cffi (setup.py): started
  Building wheel for cffi (setup.py): finished with status 'done'
  Created wheel for cffi: filename=cffi-1.15.0-cp39-cp39-linux_x86_64.whl size=429210 sha256=3b8003f83c6e1691c9dc95a49cda296cb6c7cea94233a1309e95bd1c59b02dae
  Stored in directory: /root/.cache/pip/wheels/8e/0d/16/77c97b85a9f559c5412c85c129a2bae07c771d31e1beb03c40
Successfully built cffi
Installing collected packages: pycparser, cffi, cryptography
Successfully installed cffi-1.15.0 cryptography-37.0.2 pycparser-2.21
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Collecting ansible==2.9.24
  Downloading ansible-2.9.24.tar.gz (14.3 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 14.3/14.3 MB 7.6 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting jinja2
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 1.6 MB/s eta 0:00:00
Collecting PyYAML
  Downloading PyYAML-6.0.tar.gz (124 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 125.0/125.0 kB 1.4 MB/s eta 0:00:00
  Installing build dependencies: started
  Installing build dependencies: finished with status 'done'
  Getting requirements to build wheel: started
  Getting requirements to build wheel: finished with status 'done'
  Preparing metadata (pyproject.toml): started
  Preparing metadata (pyproject.toml): finished with status 'done'
Requirement already satisfied: cryptography in /usr/lib/python3.9/site-packages (from ansible==2.9.24) (37.0.2)
Requirement already satisfied: cffi>=1.12 in /usr/lib/python3.9/site-packages (from cryptography->ansible==2.9.24) (1.15.0)
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.1-cp39-cp39-musllinux_1_1_x86_64.whl (29 kB)
Requirement already satisfied: pycparser in /usr/lib/python3.9/site-packages (from cffi>=1.12->cryptography->ansible==2.9.24) (2.21)
Building wheels for collected packages: ansible, PyYAML
  Building wheel for ansible (setup.py): started
  Building wheel for ansible (setup.py): finished with status 'done'
  Created wheel for ansible: filename=ansible-2.9.24-py3-none-any.whl size=16205052 sha256=2b79c4600d4c71fb3bb594639a7127c4dd29f9ec1267aa69e51ef60d51e294f9
  Stored in directory: /root/.cache/pip/wheels/ba/89/f3/df35238037ec8303702ddd8569ce11a807935f96ecb3ff6d52
  Building wheel for PyYAML (pyproject.toml): started
  Building wheel for PyYAML (pyproject.toml): finished with status 'done'
  Created wheel for PyYAML: filename=PyYAML-6.0-cp39-cp39-linux_x86_64.whl size=45331 sha256=3b6bae36656234cd631aa3232e2de3b6a190be916707a29412fcb2c9f47c4b41
  Stored in directory: /root/.cache/pip/wheels/b4/0f/9a/d6af48581dda678920fccfb734f5d9f827c6ed5b4074c7eda8
Successfully built ansible PyYAML
Installing collected packages: PyYAML, MarkupSafe, jinja2, ansible
Successfully installed MarkupSafe-2.1.1 PyYAML-6.0 ansible-2.9.24 jinja2-3.1.2
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Collecting mitogen
  Downloading mitogen-0.3.2-py2.py3-none-any.whl (288 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 289.0/289.0 kB 1.4 MB/s eta 0:00:00
Collecting ansible-lint
  Downloading ansible_lint-6.2.2-py3-none-any.whl (175 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 175.5/175.5 kB 1.9 MB/s eta 0:00:00
Collecting jmespath
  Downloading jmespath-1.0.0-py3-none-any.whl (23 kB)
Collecting enrich>=1.2.6
  Downloading enrich-1.2.7-py3-none-any.whl (8.7 kB)
Collecting yamllint>=1.25.0
  Downloading yamllint-1.26.3.tar.gz (126 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 126.7/126.7 kB 1.8 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting ansible-core>=2.12.0
  Downloading ansible_core-2.13.0-py3-none-any.whl (2.1 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.1/2.1 MB 5.5 MB/s eta 0:00:00
Collecting jsonschema>=4.5.1
  Downloading jsonschema-4.6.0-py3-none-any.whl (80 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 80.4/80.4 kB 872.7 kB/s eta 0:00:00
Requirement already satisfied: pyyaml in /usr/lib/python3.9/site-packages (from ansible-lint) (6.0)
Collecting rich>=9.5.1
  Downloading rich-12.4.4-py3-none-any.whl (232 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 232.0/232.0 kB 2.4 MB/s eta 0:00:00
Collecting ansible-compat>=2.0.4
  Downloading ansible_compat-2.1.0-py3-none-any.whl (18 kB)
Requirement already satisfied: packaging in /usr/lib/python3.9/site-packages (from ansible-lint) (20.9)
Collecting pytest
  Downloading pytest-7.1.2-py3-none-any.whl (297 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 297.0/297.0 kB 3.0 MB/s eta 0:00:00
Collecting wcmatch>=7.0
  Downloading wcmatch-8.4-py3-none-any.whl (40 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 40.0/40.0 kB 717.6 kB/s eta 0:00:00
Collecting ruamel.yaml<0.18,>=0.15.34
  Downloading ruamel.yaml-0.17.21-py3-none-any.whl (109 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 109.5/109.5 kB 1.5 MB/s eta 0:00:00
Collecting subprocess-tee>=0.3.5
  Downloading subprocess_tee-0.3.5-py3-none-any.whl (8.0 kB)
Requirement already satisfied: jinja2>=3.0.0 in /usr/lib/python3.9/site-packages (from ansible-core>=2.12.0->ansible-lint) (3.1.2)
Collecting resolvelib<0.6.0,>=0.5.3
  Downloading resolvelib-0.5.4-py2.py3-none-any.whl (12 kB)
Requirement already satisfied: cryptography in /usr/lib/python3.9/site-packages (from ansible-core>=2.12.0->ansible-lint) (37.0.2)
Collecting attrs>=17.4.0
  Downloading attrs-21.4.0-py2.py3-none-any.whl (60 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 60.6/60.6 kB 1.2 MB/s eta 0:00:00
Collecting pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0
  Downloading pyrsistent-0.18.1.tar.gz (100 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 100.5/100.5 kB 1.4 MB/s eta 0:00:00
  Installing build dependencies: started
  Installing build dependencies: finished with status 'done'
  Getting requirements to build wheel: started
  Getting requirements to build wheel: finished with status 'done'
  Preparing metadata (pyproject.toml): started
  Preparing metadata (pyproject.toml): finished with status 'done'
Collecting commonmark<0.10.0,>=0.9.0
  Downloading commonmark-0.9.1-py2.py3-none-any.whl (51 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 51.1/51.1 kB 657.9 kB/s eta 0:00:00
Collecting pygments<3.0.0,>=2.6.0
  Downloading Pygments-2.12.0-py3-none-any.whl (1.1 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.1/1.1 MB 4.8 MB/s eta 0:00:00
Collecting ruamel.yaml.clib>=0.2.6
  Downloading ruamel.yaml.clib-0.2.6.tar.gz (180 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 180.7/180.7 kB 2.1 MB/s eta 0:00:00
  Preparing metadata (setup.py): started
  Preparing metadata (setup.py): finished with status 'done'
Collecting bracex>=2.1.1
  Downloading bracex-2.3.post1-py3-none-any.whl (12 kB)
Collecting pathspec>=0.5.3
  Downloading pathspec-0.9.0-py2.py3-none-any.whl (31 kB)
Requirement already satisfied: setuptools in /usr/lib/python3.9/site-packages (from yamllint>=1.25.0->ansible-lint) (52.0.0)
Collecting pluggy<2.0,>=0.12
  Downloading pluggy-1.0.0-py2.py3-none-any.whl (13 kB)
Collecting py>=1.8.2
  Downloading py-1.11.0-py2.py3-none-any.whl (98 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 98.7/98.7 kB 1.5 MB/s eta 0:00:00
Collecting iniconfig
  Downloading iniconfig-1.1.1-py2.py3-none-any.whl (5.0 kB)
Collecting tomli>=1.0.0
  Downloading tomli-2.0.1-py3-none-any.whl (12 kB)
Requirement already satisfied: MarkupSafe>=2.0 in /usr/lib/python3.9/site-packages (from jinja2>=3.0.0->ansible-core>=2.12.0->ansible-lint) (2.1.1)
Requirement already satisfied: cffi>=1.12 in /usr/lib/python3.9/site-packages (from cryptography->ansible-core>=2.12.0->ansible-lint) (1.15.0)
Requirement already satisfied: pycparser in /usr/lib/python3.9/site-packages (from cffi>=1.12->cryptography->ansible-core>=2.12.0->ansible-lint) (2.21)
Building wheels for collected packages: yamllint, pyrsistent, ruamel.yaml.clib
  Building wheel for yamllint (setup.py): started
  Building wheel for yamllint (setup.py): finished with status 'done'
  Created wheel for yamllint: filename=yamllint-1.26.3-py2.py3-none-any.whl size=60804 sha256=46df1968ac1bad899c768085d8038be52a6b1118c2532ac74fb1c13950cac1d0
  Stored in directory: /root/.cache/pip/wheels/ad/e7/53/f6ab69bd61ed0a887ee815302635448de42a0bc04035d5c1e9
  Building wheel for pyrsistent (pyproject.toml): started
  Building wheel for pyrsistent (pyproject.toml): finished with status 'done'
  Created wheel for pyrsistent: filename=pyrsistent-0.18.1-cp39-cp39-linux_x86_64.whl size=119786 sha256=8b819bfb5a306bb145b5e71f4d7849fb2fb3491f6fb6bb41720a766de21300d7
  Stored in directory: /root/.cache/pip/wheels/87/fe/e6/fc8deeb581a41e462eafaf19fee96f51cdc8391e0be1c8088a
  Building wheel for ruamel.yaml.clib (setup.py): started
  Building wheel for ruamel.yaml.clib (setup.py): finished with status 'done'
  Created wheel for ruamel.yaml.clib: filename=ruamel.yaml.clib-0.2.6-cp39-cp39-linux_x86_64.whl size=746364 sha256=a80695df9b774aaa0e72770c7b8c8f2af88a6ac964c2f3bf6e9eb54b5ab4db72
  Stored in directory: /root/.cache/pip/wheels/b1/c4/5d/d96e5c09189f4d6d2a9ffb0d7af04ee06d11a20f613f5f3496
Successfully built yamllint pyrsistent ruamel.yaml.clib
Installing collected packages: resolvelib, iniconfig, commonmark, tomli, subprocess-tee, ruamel.yaml.clib, pyrsistent, pygments, py, pluggy, pathspec, mitogen, jmespath, bracex, attrs, yamllint, wcmatch, ruamel.yaml, rich, pytest, jsonschema, enrich, ansible-core, ansible-compat, ansible-lint
Successfully installed ansible-compat-2.1.0 ansible-core-2.13.0 ansible-lint-6.2.2 attrs-21.4.0 bracex-2.3.post1 commonmark-0.9.1 enrich-1.2.7 iniconfig-1.1.1 jmespath-1.0.0 jsonschema-4.6.0 mitogen-0.3.2 pathspec-0.9.0 pluggy-1.0.0 py-1.11.0 pygments-2.12.0 pyrsistent-0.18.1 pytest-7.1.2 resolvelib-0.5.4 rich-12.4.4 ruamel.yaml-0.17.21 ruamel.yaml.clib-0.2.6 subprocess-tee-0.3.5 tomli-2.0.1 wcmatch-8.4 yamllint-1.26.3
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
Collecting pywinrm
  Downloading pywinrm-0.4.3-py2.py3-none-any.whl (44 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 44.1/44.1 kB 515.8 kB/s eta 0:00:00
Requirement already satisfied: requests>=2.9.1 in /usr/lib/python3.9/site-packages (from pywinrm) (2.25.1)
Requirement already satisfied: six in /usr/lib/python3.9/site-packages (from pywinrm) (1.15.0)
Collecting xmltodict
  Downloading xmltodict-0.13.0-py2.py3-none-any.whl (10.0 kB)
Collecting requests-ntlm>=1.1.0
  Downloading requests_ntlm-1.1.0-py2.py3-none-any.whl (5.7 kB)
Requirement already satisfied: chardet<5,>=3.0.2 in /usr/lib/python3.9/site-packages (from requests>=2.9.1->pywinrm) (4.0.0)
Requirement already satisfied: idna<3.3,>=2.5 in /usr/lib/python3.9/site-packages (from requests>=2.9.1->pywinrm) (3.2)
Requirement already satisfied: urllib3<1.27,>=1.21.1 in /usr/lib/python3.9/site-packages (from requests>=2.9.1->pywinrm) (1.26.5)
Requirement already satisfied: certifi>=2017.4.17 in /usr/lib/python3.9/site-packages (from requests>=2.9.1->pywinrm) (2020.12.5)
Requirement already satisfied: cryptography>=1.3 in /usr/lib/python3.9/site-packages (from requests-ntlm>=1.1.0->pywinrm) (37.0.2)
Collecting ntlm-auth>=1.0.2
  Downloading ntlm_auth-1.5.0-py2.py3-none-any.whl (29 kB)
Requirement already satisfied: cffi>=1.12 in /usr/lib/python3.9/site-packages (from cryptography>=1.3->requests-ntlm>=1.1.0->pywinrm) (1.15.0)
Requirement already satisfied: pycparser in /usr/lib/python3.9/site-packages (from cffi>=1.12->cryptography>=1.3->requests-ntlm>=1.1.0->pywinrm) (2.21)
Installing collected packages: xmltodict, ntlm-auth, requests-ntlm, pywinrm
Successfully installed ntlm-auth-1.5.0 pywinrm-0.4.3 requests-ntlm-1.1.0 xmltodict-0.13.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
WARNING: Ignoring https://dl-cdn.alpinelinux.org/alpine/v3.14/main: No such file or directory
WARNING: Ignoring https://dl-cdn.alpinelinux.org/alpine/v3.14/community: No such file or directory
(1/37) Purging build-dependencies (20220603.140643)
(2/37) Purging python3-dev (3.9.5-r2)
(3/37) Purging libffi-dev (3.3-r2)
(4/37) Purging linux-headers (5.10.41-r0)
(5/37) Purging cargo (1.52.1-r1)
(6/37) Purging rust (1.52.1-r1)
(7/37) Purging rust-stdlib (1.52.1-r1)
(8/37) Purging openssl-dev (1.1.1o-r0)
(9/37) Purging libressl-dev (3.3.6-r0)
(10/37) Purging libressl3.3-libssl (3.3.6-r0)
(11/37) Purging libressl3.3-libtls (3.3.6-r0)
(12/37) Purging build-base (0.5-r2)
(13/37) Purging file (5.40-r1)
(14/37) Purging g++ (10.3.1_git20210424-r2)
(15/37) Purging gcc (10.3.1_git20210424-r2)
(16/37) Purging binutils (2.35.2-r2)
(17/37) Purging libatomic (10.3.1_git20210424-r2)
(18/37) Purging libgomp (10.3.1_git20210424-r2)
(19/37) Purging libgphobos (10.3.1_git20210424-r2)
(20/37) Purging make (4.3-r0)
(21/37) Purging libc-dev (0.7.2-r3)
(22/37) Purging musl-dev (1.2.2-r3)
(23/37) Purging fortify-headers (1.1-r1)
(24/37) Purging patch (2.7.6-r7)
(25/37) Purging pkgconf (1.7.4-r0)
(26/37) Purging mpc1 (1.2.1-r0)
(27/37) Purging mpfr4 (4.1.0-r0)
(28/37) Purging isl22 (0.22-r0)
(29/37) Purging gmp (6.2.1-r1)
(30/37) Purging llvm11-libs (11.1.0-r2)
(31/37) Purging libxml2 (2.9.14-r0)
(32/37) Purging libgit2 (1.1.0-r2)
(33/37) Purging http-parser (2.9.4-r0)
(34/37) Purging pcre (8.44-r0)
(35/37) Purging libssh2 (1.9.0-r1)
(36/37) Purging libressl3.3-libcrypto (3.3.6-r0)
(37/37) Purging libmagic (5.40-r1)
Executing busybox-1.33.1-r7.trigger
OK: 98 MiB in 69 packages
Removing intermediate container d89878423d68
 ---> ece3d8c0c0d5
Step 3/5 : RUN mkdir /ansible &&     mkdir -p /etc/ansible &&     echo 'localhost' > /etc/ansible/hosts
 ---> Running in 3796d03557b2
Removing intermediate container 3796d03557b2
 ---> a676ecba7315
Step 4/5 : WORKDIR /ansible
 ---> Running in 734b246f30ea
Removing intermediate container 734b246f30ea
 ---> 4cd02cb3e164
Step 5/5 : CMD [ "ansible-playbook", "--version" ]
 ---> Running in 68741063eb5a
Removing intermediate container 68741063eb5a
 ---> 2e4c52ff3d8e
Successfully built 2e4c52ff3d8e
Successfully tagged jjvod/ansible:alpine
user@user-Aspire-5750G:~/netology-dvpspdc3$ sudo docker push jjvod/ansible:alpine
The push refers to repository [docker.io/jjvod/ansible]
7fdc2686c76a: Pushed 
a0e1bbee2f32: Pushed 
b541d28bf3b4: Mounted from library/alpine 
alpine: digest: sha256:dc89cac00bbb8e2a36c66cbea6a8e4355326712257e74c083e627ef433d37094 size: 947
user@user-Aspire-5750G:~/netology-dvpspdc3$ 
```
---
