# Pull base image.
FROM phusion/baseimage:latest
MAINTAINER Ashwini Kumar <kumarashwini@outlook.com>

RUN add-apt-repository ppa:git-core/ppa

RUN apt-get -qq update && apt-get -qqy dist-upgrade
RUN apt-get install -qqy git vim bash-completion curl wget build-essential python-dev python3-dev \
 autoconf libtool bison pulseaudio libpulse-dev fish
RUN apt-get --fix-missing install g++

RUN mkdir -p /speech-to-text/deps/cmake-extract /speech-to-text/deps/swig /speech-to-text/api-code

#TODO - for deps use wget instead
COPY ./deps/ /speech-to-text/deps
COPY ./api-code/ /speech-to-text/api-code

RUN curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
RUN apt-get install -y nodejs

#Another alternative to node-gyp, which cmysphinx uses
RUN npm install -g cmake-js

#Insall Swig from deps (apt-get does not have the required latest version, we could also use wget though)
RUN cd /speech-to-text/deps && \
	tar -xzf swig-3.0.8.tar.gz -C /speech-to-text/deps/swig --strip-components=1 && \
	cd /speech-to-text/deps/swig && ./configure --prefix=/usr --without-clisp --without-maximum-compile-warnings && \
	make && make install && install -v -m755 -d /usr/share/doc/swig-3.0.8 && cp -v -R Doc/* /usr/share/doc/swig-3.0.8

#Insall CMake from deps
RUN cd /speech-to-text/deps && \
	tar -xzf cmake-3.4.3-Linux-x86_64.tar.gz -C /speech-to-text/deps/cmake-extract --strip-components=1

#Some useful global aliases and settings & Update ENV Path var for the cmake-extract
ADD ./dev.sh /etc/profile.d/

#Clone and install sphinxbase
RUN git clone https://github.com/cmusphinx/sphinxbase.git /speech-to-text/deps/sphinxbase
RUN cd /speech-to-text/deps/sphinxbase && ./autogen.sh && ./configure && make && make install

#Clone and install pocketsphinx
RUN git clone https://github.com/cmusphinx/pocketsphinx.git /speech-to-text/deps/pocketsphinx
RUN cd /speech-to-text/deps/pocketsphinx && ./autogen.sh && ./configure && make && make install

COPY ./scripts /scripts
RUN chmod +x /scripts/*.sh && \
	mkdir -p /etc/service/pulseaudio && \
	ln -s /scripts/start-monitor-pulseaudio.sh /etc/service/pulseaudio/run

RUN apt-get clean

RUN export PATH=$PATH:/speech-to-text/deps/cmake-extract/bin && \
	cd /speech-to-text/api-code && \
	npm prune && \
	echo npm prune is complete && \
    echo Installation in progress... please be patient on a slow connection && \
	npm i && \
	echo npm install is complete

# Expose ports, if the container is to be used as a web server, but it will also require some code update

WORKDIR /speech-to-text
