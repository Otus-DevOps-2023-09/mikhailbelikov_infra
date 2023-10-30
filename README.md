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
