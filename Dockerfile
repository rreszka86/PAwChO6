FROM scratch as build
ADD alpine-minirootfs-3.19.1-x86_64.tar /

RUN apk update && apk add nodejs npm

WORKDIR /usr/app

COPY ./web/package.json ./
RUN npm install

COPY ./web/index.js ./

ARG VERSION
ENV APP_VERSION=${VERSION:-test_build}

# EXPOSE 8080
# CMD ["npm", "start"]

FROM nginx:alpine

RUN apk update && apk add nodejs npm

WORKDIR /usr/share/nginx/html

COPY --from=build /usr/app ./
COPY ./web/default.conf /etc/nginx/conf.d

ARG VERSION
ENV APP_VERSION=${VERSION:-test_build}

EXPOSE 80

HEALTHCHECK --interval=10s --timeout=1s --start-period=3s --retries=3 \
    CMD curl -f http://localhost || exit 1

CMD nginx -g "daemon off;" & node index.js