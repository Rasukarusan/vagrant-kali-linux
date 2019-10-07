![top](https://cdn-ak.f.st-hatena.com/images/fotolife/r/rasukarusan/20191006/20191006172210.png)

## Overview

vagrant kali-linux.
provision by ansible.

## Versions

### Vagrant

```shell
$ vagrant -v
Vagrant 2.2.3

$ VBoxManage -v
5.2.26r128414
```
### Box Kali-Linux

|  Key  | Value   |
| ---- | ---- |
|  Destribution  |  kalilinux/rolling  |
|  Version       |  2019.3.0           |


## Wifi Adapter

[Alfa AWUS036NEH (Chipset : Ralink 3070)](https://www.alfa.com.tw/products_detail/10.htm)

## Article

https://www.rasukarusan.com/entry/2019/10/06/171811

## Tips

### Due to the version of vagrant or vbox, the error may be output when `vagrant up`.

```shell
$ vagrant up

The box 'kalilinux/rolling' could not be found or
could not be accessed in the remote catalog. If this is a private
box on HashiCorp's Atlas, please verify you're logged in via
`vagrant login`. Also, please double-check the name. The expanded
URL and error message are shown below:

URL: ["https://atlas.hashicorp.com/kalilinux/rolling"]
Error: The requested URL returned error: 404 Not Found
```

Add this line to the top of Vagrantfile.
```shell
Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')
```

You can `vagrant up`.

### Vagrant login as root by default

Write this line to bottom of `.bashrc` of **vagrant user**.

```shell
vagrant@kali:~$ vim ~/.bashrc

# write this bottom of .bashrc
sudo su -
```

You will login as root when `vagrant ssh`.
```shell
~/Desktop/kali-linux  master ✗
$ vagrant ssh
Linux kali 5.2.0-kali3-amd64 #1 SMP Debian 5.2.17-1kali1 (2019-09-27) x86_64

The programs included with the Kali GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Kali GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Mon Oct  7 08:18:00 2019 from 10.0.2.2

root@kali:~
```
