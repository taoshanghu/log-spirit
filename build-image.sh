#!/usr/bin/env bash
#
# build docker image
#

build()
{
    echo -e "building image: log-pilot:latest\n"

    docker build -t reg.yun-gui.cn/library/log-pilot:latest -f Dockerfile.$1 .
    docker push reg.yun-gui.cn/library/log-pilot:latest
}

build2() {
  echo -e "building image: log-pilot:test\n"
  docker build -t log-pilot:test -f Dockerfile.test .
  docker run -it log-pilot:test
}

case $1 in
fluentd)
    build fluentd
    ;;
test)
    build2
    ;;
*)
    build filebeat
    ;;
esac
