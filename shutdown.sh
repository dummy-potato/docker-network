#!/bin/bash

#####################################################
#####################################################
# HOW TO USE
# 
# $ ./shutdown.sh
# 
#####################################################
#####################################################
# Reset
RESET='\033[0m';           # Text Reset
# Regular Colors
BLACK='\033[0;30m';        # Black
RED='\033[0;31m';          # Red
GREEN='\033[0;32m';        # Green
YELLOW='\033[0;33m';       # Yellow
BLUE='\033[0;34m';         # Blue
PURPLE='\033[0;35m';       # Purple
WHITE='\033[0;37m';        # White

# removes network
__remove_network() {
    echo -e "${BLUE}Removing docker networks ..........${RESET}";
    export $(cat .env | xargs);
    NETWORK_LIST="${NETWORK_LIST//,/ }";
    __delete $NETWORK_LIST;
}

# deletes network if not exist
# skips if it does
# @param networkList
__delete() {
    for networkname in "${@:1}"
    do
        if ! [ -z "$(docker network ls --filter name=^"${networkname}"$ --format="{{ .Name }}")" ]
        then
            docker network rm "$networkname" &> /dev/null;
            echo -e "${GREEN}Docker network '${networkname}' deleted.${RESET}";
        else
            echo -e "${YELLOW}Docker network '${networkname}' does not exist.${RESET}";
        fi
    done
}

__remove_network;