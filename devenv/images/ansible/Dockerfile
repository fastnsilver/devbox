FROM phusion/baseimage
MAINTAINER Chris Phillipson fastnsilver@gmail.com

ADD ansible-trusty.list /etc/apt/sources.list.d/
RUN apt-key adv \
      --keyserver keyserver.ubuntu.com \
      --recv D664CA69B53A79125B2593E16425F1DA5504681D \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ansible \
    --no-install-recommends
