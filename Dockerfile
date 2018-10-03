# Defines the production environment for our application

FROM node:8-alpine
EXPOSE 8080
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

COPY package.json yarn.lock /app/
RUN set -ex && \
    yarn install --pure-lockfile && \
    yarn cache clean
COPY ./ /app/

RUN set -ex && \
    apk del g++ make python

USER node
ENTRYPOINT ["yarn"]
CMD ["start"]
