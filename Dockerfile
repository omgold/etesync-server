FROM python:3.11.0-alpine

ARG ETESYNC_VERSION

ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1

# install packages and pip requirements first, in a single step,
COPY /requirements.txt /requirements.txt
RUN set -ex ;\
    apk add libpq postgresql-dev --virtual .build-deps coreutils gcc libc-dev libffi-dev make ;\
    pip install -U pip ;\
    pip install --no-cache-dir --progress-bar off -r /requirements.txt ;\
    apk del .build-deps make gcc coreutils ;\
    rm -rf /root/.cache

COPY . /app

RUN set -ex ;\
    mkdir -p /data-static ;\
    cd /app ;\
    mkdir -p /etc/etebase-server ;\
    ln -s /app/etebase-server.ini.example /etc/etebase-server/etebase-server.ini ;\
    ./manage.py collectstatic --noinput; \
    chmod +x entrypoint.sh; \
    ln -sf /data/etebase-server.ini /etc/etebase-server

ENV ETESYNC_VERSION=${ETESYNC_VERSION}
VOLUME /data
EXPOSE 3735

ENTRYPOINT ["/app/entrypoint.sh"]
