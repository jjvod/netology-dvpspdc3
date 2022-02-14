# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

    >### Разреженные (sparse) файлы — это файлы, которые с большей эффективностью используют пространство файловой системы. Часть цифровой последовательности файла заменена перечнем дыр. Информация об отсутствующих последовательностях располагается в метаданных файловой системы, не занятый высвободившийся объем запоминающего устройства будет использоваться для записи по мере надобности

1. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

    >### Нет, жесткие ссылки, в отличие от симлинков, имеют ту же информацию inode и набор разрешений, что и у исходного файла. 
    ```bash
    vagrant@vagrant:~$ touch file
    vagrant@vagrant:~$ ls
    file
    vagrant@vagrant:~$ ln -P file hard_link
    vagrant@vagrant:~$ ls -li
    total 0
    1051846 -rw-rw-r-- 2 vagrant vagrant 0 Feb  14 13:18 file
    1051846 -rw-rw-r-- 2 vagrant vagrant 0 Feb  14 13:18 hard_link
    vagrant@vagrant:~$ chmod 770 ./file
    1051846 -rwxrwx--- 2 vagrant vagrant 0 Feb  14 13:18 file
    1051846 -rwxrwx--- 2 vagrant vagrant 0 Feb  14 13:18 hard_link
    ```

1. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

    >### Сделали

1. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

    >### Запустили `fdisk /dev/sdb` и разбили диск, получили следующую кртину.

    ```bash
    root@vagrant:~# fdisk /dev/sdb
    Command (m for help): n
    Partition type
      p   primary (0 primary, 0 extended, 4 free)
      e   extended (container for logical partitions)
    Select (default p): p
    Partition number (1-4, default 1): 1
    First sector (2048-5242879, default 2048):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
    Created a new partition 1 of type 'Linux' and of size 2 GiB.

    Command (m for help): n
    Partition type
      p   primary (1 primary, 0 extended, 3 free)
      e   extended (container for logical partitions)
    Select (default p): p
    Partition number (2-4, default 2): 2
    First sector (4196352-5242879, default 4196352):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):
    Created a new partition 2 of type 'Linux' and of size 511 MiB.

    Command (m for help): w
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.

    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    root@vagrant:~#
    ```

1. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

    >### Перенесли

    ```bash
    root@vagrant:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
    Checking that no-one is using this disk right now ... OK

    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes

    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Created a new DOS disklabel with disk identifier 0x4fcafbb2.
    /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
    /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
    /dev/sdc3: Done.

    New situation:
    Disklabel type: dos
    Disk identifier: 0x4fcafbb2

    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G 83 Linux
    /dev/sdc2       4196352 5242879 1046528  511M 83 Linux

    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    └─sdc2                      8:34   0  511M  0 part
    root@vagrant:~#
    ```

1. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

    >### Сделали

    ```bash
    root@vagrant:~# mdadm --create --verbose /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    mdadm: size set to 2094080K
    Continue creating array?
    Continue creating array? (y/n) y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop  /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop  /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part  /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2
    ```
    
1. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

    >### Собрали

    ```bash
    root@vagrant:~# mdadm --create --verbose /dev/md1 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.
    root@vagrant:~# cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
    md1 : active raid0 sdc2[1] sdb2[0]
          1042432 blocks super 1.2 512k chunks

    md0 : active raid1 sdc1[1] sdb1[0]
          2094080 blocks super 1.2 [2/2] [UU]

    unused devices: <none>
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop  /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop  /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part  /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
    ```

1. Создайте 2 независимых PV на получившихся md-устройствах.

    >### Создали

    ```bash
    root@vagrant:~# pvcreate /dev/md0
      Physical volume "/dev/md0" successfully created.
    root@vagrant:~# pvcreate /dev/md1
      Physical volume "/dev/md1" successfully created.
    ```

1. Создайте общую volume-group на этих двух PV.

    >### Создали общую группу
    ```bash
    root@vagrant:~# vgcreate vgroup /dev/md0 /dev/md1
      Volume group "vgroup" successfully created
    ```

1. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    >### Создали
    ```bash
    root@vagrant:~# lvcreate -L 100M vgroup /dev/md1
      Logical volume "lvol0" created.
    ```

1. Создайте `mkfs.ext4` ФС на получившемся LV.

    >### Создали
    ```bash
    root@vagrant:~# mkfs.ext4 /dev/vgroup/lvol0
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done
    ```

1. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

    >### Смонтировали
    ```bash
    root@vagrant:~# mkdir /tmp/new
    root@vagrant:~# mount /dev/vgroup/lvol0 /tmp/new
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop  /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop  /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part  /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
        └─vgroup-lvol0        253:1    0  100M  0 lvm   /tmp/new
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
        └─vgroup-lvol0        253:1    0  100M  0 lvm   /tmp/new
    ```

1. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

    >### Поместили

    ```bash
    root@vagrant:~# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
    --2022-02-14 23:56:41--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 22836046 (22M) [application/octet-stream]
    Saving to: ‘/tmp/new/test.gz’

    /tmp/new/test.gz                         100%[===============================================================================>]  21.78M  7.23MB/s    in 3.0s

    2022-02-14 23:56:44 (7.23 MB/s) - ‘/tmp/new/test.gz’ saved [22836046/22836046]
    ```

1. Прикрепите вывод `lsblk`.

    >### Прикрепили

    ```bash
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop  /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop  /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part  /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
        └─vgroup-lvol0        253:1    0  100M  0 lvm   /tmp/new
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
        └─vgroup-lvol0        253:1    0  100M  0 lvm   /tmp/new
    ```

1. Протестируйте целостность файла:

    >### Протестировал
    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    root@vagrant:~#
    ```
1. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    >### Переместили

    ```bash
    root@vagrant:~# pvmove /dev/md1 /dev/md0
      /dev/md1: Moved: 8.00%
      /dev/md1: Moved: 100.00%
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 32.3M  1 loop  /snap/snapd/12704
    loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
    loop2                       7:2    0 55.4M  1 loop  /snap/core18/2128
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0    1G  0 part  /boot
    └─sda3                      8:3    0   63G  0 part
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk
    ├─sdb1                      8:17   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    │   └─vgroup-lvol0        253:1    0  100M  0 lvm   /tmp/new
    └─sdb2                      8:18   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
    sdc                         8:32   0  2.5G  0 disk
    ├─sdc1                      8:33   0    2G  0 part
    │ └─md0                     9:0    0    2G  0 raid1
    │   └─vgroup-lvol0        253:1    0  100M  0 lvm   /tmp/new
    └─sdc2                      8:34   0  511M  0 part
      └─md1                     9:1    0 1018M  0 raid0
    root@vagrant:~#
    ```

1. Сделайте `--fail` на устройство в вашем RAID1 md.
    
    >### Сделали

    ```bash
    root@vagrant:~#  mdadm /dev/md0 --fail /dev/sdb1
    mdadm: set /dev/sdb1 faulty in /dev/md0
    ```
1. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.
    
    >### Подтверждаю

    ```bash
    root@vagrant:~# dmesg
    [ 2488.538318] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
    [ 2488.538332] ext4 filesystem being mounted at /tmp/new supports timestamps until 2038 (0x7fffffff)
    [ 3126.908382] md/raid1:md0: Disk failure on sdb1, disabling device.
                  md/raid1:md0: Operation continuing on 1 devices.
    root@vagrant:~#
    ```
1. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    >### Протестировал
    ```bash
    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
    root@vagrant:~#
    ```
1. Погасите тестовый хост, `vagrant destroy`.
  >### Погасили
  ```bash
  PS D:\netology\repos\my home work\netology-dvpspdc3\03-sysadmin-05-fs\vagrant> vagrant destroy
      default: Are you sure you want to destroy the 'default' VM? [y/N] y
  ==> default: Destroying VM and associated drives...
  ```