# docker-vue-cli

Docker image for [VUE CLI](https://cli.vuejs.org/) to use as build container.

Image on dockerhub: https://hub.docker.com/r/crowdcode/vue-cli/

Currently, this image uses node v12.4.0 (npm 6.9.0), vue-cli 3.8.0 and Debian stretch as base distribution.

## Example Usage

```
docker run -it --rm -v "$PWD":/workspace crowdcode/vue-cli vue create vuedemo
cd vuedemo
docker run -it --rm -p 8080:8080 -v "$PWD":/workspace crowdcode/vue-cli npm run serve
```

Or to use VUE CLI UI
```
docker run -it -u $(id -u) --rm -p 8000:8000 -v "$PWD":/workspace crowdcode/vue-cli vue ui --host 0.0.0.0
```


To run the Vue CLI development server from docker you need to map the port and instruct Vue CLI to listen on all interfaces.
For example use
```
cd vuedemo
docker run -u $(id -u) --rm -p 4200:4200 -v "$PWD":/workspace crowdcode/vue-cli vue serve --host 0.0.0.0
```

If you want to clone additional git repositories, f.e. from package.json, and you run with a different user than uid 1000 you need to mount the passwd since git requires to resolve the uid.

```
docker run -u $(id -u) --rm -p 4200:4200 -v /etc/passwd:/etc/passwd -v "$PWD":/app crowdcode/vue-cli npm install
```

# Credits

- This image is inspired by [docker-ng-cli](https://github.com/trion-development/docker-ng-cli) by [everflux](https://github.com/everflux)
