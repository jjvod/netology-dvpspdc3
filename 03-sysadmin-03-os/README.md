# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

    >### Это системный вызов `chdir`

    ```
    vagrant@vagrant:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep chdir
    chdir("/tmp")                           = 0
    vagrant@vagrant:~$
    ```

1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-641 пл > 7 корп > 1эт. > п.97 (ЦРП)
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

    >###  `file` использует библиотеку `libmagic` и с помощью `magic` файлов сопоставляет тип файла, основной файл `magic` базы лежит в файле `/usr/share/misc/magic.mgc`.

    ```
    vagrant@vagrant:~$ strace file /dev/tty 2>&1 | grep -F '"/'
    execve("/usr/bin/file", ["file", "/dev/tty"], 0x7ffc51aa66d8 /* 29 vars */) = 0
    access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
    stat("/home/vagrant/.magic.mgc", 0x7ffc789200d0) = -1 ENOENT (No such file or directory)
    stat("/home/vagrant/.magic", 0x7ffc789200d0) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
    stat("/etc/magic", {st_mode=S_IFREG|0644, st_size=111, ...}) = 0
    openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
    openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
    openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
    lstat("/dev/tty", {st_mode=S_IFCHR|0666, st_rdev=makedev(0x5, 0), ...}) = 0
    write(1, "/dev/tty: character special (5/0"..., 34/dev/tty: character special (5/0)
    vagrant@vagrant:~$
    ```

1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

    >### Запустили бесконечную запись в файл `cat /dev/urandom > /tmp/test`, потом остановили  пока место на диске не кончилось и пошли смотреть

    ```
    vagrant@vagrant:/tmp$ cat /dev/urandom > /tmp/test
    ^Z
    [1]+  Stopped                 cat /dev/urandom > /tmp/test
    vagrant@vagrant:/tmp$ ls -lah /tmp/test
    -rw-rw-r-- 1 vagrant vagrant 174M Jan 28 12:05 /tmp/test
    ```
    >### Файл раздулся уже до 174М за несколько секунд, запустим еще не надолго

    ```
    vagrant@vagrant:/tmp$ fg 1
    cat /dev/urandom > /tmp/test
    ^Z
    [1]+  Stopped                 cat /dev/urandom > /tmp/test
    vagrant@vagrant:/tmp$ ls -lah /tmp/test
    -rw-rw-r-- 1 vagrant vagrant 342M Jan 28 12:05 /tmp/test

    ```
    >### Файл уже весит 342М, узнаем `pid` процесса посомтрим через `lsof` на наш файл

    ```

    vagrant@vagrant:/tmp$ ps aux | grep -F cat
    vagrant     2218  0.6  0.0   5620   528 pts/0    T    12:05   0:01 cat /dev/urandom
    vagrant     2232  0.0  0.0   6300   736 pts/0    S+   12:09   0:00 grep --color=auto -F cat
    vagrant@vagrant:/tmp$ lsof -p 2218 | grep /tmp
    cat     2218 vagrant  cwd    DIR  253,0      4096 1572866 /tmp
    cat     2218 vagrant    1w   REG  253,0 357826560 1572879 /tmp/test

    ```
    >### Удалим наш файл, в `lsof` он будет помечен как удаленный

    ```

    vagrant@vagrant:/tmp$ rm /tmp/test
    vagrant@vagrant:/tmp$ lsof -p 2218 | grep /tmp
    cat     2218 vagrant  cwd    DIR  253,0      4096 1572866 /tmp
    cat     2218 vagrant    1w   REG  253,0 357826560 1572879 /tmp/test (deleted)

    ```
    >### Посмотрим дескрипторы нашего процесса, и с помощью `truncate` обнулим наш файл

    ```

    vagrant@vagrant:/tmp$ ls -lah /proc/2218/fd
    total 0
    dr-x------ 2 vagrant vagrant  0 Jan 28 12:09 .
    dr-xr-xr-x 9 vagrant vagrant  0 Jan 28 12:06 ..
    lrwx------ 1 vagrant vagrant 64 Jan 28 12:09 0 -> /dev/pts/0
    l-wx------ 1 vagrant vagrant 64 Jan 28 12:09 1 -> '/tmp/test (deleted)'
    lrwx------ 1 vagrant vagrant 64 Jan 28 12:09 2 -> /dev/pts/0
    lr-x------ 1 vagrant vagrant 64 Jan 28 12:09 3 -> /dev/urandom
    vagrant@vagrant:/tmp$ truncate -s 0 /proc/2218/fd/1
    vagrant@vagrant:/tmp$ lsof -p 2218 | grep /tmp
    cat     2218 vagrant  cwd    DIR  253,0     4096 1572866 /tmp
    cat     2218 vagrant    1w   REG  253,0        0 1572879 /tmp/test (deleted)

    ```
    >### Еще раз запустим наш процесс, видим что файл снова пишется, можно завершить его работу

    ```

    vagrant@vagrant:/tmp$ fg 1
    cat /dev/urandom > /tmp/test
    ^Z
    [1]+  Stopped                 cat /dev/urandom > /tmp/test
    vagrant@vagrant:/tmp$ lsof -p 2218 | grep /tmp
    cat     2218 vagrant  cwd    DIR  253,0      4096 1572866 /tmp
    cat     2218 vagrant    1w   REG  253,0 745537536 1572879 /tmp/test (deleted)
    vagrant@vagrant:/tmp$ truncate -s 0 /proc/2218/fd/1
    vagrant@vagrant:/tmp$ fg 1
    cat /dev/urandom > /tmp/test
    ^C^C
    vagrant@vagrant:/tmp$
    ```

1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

    >### Zombie-процессы освобождают свои ресурсы, не занимая память. Они всего лишь занимают место в таблице процессов, что потенциально может привести к невозможности запустить новые процессы.

1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

    >### Установили, запустили и увидели следующее

    ```
    vagrant@vagrant:/tmp$  dpkg -L bpfcc-tools | grep sbin/opensnoop
    dpkg-query: package 'bpfcc-tools' is not installed
    Use dpkg --contents (= dpkg-deb --contents) to list archive files contents.
    vagrant@vagrant:/tmp$ sudo apt install bpfcc-tools
    Cvagrant@vagrant:/tmp$ sudo opensnoop-bpfcc -d 1
    PID    COMM               FD ERR PATH
    840    vminfo              6   0 /var/run/utmp
    600    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    600    dbus-daemon        20   0 /usr/share/dbus-1/system-services
    600    dbus-daemon        -1   2 /lib/dbus-1/system-services
    600    dbus-daemon        20   0 /var/lib/snapd/dbus-1/system-services/
    vagrant@vagrant:/tmp$
    ```

1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

    >### Системный вызов называется так же `uname`, версию ядрая можно узнать в `/proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}`.

    ```
           uname() returns system information in the structure pointed to by buf.  The utsname struct is defined in <sys/utsname.h>:

           struct utsname {
               char sysname[];    /* Operating system name (e.g., "Linux") */
               char nodename[];   /* Name within "some implementation-defined
                                     network" */
               char release[];    /* Operating system release (e.g., "2.6.28") */
               char version[];    /* Operating system version */
               char machine[];    /* Hardware identifier */
           #ifdef _GNU_SOURCE
               char domainname[]; /* NIS or YP domain name */
           #endif
           };

           Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.
    ```

1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
