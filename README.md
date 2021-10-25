# nexus-thin-edge
Device certificate management


## Demo

### User experience

```
sudo tedge cert show
./tedge cert request c8y latest.stage.c8y.io t398942 didier demo-device-001
sudo tedge cert show
sudo tedge connect c8y
```


### Behind the scene

The first step is to create a signing request

```
./create-signing-request.sh didier-device t398942 didier-device.key didier-device.csr
./decode-csr.sh didier-device.csr | less
```

Then one needs to request for a password

```
curl --user t398942/didier:$(read -s -p "Password: "; echo $REPLY) https://latest.stage.c8y.io/service/tedge-device-registry/register/didier-device
```

This password can then be used to authenticate the signing request

```
./post-signing-request.sh didier-device.csr thinedge 543210 >didier-device.pem
./decode-pem.sh didier-device.pem | less
```

