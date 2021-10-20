FROM python:alpine3.6

COPY application.py /
COPY post-registration.sh /
COPY system_officer_38_sag.p12 /
RUN pip install flask==0.10.1
RUN apk --no-cache add openssl
RUN apk --no-cache add curl
RUN apk --no-cache add jq

ENTRYPOINT ["python"]
CMD ["-u", "application.py"]
