# Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательные задания

1. Есть скрипт:
	```bash
	a=1
	b=2
	c=a+b
	d=$a+$b
	e=$(($a+$b))
	```
	* Какие значения переменным c,d,e будут присвоены?
	* Почему?

	>### Ответ:

	| Переменная  | Значение | Обоснование |
	| ------------- | ------------- | ------------- |
	| `c`  | `a+b` | Для переменной `c` мы присваиваем значение строки `a+b` |
	| `d`  | `1+2`  | Для переменной `d` мы так же присваиваем значение строки, но подставляем значения переменных `a`и `b` с помощью симвала `$` |
	| `e`  | `3`  | Для переменной `e` мы присваиваем результат арифметической операции сложения (с помощью симвалов `$(( .. ))`) |

1. На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
	```bash
	while ((1==1)
	do
	curl https://localhost:4757
	if (($? != 0))
	then
	date >> curl.log
	fi
	done
	```
	>### Ответ:

	1. В первой строке скрипта пропущена закрывающая скобка `)`.
	2. Необходимо добавить условие выхода из цикла (`break` или `exit`).
	3. Рекомендуется сделать паузу между запросами чтоб уменьшить количество запросов. Например, 60 секунд. 

	Итоговый скрипт:

	```bash
	while ((1==1))
	do
		curl https://localhost:4757
		if (($? != 0))
		then
			date >> curl.log
		else 
			break
		fi
		sleep 60
	done
	```

1. Необходимо написать скрипт, который проверяет доступность трёх IP: 192.168.0.1, 173.194.222.113, 87.250.250.242 по 80 порту и записывает результат в файл log. Проверять доступность необходимо пять раз для каждого узла.

	>### Ответ:

	```bash
	#!/user/bin/env bash

	ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")
	ports=("80")
	
	for ip in ${ips[@]}
	do
			for i in {1..5}
			do
					for port in ${ports[@]}
					do
						curl -m1 $ip:$port &>/dev/null
						if (($? == 0))
						then
								echo $(date) $ip:$port works >> check_ip.log
						else
								echo $(date) $ip:$port does not work >> check_ip.log
						fi
					done
			done
	done
	```

1. Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается

	>### Ответ:

	```bash
	#!/user/bin/env bash

	ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")
	ports=("80")
	
	for ip in ${ips[@]}
	do
			for i in {1..5}
			do
					for port in ${ports[@]}
					do
						curl -m1 $ip:$port &>/dev/null
						if (($? == 0))
						then
								echo $(date) $ip:$port works >> error.log
								break 
						else
								echo $(date) $ip:$port does not work >> check_ip.log
						fi
					done
			done
	done
	```