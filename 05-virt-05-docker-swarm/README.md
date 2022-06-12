# Домашнее задание к занятию "5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm"

## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

>### Ответ:
[Источник](https://docs.docker.com/engine/swarm/how-swarm-mode-works/services/)

    Для реплицированной службы вы указываете количество идентичных задач, которые хотите запустить.

    Например, вы решили развернуть службу HTTP с тремя репликами, каждая из которых обслуживает один и тот же контент.

    Глобальная служба - это служба, которая выполняет одну задачу на каждом узле. Нет заранее заданного количества задач. 

    Каждый раз, когда вы добавляете узел в "Swarm", оркестратор создает задачу, а планировщик назначает задачу новому узлу. 

    Хорошими кандидатами на глобальные службы являются агенты мониторинга, антивирусные сканеры или другие типы контейнеров, которые вы хотите запустить на каждом узле "Swarm.

## Какой алгоритм выбора лидера используется в Docker Swarm кластере?

>### Ответ:
     Алгоритм Raft — главная та нода, которая получила больше всего голосов.

## Что такое Overlay Network?

>### Ответ:
 [Источник](https://docs.docker.com/network/overlay/)

    Overlay Network —  Сетевой драйвер создает распределенную сеть между несколькими хостами демонов Docker. 

    Эта сеть находится поверх (накладывается) на сети конкретного хоста, позволяя подключенным к ней контейнерам(включая служебные контейнеры swarm) безопасно обмениваться данными при включенном шифровании.

    Docker прозрачно обрабатывает маршрутизацию каждого пакета к и от правильного хоста демона Docker и правильного контейнера назначения.

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
>### Ответ:
- Разворачиваем инфраструктуру

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ yc config profile activate default
Profile 'default' activated
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ yc vpc network create --name net --labels my-label=netology --description "my first network via yc"
id: enppdgnqrode1sbuvhfb
folder_id: b1g6kuq3urjf6j4jq2s8
created_at: "2022-06-12T20:13:02Z"
name: net
description: my first network via yc
labels:
  my-label: netology

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"
id: e9boa2bltfa8a6dpugia
folder_id: b1g6kuq3urjf6j4jq2s8
created_at: "2022-06-12T20:13:13Z"
name: my-subnet-a
description: my first subnet via yc
network_id: enppdgnqrode1sbuvhfb
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src$ packer build ./packer/centos-7-base.json
yandex: output will be in this color.
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src$ yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd85sbu0mbnf2e55qq34 | centos-7-base | centos | f2egp3k2jkoqh7dl2t0l | READY  |
+----------------------+---------------+--------+----------------------+--------+

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src$ cd terraform/
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ terraform init

Initializing the backend...
...
Terraform has been successfully initialized!

user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ terraform apply -auto-approve
...
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01 = "51.250.93.198"
external_ip_address_node02 = "51.250.94.4"
external_ip_address_node03 = "51.250.68.143"
external_ip_address_node04 = "51.250.95.106"
external_ip_address_node05 = "51.250.95.193"
external_ip_address_node06 = "51.250.92.170"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
```
- подключаемся и смотрим `docker node ls`

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ ssh centos@51.250.93.198
[centos@node01 ~]$ sudo -i
[root@node01 ~]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
uwdalv6s78aflnztqv9bby4se *   node01.netology.yc   Ready     Active         Leader           20.10.17
sc6c0nsgnwc7ixteh03bmeosd     node02.netology.yc   Ready     Active         Reachable        20.10.17
mp5y5ax86uarsvsnzp1nj7qop     node03.netology.yc   Ready     Active         Reachable        20.10.17
j8vsrgb51yst514a33fv2pdf1     node04.netology.yc   Ready     Active                          20.10.17
zn2fx351ou11kmhahpycfgplo     node05.netology.yc   Ready     Active                          20.10.17
ssk6w8te6kx4mrd1b1j9rag8t     node06.netology.yc   Ready     Active                          20.10.17
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

>### Ответ:
- Смотрим развернутые сервисы `docker service ls`

```bash
[root@node01 ~]# docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
y8d39a5bf5dm   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
144651m3404a   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
v5j03lqexmlj   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
ulw6ajprs6r9   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
jwp30cmc8mvo   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
pxgrpguy8a5a   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
i7e8m1b5wvmz   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
xei57mhvwn19   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
```


## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```

>### Ответ:
- Команда `docker swarm update --autolock=true` создаёт ключ для шифрования/дешифрования логов Raft.

```bash
[root@node01 ~]# docker swarm update --autolock=true
Swarm updated.
To unlock a swarm manager after it restarts, run the `docker swarm unlock`
command and provide the following key:

    SWMKEY-1-YV8P+F0cbrymWDcws1lmYqMFkvmftwMIMrir2DACpIM

Please remember to store this key in a password manager, since without it you
will not be able to restart the manager.
[root@node01 ~]# logout
[centos@node01 ~]$ logout
Connection to 51.250.93.198 closed.
user@user-Aspire-5750G:~/netology-dvpspdc3/
```
- удаляем инфраструктуру
```bash
05-virt-05-docker-swarm/src/terraform$ terraform destroy -auto-approve
...
Destroy complete! Resources: 13 destroyed.
user@user-Aspire-5750G:~/netology-dvpspdc3/05-virt-05-docker-swarm/src/terraform$ 
```