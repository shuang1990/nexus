#!/bin/bash

set -e

prj_path=$(cd $(dirname $0); pwd -P)
SCRIPTFILE=`basename $0`

devops_prj_path="$prj_path/devops"

nexus_image=sonatype/nexus3
nexus_container=nexus

base_do_init=0
source $devops_prj_path/base.sh

function run_nexus() {
    local data_path='/opt/data/nexus'
    ensure_dir "$data_path"
    run_cmd "chmod a+w $data_path"

    local args='--restart=always'
    args="$args --dns=8.8.8.8"
    args="$args -p 11681:8081"
    args="$args -v $data_path:/nexus-data"
    run_cmd "docker run -d $args -h $nexus_container --name $nexus_container $nexus_image"
}

function stop_nexus() {
    stop_container $nexus_container
}

function restart_nexus() {
    stop_nexus
    run_nexus
}

function help() {
	cat <<-EOF
    
    Usage: mamanger.sh [options]
            
        Valid options are:

            run_nexus
            stop_nexus
            restart_nexus
            
            help                      show this help message and exit

EOF
}
ALL_COMMANDS="run_nexus stop_nexus restart_nexus"
list_contains ALL_COMMANDS "$action" || action=help
$action "$@"
