# Shopware by Dockerware

Easy handling of a Shopware environment with the help of dockware images

Container application with a Shopware installation, a database,
an admin and a mailcatcher.

Links:
- https://dockware.io/getstarted
- https://docs.dockware.io/use-dockware/default-credentials
- https://github.com/dockware/dockware
- https://www.dasistweb.de/de/academy/artikel/dockware
- https://github.com/dockware/examples/blob/master/basic-dev-setup/docker-compose.yml
- https://developer.shopware.com/docs/guides/plugins/apps/app-base-guide
- https://developers.shopware.com/developers-guide/rest-api


##### Possible version that exist
Tags-Version
- https://github.com/dockware/dockware/tree/21585cadc8f16f19f1e86ad58d045fbb3a9e8d99/.dist/versions/master/dev

#### Shopware 5:

1. Links

   ADMIN URL: http://localhost/backend demo:demo


2. Path

- Shopware-Source:  /var/www/html/engine/Shopware/
- Shopware-Plugin:  /var/www/html/engine/Shopware/Plugins/Community/Backend/


#### Shopware 6:

1. Links

   ADMIN URL: http://localhost/admin/login admin:shopware


2. Path

- Shopware-Source:  /var/www/html/vendor/shopware/
- Shopware-Plugin:  /var/www/html/custom/plugin



#### Generally valid for all versions:

1. Links

   SHOP URL: http://localhost

   ADMINER URL: http://localhost/adminer.php

   MAILCATCHER URL: http://localhost/mailcatcher


2. SSH/SFTP Access

- ssh dockware@localhost dockware:dockware


3. Container Access

- docker exec -it dw__myshop_dev_shopware bash
- docker compose exec shop bash


## Start and set up the Shopware environment via make:

```bash
# build the Shopware environment
$ make build
```

```bash
# start Shopware environment 
$ make start
```

```bash
# stop Shopware environment 
$ make stop
```

```bash
# destroy Shopware environment 
$ make down
```

```bash
# update Shopware environment 
$ make update
```

```bash
# deletes docker compose files and the dockware images
$ make clean
```

```bash
# create database backup
$ make db-backup
```

```bash
# restore a database dump
$ make db-restore
```

## Provide Shopware for external containers to link to

There are two ways to link a Shopware container with an external one.

1) The external container already has a network which is accessible from the outside, recognizable by "external: true". 
   Then enter this in the question "Should an external network be set?" with its network name.

2) You create a new network which is externally accessible. Then you enter the name of the network in the question 
   "Should an external network be set?" and execute "make create-network" after the build.
   Then you have to announce the network in the external container.

So that the containers can communicate within the network over which they are linked. 
In the external container system, the Shopware container name and the Shopware domain 
under which Shopware is accessible must be specified via --link in "docker run" or external_links in "docker compose".

Note: In the external container Shopware cannot be reached via localhost!

Example of a docker run command of an external container:
```bash
## docker run --link <shopware-container-name>:<shopware-container-domain> --network <external-network-sw> -d ubuntu:latest
$ docker run --link shop:sw.external.io --network transfer-net-sw -d ubuntu:latest
```

Example of a docker compose yaml of an external container:
```yaml
service:

  networks:
     - "<shopware-container-network-name>"
  external_links:
     - "<shopware-container-name>:<shopware-container-domain>"

networks:
  <shopware-container-network-name>:
    external: true
```