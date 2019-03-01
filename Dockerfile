FROM arm32v6/python:3.6-alpine3.6
EXPOSE 5232
VOLUME /collections /config

ADD entrypoint.py README.md /

ENV RADICALE_VERSION=2.1.11
RUN apk add --no-cache apr apr-util libffi su-exec tini \
 && apk add --no-cache --virtual .build-deps apache2-utils ca-certificates build-base libffi-dev \
 && pip install --no-cache-dir bcrypt dulwich passlib radicale==$RADICALE_VERSION \
 && cp /usr/bin/htdigest /usr/bin/htpasswd /tmp \
 && adduser -s /bin/false -D -H radicale \
 && apk del .build-deps \
 && mv /tmp/htdigest /tmp/htpasswd /usr/bin

 ENTRYPOINT ["/sbin/tini", "--"]
 CMD ["/entrypoint.py"]
