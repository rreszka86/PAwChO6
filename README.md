# LAB5 - Creating an image from scratch & multi-stage builds.

## Commands used in this lab

### Building an image

As I felt that it's not a great idea to keep an Alpine Linux tar file in repository (even if it's only ~3MB), I am leaving here a curl command to download Alpine which I used (this version was also provided in the course for this lab).

```sh
curl -L -o alpine-minirootfs-3.19.1-x86_64.tar https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-x86_64.tar.gz
```

```sh
docker build --build-arg VERSION=1.0.0 -t mycoolapp:1.0.0 .
```

If there won't be *--build-arg* option with value provided for VERSION argument, then it will be described as *test_build*.

### Creating and starting a container

```sh
docker run -d --rm -p 80:80 --name app1 mycoolapp:1.0.0
```

### Checking container health

```sh
docker ps --filter name=app1
```

Container's health shows up in the STATUS column.

## But does it even work?

![Screenshot](preview.png)

### Additional info

Nginx was used here as a proxy, which redirects from default page to NodeJS app running under port 8080. To configure Nginx, I prepared a config file, which was based on output of this command:

```sh
docker run --rm --entrypoint=cat nginx /etc/nginx/conf.d/default.conf > ./default.conf
```

Even though I wasn't told to do so, I decided to copy ARG *VERSION* from first build stage to the final one (it looks better, than 'undefined').