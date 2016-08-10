# kueui

This repository contains the an alpine linux image that run a KUE admin UI using expressjs.

For more info about the base images used in these images please checkout [docker-alpine](https://github.com/smebberson/docker-alpine)

To start development or testing please see the [development](./DEVELOPMENT.md) guide.

## Usage

To run this container, you will need to supply the following environment variables:

- `APP_PORT`: the port to run this container on. Please make sure you have opened this port in your docker compose configuration file.
- `CACHE_URL`: redis connection url
- `KUE_PREFIX`: KUE instance prefix. If none provided, it'll default to `q`.

## URLs

There are 2 versions of the KUE UI that you can access:

- built-in version http://<domain>:<port>/api
- [custom version](https://github.com/stonecircle/kue-ui) http://<domain>:<port>/kue

To access the KUE UI on local, browse to the following URLs:

- http://192.168.11.23:6001/api
- http://192.168.11.23:6001/kue
