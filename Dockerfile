FROM alpine:latest
MAINTAINER Simon <shuang@coremail.cn>

COPY _root /

RUN sh /home/kubernetes/bin/image-init.sh

LABEL name="Helm & Kubectl Image" \
    vendor="Coremail Lunkr" \
    license="(None)" \
    build-date="20181224"


ENTRYPOINT ["/bin/sh", "/home/kubernetes/bin/entrypoint.sh"]
