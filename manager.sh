#!/bin/bash

set -e

prj_path=$(cd $(dirname $0); pwd -P)
SCRIPTFILE=`basename $0`

devops_prj_path="$prj_path/devops"

nexus3_image=sonatype/nexus3
nexus3_container=nexus3

base_do_init=0
source $devops_prj_path/base.sh

function run_nexus3() {
    local data_path='/opt/data/nexus3'
    ensure_dir "$data_path"
    run_cmd "chmod a+w $data_path"
    local args=''
    args="$args --dns=8.8.8.8"
    args="$args -v $data_path:/nexus-data"
    run_cmd "docker run -it $args -h $nexus3_container --name $nexus3_container $nexus3_image"
}

function stop_nexus3() {
    stop_container $nexus3_container
}

function restart_nexus3() {
    stop_nexus3
    run_nexus3
}

function help() {
	cat <<-EOF
    
    Usage: mamanger.sh [options]
            
        Valid options are:

            run_nexus3
            stop_nexus3
            restart_nexus3
            
            help                      show this help message and exit

EOF
}
ALL_COMMANDS="run_nexus3 stop_nexus3 restart_nexus3"
list_contains ALL_COMMANDS "$action" || action=help
$action "$@"
