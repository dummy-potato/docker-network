#!/bin/bash

#####################################################
#####################################################
# HOW TO USE
# 
# $ ./boot.sh
#
# Can also be used as cronjob to be run after every server reboot
# $ crontab -e
# type `@reboot DIRECTORY/boot.sh`, wherein the `DIRECTORY` is the location to this script
#
#####################################################
#####################################################
# Reset
RESET='\033[0m';           # Color Reset
# Regular Colors
BLACK='\033[0;30m';        # Black
RED='\033[0;31m';          # Red
GREEN='\033[0;32m';        # Green
YELLOW='\033[0;33m';       # Yellow
BLUE='\033[0;34m';         # Blue
PURPLE='\033[0;35m';       # Purple
WHITE='\033[0;37m';        # White

# boots network
__boot_network() {
    echo -e "${BLUE}Creating docker networks ..........${RESET}";
    export $(cat .env | xargs);
    NETWORK_LIST="${NETWORK_LIST//,/ }";
    __create $NETWORK_LIST;
}

# creates network if not exist
# skips if it does
# @param networkList
__create() {
    for networkname in "${@:1}"
    do
        if [ -z "$(docker network ls --filter name=^"${networkname}"$ --format="{{ .Name }}")" ]
        then
            docker network create "$networkname" &> /dev/null;
            echo -e "${GREEN}Docker network '${networkname}' created.${RESET}";
        else 
            echo -e "${YELLOW}Docker network '${networkname}' already exist.${RESET}";
        fi
    done
}

__boot_network;