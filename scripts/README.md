Basic set of scripts to create device certificates.

Requirements:
* openssl
* curl
* jq
* system_officer_p12 file

The registration authority, i.e. the cloud tenant, has first to register the new device,
assigning a device-id and a user, password pair to be used for the signing request.

```
$ ./post-registration.sh didier-device thinedge 543210
```

The device can then create the CSR and get its certificate,
using the CN, tenant-id, user and password transmitted by the registration authority

```
$ ./create-signing-request.sh didier-device t398942 didier-device.key didier-device.csr
$ ./post-signing-request.sh didier-device.csr thinedge 543210 >didier-device.pem
```

All these certificates are signed by the same signing certificate returned by
```
$ ./get-signing-certificate.sh
```
