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

Due to the version of vagrant or vbox, the error may be output when `vagrant up`.

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
