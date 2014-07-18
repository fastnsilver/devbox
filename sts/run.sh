#!/bin/sh

# docker image to use
DOCKER_IMAGE_NAME="fans/sts-base"

# local name for the container
DOCKER_CONTAINER_NAME="sts-base"

# See if docker requires sudo
if [ "$(docker run busybox echo 'test')" != "test" ]; then
  SUDO=sudo
  if [ "$(${SUDO} docker run busybox echo 'test')" != "test" ]; then
    echo "Could not run docker"
    exit 1
  fi
fi

# Check if container already present
TMP=$(${SUDO} docker ps -a | grep ${DOCKER_CONTAINER_NAME})
CONTAINER_FOUND=$?

TMP=$(${SUDO} docker ps | grep ${DOCKER_CONTAINER_NAME})
CONTAINER_RUNNING=$?

if [ $CONTAINER_FOUND -eq 0 ]; then

	echo -n "Container '${DOCKER_CONTAINER_NAME}' found, "

	if [ $CONTAINER_RUNNING -eq 0 ]; then
		echo "Already running"
	else
		echo -n "Not running, starting..."
		TMP=$(${SUDO} docker start ${DOCKER_CONTAINER_NAME})
		echo "done"
	fi

else
	echo -n "Container '${DOCKER_CONTAINER_NAME}' not found, creating..."
	TMP=$(${SUDO} docker run -i -t -p 6080:6080 -P --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME})
	echo "done"
fi
