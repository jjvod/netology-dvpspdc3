# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"

1. Установите средство виртуализации [Oracle VirtualBox](https://www.virtualbox.org/).

	>### Установили VirtualBox

	>![virtualbox image](./img/virtualbox.png)
1. Установите средство автоматизации [Hashicorp Vagrant](https://www.vagrantup.com/).

	>### Установили Vagrant

	>![vagrant image](./img/vagrant.png)

1. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал.

	>### Установили Windows Terminal

	>![Terminal image](./img/terminal.png)

1. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:
	* Создайте директорию, в которой будут храниться конфигурационные файлы Vagrant. В ней выполните `vagrant init`. Замените содержимое Vagrantfile по умолчанию следующим:

	```bash
	Vagrant.configure("2") do |config|
	config.vm.box = "bento/ubuntu-20.04"
	end
	```

	>### Создали, выполнили и изменили содержимое Vagrantfile
	
	>![vagrant-dir image](./img/vagrant-dir.png)

	* Выполнение в этой директории `vagrant up` установит провайдер VirtualBox для Vagrant, скачает необходимый образ и запустит виртуальную машину.

	>### Выполнили `vagrant up`

	> ![vagrant-up image](./img/vagrant-up.png)

	* `vagrant suspend` выключит виртуальную машину с сохранением ее состояния (т.е., при следующем `vagrant up` будут запущены все процессы внутри, которые работали на момент вызова suspend), `vagrant halt` выключит виртуальную машину штатным образом.
	
	>### Выполнили `vagrant up`, `vagrant suspend`, `vagrant up` и `vagrant halt`

	```
	D:\netology\vagrant>vagrant suspend
		==> default: Saving VM state and suspending execution...
	D:\netology\vagrant>vagrant up
		Bringing machine 'default' up with 'virtualbox' provider...
		==> default: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
		==> default: Resuming suspended VM...
		==> default: Booting VM...
		==> default: Waiting for machine to boot. This may take a few minutes...
			default: SSH address: 127.0.0.1:2222
			default: SSH username: vagrant
			default: SSH auth method: private key
		==> default: Machine booted and ready!
		==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
		==> default: flag to force provisioning. Provisioners marked to run always will still run.
	D:\netology\vagrant>vagrant halt
		==> default: Attempting graceful shutdown of VM...
	```

1. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

	>### Все ресурсы можно увидеть на скриншоте

	- CPU - 2 
	- RAM - 1024MB
	- VMEM - 64MB
	- DISK - 64GB

	>![virtualbox image](./img/virtualbox.png)

1. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: [документация](https://www.vagrantup.com/docs/providers/virtualbox/configuration.html). Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

	>### Ознакомились с документацией и внесли правки в Vagrantfile

	```
	config.vm.provider "virtualbox" do |v|
		# чтоб показывал окно виртуал бокса
		v.gui = true 

		#Дадим имя виртальной машине
		v.name = "voevodin_vm"
		
		# Память и количество процессоров
		v.memory = 1024
  		v.cpus = 2
	end
	```

1. Команда `vagrant ssh` из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.

1. Ознакомиться с разделами `man bash`, почитать о настройках самого bash:
    * какой переменной можно задать длину журнала `history`, и на какой строчке manual это описывается?
    * что делает директива `ignoreboth` в bash?
1. В каких сценариях использования применимы скобки `{}` и на какой строчке `man bash` это описано?
1. Основываясь на предыдущем вопросе, как создать однократным вызовом `touch` 100000 файлов? А получилось ли создать 300000? Если нет, то почему?
1. В man bash поищите по `/\[\[`. Что делает конструкция `[[ -d /tmp ]]`
1. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

	```bash
	bash is /tmp/new_path_directory/bash
	bash is /usr/local/bin/bash
	bash is /bin/bash
	```

	(прочие строки могут отличаться содержимым и порядком)
		В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.

1. Чем отличается планирование команд с помощью `batch` и `at`?

1. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.

 