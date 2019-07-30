FROM alpine:3.10.1
VOLUME /tmp
RUN apk --no-cache add curl

ADD execute.sh execute.sh
RUN chmod +x execute.sh
ENTRYPOINT ["/bin/sh", "./execute.sh"]
