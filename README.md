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
Создан .gitignore и в него добавлен variables.json.example

### Дополнительное задание:
immutable.json - шаблон для создания образа с предустановленным Ruby и MongoDB, так же с запуском Reddit.  
create-reddit-vm.sh - создает ВМ из образа с запущенным Reddit.
