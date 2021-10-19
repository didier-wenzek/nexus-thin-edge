Pre-requisite: the system_officer.p12 file


Build the docker image, then the micro-service zip.

```
$ cp ../scripts/post-registration.sh .
$ cp ../scripts/system_officer_38_sag.p12 .
$ docker build -t tedge-device-registry .
$ docker save tedge-device-registry >image.tar
$ zip tedge-device-registry cumulocity.json image.tar
```

Install the micro-service.
* In the UI Administration application, navigate to Applications > Own applications > Add application > Upload microservice.
* Drop the ZIP file of the microservice and then click Subscribe.
