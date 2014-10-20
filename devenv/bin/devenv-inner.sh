#/bin/bash
set -e

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

buildz(){
	echo "Building all docker containers:"
	for i in "oracle-java8" "tomcat8" "scala" "ansible" "cassandra" "opscenter" "helenos" "dynamodb" "zookeeper" "elasticsearch" "kafka" "logstash" "mongo" "redis" "riemann" "storm-base" "storm-nimbus" "storm-supervisor" "storm-ui";
	do
		echo "- fans/$i"
		docker build -t fans/$i /vagrant/images/$i
  done
}

cassz() {
  OPSCENTER=$(docker run \
	  -d \
		--name opscenter \
		-p 8888:8888 \
		fans/opscenter)
	echo "Started OPSCENTER in container $OPSCENTER"
  sleep 15

  OPS_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' opscenter)
	echo "- OPSCENTER IP is: $OPS_IP."

	CASSANDRA=$(docker run \
	  -d \
		--name cass1 \
		-e OPS_IP=$OPS_IP \
		-p 7000:7000 \
		-p 7001:7001 \
		-p 7199:7199 \
		-p 9042:9042 \
		-p 9160:9160 \
		fans/cassandra)
	echo "Started CASSANDRA NODE cass1 in container $CASSANDRA"
	sleep 15

	SEED_IP=$(docker inspect -f '{{ .NetworkSettings.IPAddress }}' cass1)
	echo "- CASSANDRA NODE cass1 IP is: $SEED_IP."

  echo "Registering cluster with OpsCenter"
  curl \
    http://$OPS_IP:8888/cluster-configs \
	  -X POST \
	  -d \
	  "{
	      \"cassandra\": {
	        \"seed_hosts\": \"$SEED_IP\"
	      },
	      \"cassandra_metrics\": {},
	      \"jmx\": {
	        \"port\": \"7199\"
	      }
	  }" > /dev/null
}

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
	echo "Stopping all docker containers..."
	killz
	rmz
}

start(){
	echo "Starting applications..."
	mkdir -p $APPS/zookeeper/data
	mkdir -p $APPS/zookeeper/logs
	ZOOKEEPER=$(docker run \
		-d \
		-p 2181:2181 \
		-v $APPS/zookeeper/data:/data \
		-v $APPS/zookeeper/logs:/logs \
		--name zookeeper \
		fans/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	mkdir -p $APPS/redis/data
	mkdir -p $APPS/redis/logs
	REDIS=$(docker run \
		-p 6379:6379 \
		-v $APPS/redis/data:/data \
		-v $APPS/redis/logs:/logs \
		-d \
		fans/redis)
	echo "Started REDIS in container $REDIS"

	cassz

	mkdir -p $APPS/dynamodb/data
	mkdir -p $APPS/dynamodb/logs
	DYNAMODB=$(docker run \
		-p 8000:8000 \
		-d \
		-v $APPS/dynamodb/data:/data \
		-v $APPS/dynamodb/logs:/logs \
		fans/dynamodb)
	echo "Started DYNAMODB in container $DYNAMODB"

	mkdir -p $APPS/elasticsearch/data
	mkdir -p $APPS/elasticsearch/logs
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 9300:9300 \
		-v $APPS/elasticsearch/data:/data \
		-v $APPS/elasticsearch/logs:/logs \
		-d \
		fans/elasticsearch)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"

	## FIXME Broken; won't start-up

	#LOGSTASH=$(docker run \
	#	-p 3377:3377 \
	#	-p 3374:3374 \
	#	-d \
	#	fans/logstash)
	#echo "Started LOGSTASH in container $LOGSTASH"

	## FIXME Restore Kibana when Dockerfile builds successfully

	#KIBANA=$(docker run \
	#	-p 9292:9292
	#	-d \
	#	fans/kibana)
	#echo "Started KIBANA in container $KIBANA"

	mkdir -p $APPS/mongo/data
	mkdir -p $APPS/mongo/logs
	MONGO=$(docker run \
		-p 27017:27017 \
		-p 28017:28017 \
		-v $APPS/mongo/data:/data \
		-v $APPS/mongo/logs:/logs \
		-d \
		fans/mongo)
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
		fans/kafka)
	echo "Started KAFKA in container $KAFKA"

	mkdir -p $APPS/rabbitmq/data
	mkdir -p $APPS/rabbitmq/logs
	RABBITMQ=$(docker run \
		-d \
		-p 5672:5672 \
		-p 15672:15672 \
		-v $APPS/rabbitmq/data:/data \
		-v $APPS/rabbitmq/logs:/logs \
		mikaelhg/docker-rabbitmq)
	echo "Started RABBITMQ in container $RABBITMQ"

	mkdir -p $APPS/riemann/data
	mkdir -p $APPS/riemann/logs
	RIEMANN=$(docker run \
		-d \
		-p 5555:5555 \
		-p 5556:5556 \
		-p 5557:5557 \
		-v $APPS/riemann/data:/data \
		-v $APPS/riemann/logs:/logs \
		fans/riemann)
	echo "Started RIEMANN in container $RIEMANN"

	## TODO Add storm complement of containers

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
	docker version

	update-rc.d docker defaults
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	docker pull mikaelhg/docker-rabbitmq
	docker build -t crosbymichael/dockerui github.com/crosbymichael/dockerui
	buildz
}

case "$1" in
	restart)
		killz
		rmz
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
