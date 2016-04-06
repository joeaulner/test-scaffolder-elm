FROM ubuntu:14.04

RUN     apt-get update
RUN     apt-get install -y nodejs npm nodejs-legacy git

RUN     mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY    package.json /usr/src/app
COPY    elm-package.json /usr/src/app
RUN     npm install
RUN     npm install -g elm
RUN     elm package install -y

COPY . /usr/src/app

EXPOSE  8080


CMD [ "npm", "run-script", "dev"]
