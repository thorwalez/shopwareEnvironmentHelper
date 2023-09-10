# Shopware by Dockerware

Easy handling of a Shopware environment with the help of dockware images

Container application with a Shopware installation, a database,
an admin and a mailcatcher.

Links:
- https://dockware.io/getstarted
- https://github.com/dockware/dockware
- https://www.dasistweb.de/de/academy/artikel/dockware
- https://github.com/dockware/examples/blob/master/basic-dev-setup/docker-compose.yml
- https://docs.dockware.io/use-dockware/default-credentials
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


2. SSH/SFTP Zugang

- ssh dockware@localhost dockware:dockware


3. Container Zugang

- docker exec -it dw__myshop_dev_shopware bash
- docker compose exec shop bash