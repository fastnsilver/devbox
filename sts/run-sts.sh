#!/bin/bash

# docker image to use
DOCKER_IMAGE_NAME="fans/sts-base"

# local name for the container
DOCKER_CONTAINER_NAME="sts-base"

SSH_KEY_PRIVATE="-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAxoeqJlmVd+8MdnESy/cDEjLvsnddGswsHszq9dECD8obrBkG
86jxRzcyH6/1SehHu4wzxU2DgO+JSv2GkDREf2HpLL1zXC3HwKd5TK/d8flzeeTX
due2p1nHpkv+EYpRQ+JxMr2fTBwIZZska4FFjAP3cN7xzo4WEWMn3BRZUQSs4RY7
9rJA12AHvioE5U8lFTN300G2Z8G4AvFoQIFTHR2b9v4RDJ9w9PsHvKdCfTMZM3/4
/hHWouXYjuhilOBrdzgNHsAjM9WS1GDBdefjmM7waPTvi6lIUyfnyHkT3Ekykgoi
EDaUE3AmNCyaJFM7JEhGv/n/RB+AnK8xDsZuowIDAQABAoIBACPF1En+wGkRAPzi
mRF5m+sOlJRi37rxaU3PfNL4a1evAld7Vv5WxcsgTf7ZtOgxW6OWusllkzmLcAC8
OCAJ2wHdAagXJw9IDINRahEAa4yrdzxSmOSLEiWLjucPMGO2ubfyuJT9CBQtxPGS
B/j7HS4ClPaYpZejkKRnaopEfGeVj9Zg2j0uEKaG9fEUkQySU/GLRjf0HQVWmKrv
Px90QABl2gpGtFzl9GXQpLzDKjR0+eoF5uaQpd+DBaNWOjzCkAhAi5AsVHlJQ9LZ
Q+a1dXs8/ERHLFCscVplOLlO6NzrTKWCzQPoouJQ7cwg7B2MThD1o3JmMv7TpfJq
PxRN8OECgYEA4h10rhsl+N2ssgq0veC8nOZfNe1ivlS6RmagEuFF05A+fsYSnlt0
XT07OG66ApnB1CWo2C48bq6A4IabFbc6cxeLEQalr4xljy1f9Qwlvi7tbCu9UEzX
lK9ajbjw4k4khEx+0tRX2Q6zXlZwdrfJ2OkaeAOWq59E880y0lFPcNMCgYEA4MTf
mx/DZCqHVtPQG2Xg411u1FSY0X+q8SeaaPnKi0OlKIEioJgDs+H0x58XvWoayWEA
qmT4D3A5PYaJv7JLv9GgXza8uNwZmhOAYZUmk/VOX9tqo92/pJ7IMJQU4e8sFR41
u8ioMTXHKYaosAUOf1FcwQ5XBsslPKoFeaGK6PECgYEAzOyLKZt7H3+vmrAvPAKo
jb4PPe2FVx+srk8l9dZqFSIeMYDLsO8Ll9D9kdhwBhlZXC5BRqMoq9rE/Deh591m
QJZut6CBmoawKEGkPI6kyib3j9hYO6VYn+0IMXcSANd3Ktu0+NfvQc2b6/yE8mMA
sPAZx/jgnWu77wTicU+1oncCgYAsZZbJXEfK9D+RXftAPipinqTymdcpom8QfUMZ
syVXxr/LtV4ynHQ2xs4D1B/rURcDaf6oqZL58a/MwFNbIwulUvG7fONgHFGORoXY
QI7DMPQPKRbyUS22hYqDVeyeCBEMBtCUS/k05yt0v114jzci3N5WX8++zseHKQo1
0TvP8QKBgAT5LV0Cyr9PL6MCLXzsWaBh5zADtgOXigWWEmRDXlUBI/X00BHFQRIR
AjnkyaAwbv9RveY5fwGNGTv0Zgpe4fZpBjh5KcDoXXUhCoEAzRiVbH9f9+Wf5yBi
HBiLnCEctS6DP0K+6/WaHsY1UnxIG8L3+MiNZOAvPW6zcRhT9VYM
-----END RSA PRIVATE KEY-----"

# Write ssh key to temp. file
SSH_KEY_FILE_PRIVATE=$(tempfile)
echo "${SSH_KEY_PRIVATE}" > ${SSH_KEY_FILE_PRIVATE}

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
	TMP=$(${SUDO} docker run -d -P --name ${DOCKER_CONTAINER_NAME} ${DOCKER_IMAGE_NAME})
	echo "done"
fi

# Wait for container to come up
sleep 2

# Find ssh port
SSH_URL=$(${SUDO} docker port ${DOCKER_CONTAINER_NAME} 22)
SSH_URL_REGEX="(.*):(.*)"

SSH_INTERFACE=$(echo $SSH_URL | awk -F  ":" '/1/ {print $1}')
SSH_PORT=$(echo $SSH_URL | awk -F  ":" '/1/ {print $2}')

echo "ssh running at ${SSH_INTERFACE}:${SSH_PORT}"

ssh -i ${SSH_KEY_FILE_PRIVATE} -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -Y -X root@${SSH_INTERFACE} -p ${SSH_PORT} sts/STS -data workspace
rm -f ${SSH_KEY_FILE_PRIVATE}