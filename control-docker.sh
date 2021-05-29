#!/bin/sh

case "$1" in
  setup)
    docker-compose up -d
    ;;
  status)
    docker ps --format 'table {{.Names}}\t{{.State}}'
    ;;
  pid)
    for i in $(docker container ls --format "{{.ID}}"); do docker inspect -f '{{.Name}} {{.State.Pid}}' $i; done
    ;;
  stop)
    for i in $(docker container ls --format "{{.ID}}"); do docker stop $i; done
    ;;
  destroy)
    docker-compose down #Can do docker container rm
    ;;
  *)
    echo "Usage: $0 {setup|stop|status|destroy|pid}"
esac