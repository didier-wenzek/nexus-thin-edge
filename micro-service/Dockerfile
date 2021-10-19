FROM python:alpine3.6

COPY application.py /
COPY post-registration.sh /
COPY system_officer_38_sag.p12 /
RUN pip install flask==0.10.1

ENTRYPOINT ["python"]
CMD ["-u", "application.py"]
