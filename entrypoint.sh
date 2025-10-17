#! /bin/sh

echo "Running etesync server ${ETESYNC_VERSION}"

cd /app

if ! [ -e /data/etebase-server-default.ini ] && ! [ -h /data/etebase-server-default.ini ]; then
    cp /app/etebase-server.ini.example /data/etebase-server.ini
fi

mkdir -p /data/media

./manage.py migrate

uvicorn etebase_server.asgi:application --host 0.0.0.0 --port 3735
