#!/bin/bash

if [ ! -f docker-compose.yml.dist ]; then
  if hash wget 2>/dev/null; then
    wget -O docker-compose.yml.dist https://raw.githubusercontent.com/dockware/examples/master/basic-dev-setup/docker-compose.yml
  else
    if ! [ -x "$(command -v curl)" ]; then
      apt-get update && apt-get install -y curl
    fi
    curl https://raw.githubusercontent.com/dockware/examples/master/basic-dev-setup/docker-compose.yml -o docker-compose.yml.dist
  fi
fi

cp docker-compose.yml.dist docker-compose.yml

read -r -p "Welche Shopware Version soll geladen werden?[Bsp.: 6.4.0.0 oder 5.7.14 | default ist latest]?" SHOPWAREVersion

if [ "$SHOPWAREVersion" = "" ]; then
 SHOPWAREVersion=latest
fi

# Pfad zur YAML-Datei
YAML_FILE="./docker-compose.yml"

# Ausgabe der aktuellen Version
CURRENT_VERSION=$(grep -oP 'image: dockware\/dev:\K.*' $YAML_FILE)
echo "Aktuelle Version: $CURRENT_VERSION"

# Ersetzen der "aktuelle"-Version durch den neuen Wert
sed -i "s/dockware\/dev:$CURRENT_VERSION/dockware\/dev:$SHOPWAREVersion/g" $YAML_FILE

# Ausgabe der aktualisierten Version
UPDATED_VERSION=$(grep -oP 'image: dockware\/dev:\K.*' $YAML_FILE)
echo "Aktualisierte Version: $UPDATED_VERSION"

if [ -f docker-compose.yml ]; then
  read -r -p "Soll ein alternativer SSH/SFTP Port gesetzt werden?[Bsp.: 2222 | default ist 22]?" SSHPort
  if [ "$SSHPort" = "" ]; then
    SSHPort=22
  fi
  sed -i "s/22:22/$SSHPort:22/g" $YAML_FILE

  read -r -p "Soll ein alternativer Webserver Port gesetzt werden?[Bsp.: 8080 | default ist 80]?" WWWPort
  if [ "$WWWPort" = "" ]; then
    WWWPort=80
  fi
  sed -i "s/80:80/$WWWPort:80/g" $YAML_FILE

  read -r -p "Soll ein alternativer Datenbank Port gesetzt werden?[Bsp.: 0815 | default ist 3306]?" DBPort
  if [ "$DBPort" = "" ]; then
    DBPort=3306
  fi
  sed -i "s/3306:3306/$DBPort:3306/g" $YAML_FILE

  volumePath="volumes:\n      - .\/plugins:\/var\/www\/html\/custom\/plugins\n      - .\/plugins:\/var\/www\/html\/engine\/Shopware\/Plugins\/Community\/Backend\n      - .\/uploads:\/var\/www\/html\/uploads"
  sed -i "s/\#volumes:/$volumePath/g" $YAML_FILE

  read -r -p "Soll eine Domain für Shopware gesetzt werden?[Bsp.: sw.external.local | Default: localhost]?" DOMAIN
  if [ -n "$DOMAIN" ]; then
    environmentLine="- XDEBUG_ENABLED=0"
    sed -i "s/$environmentLine/$environmentLine\n      - SHOP_DOMAIN=$DOMAIN/g" $YAML_FILE
  fi

  read -r -p "Soll ein Externes Netzwerk gesetzt werden?[Bsp.: transfer-net]?" ExNet
  if [ -n "$ExNet" ]; then
    sed -i "s/- web/- web\n      - $ExNet/g" $YAML_FILE
    sed -i '$a\  '"$ExNet:\n    external: true" $YAML_FILE

    if [ ! -f env ]; then
      echo "extern-network:$ExNet\n" > env
    else
      sed -i '$a extern-network:'"$ExNet\n" env
    fi
  fi
fi