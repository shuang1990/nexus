#!/bin/bash

set -e

prj_path=$(cd $(dirname $0); pwd -P)
SCRIPTFILE=`basename $0`

devops_prj_path="$prj_path/devops"

nexus_image=sonatype/nexus3
nexus_container=nexus

base_do_init=0
source $devops_prj_path/base.sh

function run() {
    local data_path='/opt/data/nexus'
    ensure_dir "$data_path"

    local args='--restart=always'
    args="$args -p 11681:8081"
    args="$args -p 11682:8082"
    args="$args -v $data_path:/nexus-data"
    run_cmd "docker run -d $args -h $nexus_container --name $nexus_container $nexus_image"
}

function stop() {
    stop_container $nexus_container
}

function restart() {
    stop
    run
}

function help() {
	cat <<-EOF
    
    Usage: mamanger.sh [options]
            
        Valid options are:

            run
            stop
            restart
            
            help                      show this help message and exit

EOF
}
ALL_COMMANDS="run stop restart"
list_contains ALL_COMMANDS "$action" || action=help
$action "$@"
