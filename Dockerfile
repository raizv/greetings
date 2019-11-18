FROM node:10-alpine as build
ENV HOME=/app
WORKDIR /app

RUN apk add --update --no-cache \
      # newrelic
      g++ make python \
      # sonar-scanner
      openjdk8-jre

COPY package.json package-lock.json /app/

RUN set -ex && \
    npm install

COPY ./ /app/

FROM node:10-alpine
COPY --from=build /app /app

RUN set -ex && \
    adduser node root && \
    chmod g+w /app

WORKDIR /app
EXPOSE 8080
USER node
CMD [ "npm", "start" ]
