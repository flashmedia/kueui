#!/usr/bin/env bash

USAGE="Usage:\n  c [COMMAND] [ARGS...]\n  c -h|--help\nCommands:\n ps \t\t List all running containers \n pull \t\t Pull service images(containers or specific container with pull <container-name>) \n down \t\t Bring all running containers down \n kill \t\t kill all containers (or specific container with kill <container-name>) \n build \t\t Build all containers (or specific container with build <container-name>) \n rebuild \t\t Rebuild all containers (or specific container with rebuild <container-name>) and restart them \n up \t\t Bring up all containers \n exec \t\t Docker exec into a container \n restart \t Restart a container \n env \t\t Change the environment for docker \n npm \t\t Execute an NPM command specific to a container (i.e c npm app install) or within the context of all Node.js containers (i.e npm all install) \n"

if [ ! -n "$1" ]; then
    printf "Please provide a command. \n${USAGE}"
    exit 1
fi

npm_install_in_container () {

    # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
    local CONTAINERNAME=$1

    # Build the NPM command
    local COMMANDSTR=$2

    printf "\nIn $CONTAINERNAME:"
    printf "\n$COMMANDSTR\n\n"

    # Create a folder if it doesn't exist for the package.json
    mkdir -p /npm/$CONTAINERNAME
    mkdir -p /npm/$CONTAINERNAME/node_modules

    # Make sure the node_modules directory in the target exists
    mkdir -p ./$CONTAINERNAME/root/app/node_modules

    # Empty the directory if it does exist
    rm -rf /npm/$CONTAINERNAME/node_modules/*

    if [ ! -e ./$CONTAINERNAME/root/app/package.json ]; then
        printf "\nError: Could not find a package.json file in the $CONTAINERNAME/root/app directory.\n\n"
        exit 1
    fi

    # Copy the package.json and node_modules across
    cp -f ./$CONTAINERNAME/root/app/package.json /npm/$CONTAINERNAME
    cp -rf ./$CONTAINERNAME/root/app/node_modules/* /npm/$CONTAINERNAME/node_modules

    # Move into the correct directory.
    cd /npm/$CONTAINERNAME

    # Install the node modules
    eval $COMMANDSTR

    # Move back into the `/vagrant` directory.
    cd /vagrant

    # Remove the current node_modules
    rm -rf ./$CONTAINERNAME/root/app/node_modules/*

    # Copy the newly installed ones across, and the package.json
    cp -fr /npm/$CONTAINERNAME/node_modules/* ./$CONTAINERNAME/root/app/node_modules
    cp -f /npm/$CONTAINERNAME/package.json ./$CONTAINERNAME/root/app
    if [ -e /npm/$CONTAINERNAME/node_modules/.bin ]; then
        mkdir -p ./$CONTAINERNAME/root/app/node_modules/.bin
        cp -fr /npm/$CONTAINERNAME/node_modules/.bin/* ./$CONTAINERNAME/root/app/node_modules/.bin
    fi

}

case "$1" in

ps)

  dc ps
  ;;

pull)

  if [ ! -n "$2" ]; then
    dc pull
    exit 0
  fi

  # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
  CONTAINERNAME=${2%/}

  dc pull $CONTAINERNAME
  ;;

down)

  if [ ! -n "$2" ]; then
    dc stop && dc rm -f
    exit 0
  fi

  # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
  CONTAINERNAME=${2%/}

  dc stop $CONTAINERNAME && dc rm -f $CONTAINERNAME
  ;;

kill)

  if [ ! -n "$2" ]; then
    dc kill
    exit 0
  fi

  # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
  CONTAINERNAME=${2%/}

  dc kill $CONTAINERNAME
  ;;

build)

    if [ ! -n "$2" ]; then
        dc build
        exit 0
    fi

    # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
    CONTAINERNAME=${2%/}

    dc build $CONTAINERNAME
    ;;

rebuild)

    if [ ! -n "$2" ]; then
        dc stop && dc rm -f && dc build && dc up -d && dc scale consul=2
        exit 0
    fi

    # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
    CONTAINERNAME=${2%/}

    dc stop $CONTAINERNAME && dc rm -f $CONTAINERNAME && dc build $CONTAINERNAME && dc up -d --no-recreate $CONTAINERNAME

    if [ "$CONTAINERNAME" = "consul"]; then
        dc scale consul=2
    fi
    ;;

up)

    dc stop && dc rm -f && dc up -d
    ;;

restart)

    if [ ! -n "$2" ]; then
        printf "Please provide a container name. For example: \n  c up app \n"
        exit 1
    fi

    # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
    CONTAINERNAME=${2%/}

    dc stop $CONTAINERNAME && dc rm -f $CONTAINERNAME && dc up -d --no-recreate $CONTAINERNAME && dc logs -f $CONTAINERNAME
    ;;

exec)

    if [ ! -n "$2" ]; then
        printf "Please provide a container name. For example: \n  c exec consul [container number, defaults to 1] \n  c exec consul 2 \n"
        exit 1
    fi

    # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
    CONTAINERNAME=${2%/}

    docker exec -it ${COMPOSE_PROJECT_NAME}_${CONTAINERNAME}_${3:-'1'} with-contenv sh
    ;;

env)

    if [ ! -n "$2" ]; then
        printf "Please provide an environment name. \n"
        exit 1
    fi

    if test "$2" = 'reset' -o "$2" = 'RESET'; then
        # Reset dc to load default docker-compose.yml file
        echo COMPOSE_FILE=docker-compose.yml > .env
        printf "You have reset 'dc' to load the default docker-compose.yml file.\n"
        exit 1
    fi

    # Add COMPOSE_FILE environment variable to .env file
    echo COMPOSE_FILE=docker-compose.yml:docker-compose.${2}.yml > .env
    printf "You have configured 'dc' to load from docker-compose.yml and docker-compose.${2}.yml. \nMake sure docker-compose.${2}.yml exists. \n"
    ;;

logs)

    if [ ! -n "$2" ]; then
        dc logs -f
        exit 0
    fi

    # remove the trailing / if there is any (this allows user to use tab to complete the container name which corresponding to the directory name)
    CONTAINERNAME=${2%/}

    dc logs -f $CONTAINERNAME
    ;;

npm)

    if [ ! -n "$2" ]; then
        printf "Please provide a container name. \n"
        exit 1
    fi

    # Work out the NPM command we need to run
    COMMANDSTR="npm"
    for i in ${@:3:${#@}}
    do
      COMMANDSTR+=" $i"
    done

    # If $2 was "all" then run it in all Node.js containers.
    if [ "${2%/}" = "all" ]; then

        for CONTAINER in "kueui"
        do

            npm_install_in_container "$CONTAINER" "$COMMANDSTR"

        done
        exit 0

    fi

    # Just one container to run the command in
    npm_install_in_container "${2%/}" "$COMMANDSTR"
    ;;

-h|--help)

    printf "${USAGE}"
    ;;

*)

    printf "$1 is not supported. \n ${USAGE}"
    ;;

esac
