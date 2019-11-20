FROM node:10-alpine as build
ENV HOME=/app
WORKDIR /app

RUN adduser node root && \
    chmod g+w /app && \
    apk add --update --no-cache \
    # newrelic
    g++ make python \
    # sonar-scanner
    openjdk8-jre

COPY package*.json /app/

RUN npm install

COPY . .

EXPOSE 8080
USER node
CMD [ "npm", "start" ]
