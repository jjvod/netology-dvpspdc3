
---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.
- Какой из принципов IaaC является основополагающим?

>## Ответ:
>### 1. Основные преимущества применения IaaC паттернов:
>- **CI (Continuous Integration)** — принцип CI предполагает слияние рабочих веток в основную ветку и автоматизированную пересборку проекта и запуск тестов. Позволяет избавить разработчиков от ручных действий и выявлять проблемы на сразу после пересборки.   
>- **CD (Continuous Delivery)** — принцип CD (delivery) предполагает отправлять валидные доработки в dev-окружения по нажатию кнопки. В случае обнаружения проблем можно откатиться до предыдущей стабильной версии.
>- **CD (Continuous Deployment)** — принцип CD (deployment) предполагает полную автоматизацию развёртывания доработок в dev-окружения. Однако релиз в production всё ещё в под ручным управлением, для минимизации бизнес-рисков.   
>### 2. Основопологающим принципом IaaC является **индемпотентность**. Индемпотентность обеспечивает идентичный результат при повторном выполнении каких-либо операций.

---

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

>## Ответ:
>### 1. Ansible реализован как open source решение. Для корпоративного использования доступна проприетарная версия — Ansible Tower. Ansible поддерживает как декларативный, так и императивный подходы. Относительно низкий порог входа. В сети можно найти много примеров использования и подробную документацию.
>### 2. Основная разница между методами push и pull заключается в том, кто инициирует изменения на гостевой машине. На мой взгляд, более надёжно использовать метод push. Это позволит избежать ситуации, когда десятки или сотни гостевых машин начинают одновременно запрашивать изменения с мастер-сервера.

---

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

>## Ответ:
>### Установили, вот версии ПО
```bash
user@user-Aspire-5750G:~/05-virt-02-iaac/src/vagrant$ virtualbox -h
Oracle VM VirtualBox VM Selector v6.1.32_Ubuntu
(C) 2005-2022 Oracle Corporation
All rights reserved.

No special options.

If you are looking for --startvm and related options, you need to use VirtualBoxVM.
```

```bash
user@user-Aspire-5750G:~/05-virt-02-iaac/src/vagrant$ vagrant -v
Vagrant 2.2.6
```

```bash
user@user-Aspire-5750G:~/05-virt-02-iaac/src/vagrant$ ansible --version
ansible 2.9.6
  config file = /home/user/05-virt-02-iaac/src/vagrant/ansible.cfg
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
```

---

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды
```
docker ps
```
>## Ответ:
>### Создали зашли и проверили, все работает
```bash
user@user-Aspire-5750G:~/05-virt-02-iaac/src/vagrant$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Importing base box 'bento/ubuntu-20.04'...
==> server1.netology: Matching MAC address for NAT networking...
==> server1.netology: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
==> server1.netology: Setting the name of the VM: server1.netology
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
    server1.netology: Adapter 2: hostonly
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Remote connection disconnect. Retrying...
    server1.netology: Warning: Connection reset. Retrying...
    server1.netology:
    server1.netology: Vagrant insecure key detected. Vagrant will automatically replace
    server1.netology: this with a newly generated keypair for better security.
    server1.netology:
    server1.netology: Inserting generated public key within guest...
    server1.netology: Removing insecure key from the guest if it's present...
    server1.netology: Key inserted! Disconnecting and reconnecting using new SSH key...
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Configuring and enabling network interfaces...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/user/05-virt-02-iaac/src/vagrant
==> server1.netology: Running provisioner: ansible...
Vagrant has automatically selected the compatibility mode '2.0'
according to the Ansible version installed (2.9.6).

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
changed: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=['git', 'curl'])

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
changed: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

user@user-Aspire-5750G:~/05-virt-02-iaac/src/vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Fri 03 Jun 2022 04:18:25 AM UTC

  System load:  0.08               Users logged in:          0
  Usage of /:   13.6% of 30.88GB   IPv4 address for docker0: 172.17.0.1
  Memory usage: 24%                IPv4 address for eth0:    10.0.2.15
  Swap usage:   0%                 IPv4 address for eth1:    192.168.192.11
  Processes:    108


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Fri Jun  3 03:59:41 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$
```
