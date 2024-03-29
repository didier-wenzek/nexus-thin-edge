# nexus-thin-edge

A POC to evaluate device certificate creation with [thin-edge.io](https://github.com/thin-edge/thin-edge.io),
[Cumulocity IoT](https://www.softwareag.cloud/site/product/cumulocity-iot.html#/)
 and [Nexus Go IoT](https://www.nexusgroup.com/solutions/online-services/iot/).

This repository contains no credentials:
you will need an account on Cumulocity and another one on Nexus to run the demo. 

## Demo

### Preparation

Check no certificate, no connection

```
sudo tedge disconnect c8y
sudo tedge config set device.cert.path /etc/tedge/device-certs/device-cert.pem
sudo tedge config set device.key.path /etc/tedge/device-certs/device-key.pem
```

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

Then one needs to request Cumulocity for a password

```
curl --user t398942/didier:$(read -s -p "Password: "; echo $REPLY) https://latest.stage.c8y.io/service/tedge-device-registry/register/didier-device
```

This password can then be used to authenticate the signing request

```
curl -s -k -H "Content-Type: application/pkcs10" --data-binary @didier-device.csr --digest --user USER:PASS URL
```

```
./post-signing-request.sh didier-device.csr thinedge 543210 >didier-device.pem
./decode-pem.sh didier-device.pem | less
```

