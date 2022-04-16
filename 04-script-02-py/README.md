# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?
	* Как получить для переменной c значение 12?
	* Как получить для переменной c значение 3?

	>### Ответ:
	| Вопрос  | Ответ |
	| ------------- | ------------- |
	| Какое значение будет присвоено переменной `c`?  | При выполнении команды `1 + '2'` произойдём ошибка, так как Python является типизируемым языком программирования. Из-за чего нельзя складывать целые числа и строки между собой.  |
	| Как получить для переменной `c` значение 12?  | Для получения **строкового** значения `'12'` необходимо выполнить приведения типов: `str(1) + '2' = '12'` |
	| Как получить для переменной `c` значение 3?  | По аналогии с предыдущим пунктом: `1 + int('2') = 3` |

1. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```

	>### Ответ:
	```python
	#!/usr/bin/env python3

	import os

	# добавляем команды для получения абсолютного пути 
	bash_command_path = ["cd ~/netology/sysadm-homeworks", "pwd"]
	path = os.popen(' && '.join(bash_command_path)).read().rstrip() + '/'

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
	#is_change = False строка не используется
	for result in result_os.split('\n'):
		if result.find('modified') != -1:
			prepare_result = result.replace('\tmodified:   ', '')
			print(path + prepare_result)
			# убираем break
			# break 
	```

1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

	>### Ответ:
	```python
	#!/usr/bin/env python3

	import os
	import sys

	if len(sys.argv) < 2:
		sys.exit()
		
	bash_command_path = [f"cd {sys.argv[1]}", "pwd"]
	path = os.popen(' && '.join(bash_command_path)).read().rstrip() + '/'

	bash_command = [f"cd {sys.argv[1]}", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
	
	for result in result_os.split('\n'):
		if result.find('modified') != -1:
			prepare_result = result.replace('\tmodified:   ', '')
			print(path + prepare_result)
	```

1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

	>### Ответ:

	```python
	import socket
	import time

	hosts = {"drive.google.com": "192.168.0.1",
			"mail.google.com": "172.16.0.1",
			"google.com": "10.0.0.1", }

	while True:
		time.sleep(15)
		for host in hosts.keys():
			ip = hosts[host]
			new_ip = socket.gethostbyname(host)
			if new_ip != ip:
				print("[ERROR] {} IP mismatch: {} {}".format(host, ip, new_ip))
				hosts[host] = new_ip
			else:
				print("{} - {}".format(host, ip))
	```

