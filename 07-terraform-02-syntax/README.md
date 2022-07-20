# Домашнее задание к занятию "7.2. Облачные провайдеры и синтаксис Терраформ."

Зачастую разбираться в новых инструментах гораздо интересней понимая то, как они работают изнутри. 
Поэтому в рамках первого *необязательного* задания предлагается завести свою учетную запись в AWS (Amazon Web Services).

## Задача 1. Регистрация в aws и знакомство с основами (необязательно, но крайне желательно).

Остальные задания можно будет выполнять и без этого аккаунта, но с ним можно будет увидеть полный цикл процессов. 

AWS предоставляет достаточно много бесплатных ресурсов в первых год после регистрации, подробно описано [здесь](https://aws.amazon.com/free/).
1. Создайте аккаут aws.
1. Установите c aws-cli https://aws.amazon.com/cli/.
1. Выполните первичную настройку aws-sli https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html.
1. Создайте IAM политику для терраформа c правами
    * AmazonEC2FullAccess
    * AmazonS3FullAccess
    * AmazonDynamoDBFullAccess
    * AmazonRDSFullAccess
    * CloudWatchFullAccess
    * IAMFullAccess
1. Добавьте переменные окружения 
    ```
    export AWS_ACCESS_KEY_ID=(your access key id)
    export AWS_SECRET_ACCESS_KEY=(your secret access key)
    ```
1. Создайте, остановите и удалите ec2 инстанс (любой с пометкой `free tier`) через веб интерфейс. 

В виде результата задания приложите вывод команды `aws configure list`.

>### Ответ:

> Создали аккаут aws, установили `aws-cli` и выполнили первоначальную настройку `aws-cli`.
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ aws --version
aws-cli/1.25.30 Python/3.8.10 Linux/5.4.0-120-generic botocore/1.27.30

user@user-Aspire-5750G:~/netology-dvpspdc3$ aws configure list
      Name                    Value             Type    Location
      ----                    -----             ----    --------
   profile                <not set>             None    None
access_key     ****************3YNR shared-credentials-file    
secret_key     ****************CGXC shared-credentials-file    
    region             eu-central-1      config-file    ~/.aws/config
```
> Создали IAM политику для терраформа c правами
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3$ aws iam list-users
{
    "Users": [
        {
            "Path": "/",
            "UserName": "jjvod",
            "UserId": "xxxxxxxxxxxxxxxx3WM3",
            "Arn": "arn:aws:iam::001350100395:user/jjvod",
            "CreateDate": "2022-07-18T13:14:24Z"
        }
    ]
}
user@user-Aspire-5750G:~/netology-dvpspdc3$ aws iam list-attached-user-policies --user-name jjvod
{
    "AttachedPolicies": [
        {
            "PolicyName": "AmazonRDSFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
        },
        {
            "PolicyName": "AmazonEC2FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
        },
        {
            "PolicyName": "IAMFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/IAMFullAccess"
        },
        {
            "PolicyName": "AmazonS3FullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonS3FullAccess"
        },
        {
            "PolicyName": "CloudWatchFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/CloudWatchFullAccess"
        },
        {
            "PolicyName": "AmazonDynamoDBFullAccess",
            "PolicyArn": "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
        }
    ]
}
user@user-Aspire-5750G:~/netology-dvpspdc3$ 
```

> Создали, остановили и удалили ec2 инстанс через веб интерфейс. 
```bash

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
5 package(s) needed for security, out of 14 available
Run "sudo yum update" to apply all updates.
[ec2-user@ip-172-31-32-164 ~]$ uname -a
Linux ip-172-31-32-164.eu-central-1.compute.internal 5.10.118-111.515.amzn2.x86_64 #1 SMP Wed May 25 22:12:19 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
```

## Задача 1 (Вариант с Yandex.Cloud). Регистрация в ЯО и знакомство с основами (необязательно, но крайне желательно).

1. Подробная инструкция на русском языке содержится [здесь](https://cloud.yandex.ru/docs/solutions/infrastructure-management/terraform-quickstart).
2. Обратите внимание на период бесплатного использования после регистрации аккаунта. 
3. Используйте раздел "Подготовьте облако к работе" для регистрации аккаунта. Далее раздел "Настройте провайдер" для подготовки
базового терраформ конфига.
4. Воспользуйтесь [инструкцией](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs) на сайте терраформа, что бы 
не указывать авторизационный токен в коде, а терраформ провайдер брал его из переменных окружений.

>### Ответ: 
> Уже выполнили в предыдущих ДЗ
```bash
user@user-Aspire-5750G:~$ yc config profiles list
default ACTIVE
srv-test

user@user-Aspire-5750G:~$ yc config list
token: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-Kw
cloud-id: b1gsb5e2dh80gh2m64v3
folder-id: b1g6kuq3urjf6j4jq2s8
compute-default-zone: ru-central1-a
```

## Задача 2. Созданием ec2 через терраформ. 

1. В каталоге `terraform` вашего основного репозитория, который был создан в начале курсе, создайте файл `main.tf` и `versions.tf`.
1. Зарегистрируйте провайдер для [aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). В файл `main.tf` добавьте
блок `provider`, а в `versions.tf` блок `terraform` с вложенным блоком `required_providers`. Укажите любой выбранный вами регион 
внутри блока `provider`.
1. Внимание! В гит репозиторий нельзя пушить ваши личные ключи доступа к аккаунта. Поэтому в предыдущем задании мы указывали
их в виде переменных окружения. 
1. В файле `main.tf` воспользуйтесь блоком `data "aws_ami` для поиска ami образа последнего Ubuntu.  
1. В файле `main.tf` создайте рессурс [ec2 instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance).
Постарайтесь указать как можно больше параметров для его определения. Минимальный набор параметров указан в первом блоке 
`Example Usage`, но желательно, указать большее количество параметров. 
1. Добавьте data-блоки `aws_caller_identity` и `aws_region`.
1. В файл `outputs.tf` поместить блоки `output` с данными об используемых в данный момент: 
    * AWS account ID,
    * AWS user ID,
    * AWS регион, который используется в данный момент, 
    * Приватный IP ec2 инстансы,
    * Идентификатор подсети в которой создан инстанс.  
1. Если вы выполнили первый пункт, то добейтесь того, что бы команда `terraform plan` выполнялась без ошибок. 
  
 
>### Ответ:

>Создали `ec2` [main.tf](terraform/main.tf)
```tf
# AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# AMI Data
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# AWS Instance Resources
resource "aws_instance" "web" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3.large"
  cpu_core_count       = 1
  cpu_threads_per_core = 1
  monitoring           = true

  tags = {
    org  = "netology"
    name = "ubuntu_instance"
  }
}

# Additional Data
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

```
> Запустили сборку на `aws`
```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-02-syntax/terraform$ terraform apply
data.aws_caller_identity.current: Reading...
data.aws_region.current: Reading...
data.aws_ami.ubuntu: Reading...
data.aws_region.current: Read complete after 0s [id=eu-central-1]
data.aws_ami.ubuntu: Read complete after 0s [id=ami-06cac34c3836ff90b]
data.aws_caller_identity.current: Read complete after 1s [id=001350100395]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-06cac34c3836ff90b"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = (known after apply)
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = 1
      + cpu_threads_per_core                 = 1
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.large"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = true
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "name" = "ubuntu_instance"
          + "org"  = "netology"
        }
      + tags_all                             = {
          + "name" = "ubuntu_instance"
          + "org"  = "netology"
        }
      + tenancy                              = (known after apply)
      + user_data                            = (known after apply)
      + user_data_base64                     = (known after apply)
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification {
          + capacity_reservation_preference = (known after apply)

          + capacity_reservation_target {
              + capacity_reservation_id = (known after apply)
            }
        }

      + ebs_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + snapshot_id           = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }

      + enclave_options {
          + enabled = (known after apply)
        }

      + ephemeral_block_device {
          + device_name  = (known after apply)
          + no_device    = (known after apply)
          + virtual_name = (known after apply)
        }

      + metadata_options {
          + http_endpoint               = (known after apply)
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = (known after apply)
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface {
          + delete_on_termination = (known after apply)
          + device_index          = (known after apply)
          + network_interface_id  = (known after apply)
        }

      + root_block_device {
          + delete_on_termination = (known after apply)
          + device_name           = (known after apply)
          + encrypted             = (known after apply)
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags                  = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_private_ip = (known after apply)
  + instance_subnet_id  = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_instance.web: Creating...
aws_instance.web: Still creating... [10s elapsed]
aws_instance.web: Creation complete after 15s [id=i-09b91b24da18844fb]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

account_id = "001350100395"
caller_user = "AIDAQAUDY4WVXEDD43WM3"
current_aws_region = "eu-central-1"
instance_private_ip = "172.31.8.78"
instance_subnet_id = "subnet-00906997b51694592"
```

> Удалили инстанс `ec2`

```bash
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-02-syntax/terraform$ terraform destroy
data.aws_caller_identity.current: Reading...
data.aws_region.current: Reading...
data.aws_ami.ubuntu: Reading...
data.aws_region.current: Read complete after 0s [id=eu-central-1]
data.aws_ami.ubuntu: Read complete after 1s [id=ami-06cac34c3836ff90b]
aws_instance.web: Refreshing state... [id=i-09b91b24da18844fb]
data.aws_caller_identity.current: Read complete after 1s [id=001350100395]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.web will be destroyed
  - resource "aws_instance" "web" {
      - ami                                  = "ami-06cac34c3836ff90b" -> null
      - arn                                  = "arn:aws:ec2:eu-central-1:001350100395:instance/i-09b91b24da18844fb" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "eu-central-1c" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 1 -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-09b91b24da18844fb" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t3.large" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = true -> null
      - primary_network_interface_id         = "eni-0605022e51c1993b4" -> null
      - private_dns                          = "ip-172-31-8-78.eu-central-1.compute.internal" -> null
      - private_ip                           = "172.31.8.78" -> null
      - public_dns                           = "ec2-18-196-133-184.eu-central-1.compute.amazonaws.com" -> null
      - public_ip                            = "18.196.133.184" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [
          - "default",
        ] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-00906997b51694592" -> null
      - tags                                 = {
          - "name" = "ubuntu_instance"
          - "org"  = "netology"
        } -> null
      - tags_all                             = {
          - "name" = "ubuntu_instance"
          - "org"  = "netology"
        } -> null
      - tenancy                              = "default" -> null
      - vpc_security_group_ids               = [
          - "sg-04cbda1045b4596a0",
        ] -> null

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_put_response_hop_limit = 1 -> null
          - http_tokens                 = "optional" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/sda1" -> null
          - encrypted             = false -> null
          - iops                  = 100 -> null
          - tags                  = {} -> null
          - throughput            = 0 -> null
          - volume_id             = "vol-09ea3c21e3f915594" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp2" -> null
        }
    }

Plan: 0 to add, 0 to change, 1 to destroy.

Changes to Outputs:
  - account_id          = "001350100395" -> null
  - caller_user         = "AIDAQAUDY4WVXEDD43WM3" -> null
  - current_aws_region  = "eu-central-1" -> null
  - instance_private_ip = "172.31.8.78" -> null
  - instance_subnet_id  = "subnet-00906997b51694592" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.web: Destroying... [id=i-09b91b24da18844fb]
aws_instance.web: Still destroying... [id=i-09b91b24da18844fb, 10s elapsed]
aws_instance.web: Still destroying... [id=i-09b91b24da18844fb, 20s elapsed]
aws_instance.web: Still destroying... [id=i-09b91b24da18844fb, 30s elapsed]
aws_instance.web: Still destroying... [id=i-09b91b24da18844fb, 40s elapsed]
aws_instance.web: Destruction complete after 42s

Destroy complete! Resources: 1 destroyed.
user@user-Aspire-5750G:~/netology-dvpspdc3/07-terraform-02-syntax/terr
```

