FROM fans/oracle-java8
MAINTAINER Chris Phillipson fastnsilver@gmail.com

RUN mkdir /app
RUN /usr/bin/curl -L http://dynamodb-local.s3-website-us-west-2.amazonaws.com/dynamodb_local_latest | /bin/tar -xz -C /app

ENTRYPOINT ["/usr/bin/java", "-Djava.library.path=/app/DynamoDBLocal_lib", "-jar", "/app/DynamoDBLocal.jar"]

EXPOSE 8000
