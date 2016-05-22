FROM ubuntu:16.04

RUN     apt-get update
RUN     apt-get install -y nodejs npm nodejs-legacy git

RUN     locale-gen en_US en_US.UTF-8
RUN     update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

RUN     mkdir -p /src/
WORKDIR /src/

COPY    package.json /src/
RUN     npm install
RUN     npm install elm@0.16 -g

COPY . /src/

EXPOSE  8080
CMD [ "npm", "run", "dev"]