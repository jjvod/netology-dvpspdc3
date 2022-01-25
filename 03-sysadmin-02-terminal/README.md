# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
	
	>###  `cd` это встроенна в оболочку команда. Не является файлом/процессом. Есть тип встроенных (builtin) команд которые необходимо встроить воболочку согласно POSIX стандарту, среди которых `cd`.
	
	```
	root@ubuntu:~# type cd
	cd is a shell builtin
	```
1. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l`? `man grep` поможет в ответе на этот вопрос. Ознакомьтесь с [документом](http://www.smallo.ruhr.de/award.html) о других подобных некорректных вариантах использования pipe.

	>### Можно подсичтать используя ключ `--сount`

	```
	root@ubuntu:~# man grep | grep count | wc -l
	5
	root@ubuntu:~# man grep | grep --count count
	5
	```

1. Какой процесс с PID `1` является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

	>###  В контейнере WSL2 это процесс `init`

	```
	root@ubuntu:~# pstree -hpa
	init,1
	├─init,8
	│   ├─apache2,177 -k start
	│   │   ├─apache2,187 -k start
	│   │   ├─apache2,188 -k start
	│   │   ├─apache2,189 -k start
	│   │   ├─apache2,190 -k start
	│   │   └─apache2,191 -k start
	│   ├─postgres,224 -D /var/lib/postgresql/12/main -c config_file=/etc/postgresql/12/main/postgresql.conf
	│   │   ├─postgres,226
	│   │   ├─postgres,227
	│   │   ├─postgres,228
	│   │   ├─postgres,229
	│   │   ├─postgres,230
	│   │   └─postgres,231
	│   └─sshd,136
	├─init,259
	│   └─init,260
	│       └─bash,261
	│           └─pstree,509 -hpa
	└─{init},6
	root@ubuntu:~# lsb_release -a
	No LSB modules are available.
	Distributor ID: Ubuntu
	Description:    Ubuntu 20.04.3 LTS
	Release:        20.04
	Codename:       focal
	root@ubuntu:~#)
	```

	>###  Внутри виртуальной машины используется `systemd`

	```
	vagrant@vagrant:~$ sudo pstree -hpa
	systemd,1
	├─VBoxService,863 --pidfile /var/run/vboxadd-service.sh
	│   ├─{VBoxService},865
	│   ├─{VBoxService},866
	│   ├─{VBoxService},867
	│   ├─{VBoxService},868
	│   ├─{VBoxService},869
	│   ├─{VBoxService},870
	│   ├─{VBoxService},871
	│   └─{VBoxService},874
	├─accounts-daemon,598
	...
	```

1. Как будет выглядеть команда, которая перенаправит вывод stderr `ls` на другую сессию терминала?

	>### Перенаправим вывод ошибок в другую сессию терминала перенаправление вывода `2>/dev/pts/1`

	```
	vagrant@vagrant:~$ tty
	/dev/pts/0
	vagrant@vagrant:~$ sudo mkdir ./test
	vagrant@vagrant:~$ sudo touch ./test/test
	vagrant@vagrant:~$ ls ./test/
	test
	vagrant@vagrant:~$ sudo chmod 700 ./test
	vagrant@vagrant:~$ ls ./test/
	ls: cannot open directory './test/': Permission denied
	vagrant@vagrant:~$ ls ./test/ 2>/dev/pts/1
	vagrant@vagrant:~$
	```

	>### Вывод на втором теминале

	```
	vagrant@vagrant:~$ tty
	/dev/pts/1
	vagrant@vagrant:~$ ls: cannot open directory './test/': Permission denied
	```

1. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

	>### Конечно для этого воспользуемся перенаправлением потоков

	```
	vagrant@vagrant:~$ uname > input.txt
	vagrant@vagrant:~$ cat <input.txt >output.txt
	vagrant@vagrant:~$ cat output.txt
	Linux
	vagrant@vagrant:~$
	```
1. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?
	 >### Да, получится. Пример приводил в задании 4. Другой пример: `echo 'Kilroy was here' > /dev/pts/1`.
1. Выполните команду `bash 5>&1`. К чему она приведет? Что будет, если вы выполните `echo netology > /proc/$$/fd/5`? Почему так происходит?

	>### Команда `bash 5>&1` создаёт дескриптор с условным номером 5 и связывает его с std out текущего процесса. При выполнении команды `echo netology > /proc/$$/fd/5` выведится слово `netology`.

1. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от `|` на stdin команды справа.
Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

	>### Получилось
	
	```
	vagrant@vagrant:~$ ls ./test/ 5>&2 2>&1 1>&5 | sed 's/test/sed/'
	ls: cannot open directory './sed/': Permission denied
	vagrant@vagrant:~$ ls . 5>&2 2>&1 1>&5 | sed 's/test/sed/'
	input.txt  output.txt  test
	vagrant@vagrant:~$
	```
1. Что выведет команда `cat /proc/$$/environ`? Как еще можно получить аналогичный по содержанию вывод?
	>### Команда выводит переменные окружения текущей сессии. Аналог — `env`.
1. Используя `man`, опишите что доступно по адресам `/proc/<PID>/cmdline`, `/proc/<PID>/exe`.

	>### `/proc/<PID>/cmdline` — файл, содержащий полную командную строку для процесса.
	>### `/proc/<PID>/exe` — файл, содержащий символьную ссылку на фактический путь к процессу

	```
	vagrant@vagrant:~$ man proc | grep -n -B 1 -A 2 cmdline
	vagrant@vagrant:~$ man proc | grep -n -B 1 -A 2 -F '/proc/[pid]/exe'
	```
1. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью `/proc/cpuinfo`.

	>### Версия SSE 4.2

	```
	vagrant@vagrant:~$ cat /proc/cpuinfo | grep sse
	flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 pcid sse4_1 sse4_2 hypervisor lahf_lm invpcid_single pti fsgsbase invpcid md_clear flush_l1d arch_capabilities
	flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 pcid sse4_1 sse4_2 hypervisor lahf_lm invpcid_single pti fsgsbase invpcid md_clear flush_l1d arch_capabilities
	vagrant@vagrant:~$
	```
1. При открытии нового окна терминала и `vagrant ssh` создается новая сессия и выделяется pty. Это можно подтвердить командой `tty`, которая упоминалась в лекции 3.2. Однако:

    ```bash
	vagrant@netology1:~$ ssh localhost 'tty'
	not a tty
    ```

	>### Необходимо принудительно выделить rty с помощью флага `-t`.

	```
	vagrant@vagrant:~$ ssh localhost tty
	vagrant@localhost's password:
	not a tty
	vagrant@vagrant:~$ ssh -t localhost tty
	vagrant@localhost's password:
	/dev/pts/2
	Connection to localhost closed.
	vagrant@vagrant:~$
	```

1. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись `reptyr`. Например, так можно перенести в `screen` процесс, который вы запустили по ошибке в обычной SSH-сессии.
1. `sudo echo string > /root/new_file` не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без `sudo` под вашим пользователем. Для решения данной проблемы можно использовать конструкцию `echo string | sudo tee /root/new_file`. Узнайте что делает команда `tee` и почему в отличие от `sudo echo` команда с `sudo tee` будет работать.
