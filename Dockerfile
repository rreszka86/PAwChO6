#syntax=docker/dockerfile:1.4
FROM scratch as build
ADD alpine-minirootfs-3.19.1-x86_64.tar /

RUN apk update                     \
    && apk add nodejs npm          \
    && apk add git                 \
    && apk add openssh-client      \
    && rm -rf /var/cache/apk/*

RUN mkdir -p -m 0700 ~/.ssh        \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
    && eval $(ssh-agent)    

WORKDIR /usr/app

RUN --mount=type=ssh            \
    git clone git@github.com:rreszka86/PAwChO5.git

WORKDIR /usr/app/PAwChO5/web

RUN npm install


FROM nginx:alpine

RUN apk update && apk add nodejs npm

WORKDIR /usr/share/nginx/html

COPY --from=build /usr/app/PAwChO5/web ./
COPY --from=build /usr/app/PAwChO5/web/default.conf /etc/nginx/conf.d

ARG VERSION
ENV APP_VERSION=${VERSION:-test_build}

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=1s --start-period=3s --retries=3 \
    CMD curl -f http://localhost || exit 1

CMD nginx -g "daemon off;" & node index.js