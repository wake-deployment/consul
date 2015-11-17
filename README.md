# consul for wake

This repo is intended to be used along with the deployment tool wake
during `wake-cluster-create`.

## Build the containers

```sh
$ wake containers create -r master
```

Or to push it to docker hub:

```sh
$ wake containers create -r master -p
```

## Use locally

With the default bootstrap expectency of 3:

```sh
$ docker run -d --name consul-1 org/wake-consul-server:sha
$ joinip=$(docker inspect consul-1 | jq -a -r '.[0].NetworkSettings.Networks.bridge.IPAddress')
$ docker run -d --name consul-2 -e JOINIP=$joinip org/wake-consul-server:sha
$ docker run -d --name consul-3 -e JOINIP=$joinip org/wake-consul-server:sha
$ docker run -d --name consul-agent-1 -e JOINIP=$joinip org/wake-consul-agent:sha
# ...
```

A similar scheme can be employed for production use.
