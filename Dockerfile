FROM node:10-alpine
ENV HOME=/app
WORKDIR /app

RUN set -ex && \
    adduser node root && \
    chmod g+w /app && \
    apk add --update --no-cache \
      # newrelic
      g++ make python \
      # sonar-scanner
      openjdk8-jre

COPY package.json package-lock.json /app/

RUN set -ex && \
    npm install

COPY ./ /app/

EXPOSE 8080
USER node
CMD [ "npm", "start" ]
