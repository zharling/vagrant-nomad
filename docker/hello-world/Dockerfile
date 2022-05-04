FROM node:12-slim

WORKDIR /usr/src/app

COPY package*.json ./

RUN apt-get update && apt-get install -y \
  groff \
  less \
  unzip 

RUN npm install

COPY . ./

CMD [ "node", "server.js" ]