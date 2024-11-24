FROM node:20.18.1-alpine3.19 AS base

RUN apk add --no-cache shadow \
    && groupadd -r appgroup && useradd -r -g appgroup appuser

WORKDIR /usr/src/app

COPY ./node_modules ./node_modules
COPY ./src ./

RUN chown -R appuser:appgroup /usr/src/app

USER appuser

CMD ["node", "index.js"]