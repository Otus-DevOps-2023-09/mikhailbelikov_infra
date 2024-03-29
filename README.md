# mikhailbelikov_infra
mikhailbelikov Infra repository


## Знакомство с облачной инфраструктурой и облачными сервисами:
### Данные для подключения:
```
bastion_IP = 158.160.110.167
someinternalhost_IP = 10.128.0.17
```

### Подключение в однку команду:
```
ssh -A -J appuser@158.160.110.167 appuser@10.128.0.17
```
### Подключение по alias к Хосту, с помощью настроек файла ~/.ssh/config:
```
Host bastion
    HostName 158.160.110.167
    User appuser
    IdentityFile ~/appuser

Host someinternalhost
    HostName 10.128.0.17
    User appuser
    ProxyJump bastion
```
Далее подключение будет производиться командыми:
```
ssh bastion
ssh someinternalhost
```
### Сертификат для VPN-сервера
https://vpn.belikov.tech/


## Основные сервисы Yandex Cloud

### Основное задание:
testapp_IP = 84.252.130.27 
testapp_port = 9292 

### Дополнительное задание:
Startup config - yc-config.txt, с его помощью происходит закгрузка и исполнение скриптов для полноценного развертывания приложения.
Команда CLI для развертки ВМ с применением конфига:

yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=yc-config.txt


## Модели управления инфраструктурой. Подготовка образов с помощью Packer   

### Основное задание:  
Добавлен сервисный аккаунт с ролью EDITOR
На первом этапе создан шаблон ubuntu16.json, с его помощью создается образ Ubuntu с предустановленными Ruby и MongoDB
Далее была развернута ВМ из данного образа, внутри ВМ была осуществленна установка Reddit
В файле variables.json.example описаны переменные для шаблона
Создан .gitignore и в него добавлен variables.json

### Дополнительное задание:
immutable.json - шаблон для создания образа с предустановленным Ruby и MongoDB, так же с запуском Reddit.  
create-reddit-vm.sh - создает ВМ из образа с запущенным Reddit.


## Знакомство с Terraform

### Основное задание:
Добавлен отдельный сервисный аккаунт в Yandex Cloud для terraform
main.tf - разворачивает ВМ с предустановленным Ruby и MongoDB, так же с запуском Reddit.
Добавлен файл outputs.tf, отвечающий за вывод переменных, после создания ВМ.
Догбавлены файлы variables.tf и terraform.tfvars для выноса переменных.
### Дополнительное задание:
lb.tf - отвечает за деплой HTTP балансировщика + создание группы из 2 ВМ с Reddit на борту.
main.tf - добавлена переменная count, для создания двух одинаковых инстансов


## Принципы организации инфраструктурного кода и работа над инфраструктурой в команде на примере Terraform  

### Основное задание:  
main.tf - добалено создание отдельной сети и подсети, а так же автоматическое подключение при создание ВМ.
Созданы образы через Packer с приложением и ДБ.
main.tf - разбит на модули
Созданы модули app и db
Созданы подпроекты prod и stage
Добавлены перменные, а так же настройки для prod и stage

### Дополнительное задание:  
install_mongodb.sh - изменен для возможности подключения из вне, собран доп. образ.
Добавлены необходимые provisioner в модуль app:
Для копирования файла systemd
remote-exec, который добавляет переменную с указанием внутреннего адреса ВМ с ДБ
Добавлен provisioner для выполнения скрипта деплоя приложения.
Удалено создание внешнего IP адреса, outputs теперь выдает только внутренний IP
Теперь создаются две ВМ, приложение и БД, БД без внешнего адреса и приложенрие доступное по внешнему IP и порту 9292

Создан бакет в YC для хранения state файла  
storage-bucket.tf - удаленный бэкенд.
*.tfstate создается и хранится в бакете.
При тестах получаем - No changes. Your infrastructure matches the configuration Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
Настройки добавлены в подпроекты prod и stage.

## Управление конфигурацией. Знакомство с Ansible 

### Основное задание:  
Установка ansible  
Настройка файла inventory
Выполнен тест модулей ansible без плейбуков
Настроен конфиг ansible.cfg 
В файл inventory добавлены группы хостов
Протестирован inventory.yaml
Выполнены модули command, shell, service, git 
Создан плейбук clone.yml
Успешно выполнен плейбук clone.yaml
 
## Продолжение знакомства с Ansible: templates, handlers, dynamic inventory, vault, tags  

### Основное задание:  
Создан плейбук reddit_app.yml с настройкой MongoDB
Добавлены handlers
Создан плейбук reddit_app2.yml, для тестирования хостов и тегов
Разбиты плейбуки и создан мастер плейбук site.yml, который позволяет полностью развернуть приложение
reddit_app.yml ➡ reddit_app_one_play.yml
reddit_app2.yml ➡ reddit_app_multiple_plays.yml

### Дополнительное задание: 
Установлен yc_compute
Создан inventory_yc.yaml
Командой ansible-inventory --list --yaml получаем актуальный инвентори из YC по тегу
Созданы packer_app.yml и packer_db.yml
Изменен provisions в parcker конфигах
Созданы новые образы, проверена работоспособность

## Ansible: работа с ролями и окружениями

### Основное задание:
Переносим созданные плейбуки в раздельные роли
Описываем два окружения
Используем коммьюнити роль nginx
Используем Ansible Vault для наших окружений
