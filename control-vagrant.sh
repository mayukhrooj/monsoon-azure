#!/bin/sh

start_local() {
    vagrant up -f Vagrantfile.local
}

start_azure() {
    vagrant up --provider=azure
}

stop_local() {
    vagrant halt -f Vagrantfile.local
}

stop_azure() {
    vagrant halt --provider=azure
}

destroy_local() {
    vagrant destroy -f Vagrantfile.local
}

destroy_azure() {
    vagrant destroy --provider=azure
}

restart_local() {
    vagrant reload -f Vagrantfile.local
}

restart_azure() {
    vagrant reload --provider=azure
}

case "$1" in
  start)
    if [ "$AT" == "vbox" ] 
    then
        start_local
    else
        start_azure
    fi
    ;;
  stop)
    if [ "$AT" == "vbox" ] 
    then
        stop_local
    else
        stop_azure
    fi
    ;;
  destroy)
    if [ "$AT" == "vbox" ] 
    then
        destroy_local
    else
        destroy_azure
    fi
    ;;
  retart)
    if [ "$AT" == "vbox" ] 
    then
        restart_local
    else
        restart_azure
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|destroy}"
esac