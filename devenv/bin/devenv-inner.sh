#/bin/bash
set -e

### FIXME once all fns/ docker images build successfully replace relateiq/ image refs below

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}


killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill

}

rmz(){
	echo "Deleting all prior run docker containers:"
	ids=`docker ps -a | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){
	echo "Starting applications..."
	mkdir -p $APPS/zookeeper/data
	mkdir -p $APPS/zookeeper/logs
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v $APPS/zookeeper/logs:/logs \
		--name zookeeper \
		relateiq/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	mkdir -p $APPS/redis/data
	mkdir -p $APPS/redis/logs
	REDIS=$(docker run \
		-p 6379:6379 \
		-v $APPS/redis/data:/data \
		-v $APPS/redis/logs:/logs \
		-d \
		relateiq/redis)
	echo "Started REDIS in container $REDIS"

	mkdir -p $APPS/cassandra/data
	mkdir -p $APPS/cassandra/logs
	CASSANDRA=$(docker run \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7199:7199 \
		-p 9160:9160 \
		-p 9042:9042 \
		-v $APPS/cassandra/data:/data \
		-v $APPS/cassandra/logs:/logs \
		-d \
		relateiq/cassandra)
	echo "Started CASSANDRA in container $CASSANDRA"

	mkdir -p $APPS/elasticsearch/data
	mkdir -p $APPS/elasticsearch/logs
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 9300:9300 \
		-v $APPS/elasticsearch/data:/data \
		-v $APPS/elasticsearch/logs:/logs \
		-d \
		relateiq/elasticsearch)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	mkdir -p $APPS/mongo/data
	mkdir -p $APPS/mongo/logs
	MONGO=$(docker run \
		-p 27017:27017 \
		-p 28017:28017 \
		-v $APPS/mongo/data:/data/lucid_prod \
		-v $APPS/mongo/logs:/logs \
		-d \
		relateiq/mongo)
	echo "Started MONGO in container $MONGO"

	mkdir -p $APPS/kafka/data
	mkdir -p $APPS/kafka/logs
	KAFKA=$(docker run \
		-d \
		-p 9092:9092 \
		-v $APPS/kafka/data:/data \
		-v $APPS/kafka/logs:/logs \
		--name kafka \
		--link zookeeper:zookeeper \
		relateiq/kafka)
	echo "Started KAFKA in container $KAFKA"

	DOCKERUI=$(docker run \
		-d \
		-p 9000:9000 \
		-v /var/run/docker.sock:/docker.sock crosbymichael/dockerui \
		-e /docker.sock)
	echo "Started DOCKERUI in container $DOCKERUI"

	sleep 1

}

update(){
	apt-get update
	apt-get -y install docker.io
	ln -sf /usr/bin/docker.io /usr/local/bin/docker
  sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
	apt-get -y install apt-transport-https
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
	sh -c "echo deb https://get.docker.io/ubuntu docker main\ > /etc/apt/sources.list.d/docker.list"
	apt-get update
	apt-get -y install lxc-docker
	apt-get -y install apparmor
	docker version

	update-rc.d docker.io defaults
	cp /vagrant/etc/docker.io.conf /etc/init/docker.io.conf

	docker pull relateiq/zookeeper
	docker pull relateiq/redis
	docker pull relateiq/cassandra
	docker pull relateiq/elasticsearch
	docker pull relateiq/mongo
	docker pull relateiq/kafka

	docker build -t crosbymichael/dockerui github.com/crosbymichael/dockerui

}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	rm)
	  rmz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|rm|update|restart|status|ssh}"
		RETVAL=1
esac
