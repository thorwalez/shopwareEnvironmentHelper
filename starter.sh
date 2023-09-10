#!/bin/bash

if [ ! -f docker-compose.yml.dist ]; then
  if hash wget 2>/dev/null; then
    wget -O docker-compose.yml.dist https://raw.githubusercontent.com/dockware/examples/master/basic-dev-setup/docker-compose.yml
  else
    curl https://raw.githubusercontent.com/dockware/examples/master/basic-dev-setup/docker-compose.yml -o docker-compose.yml.dist
  fi
fi

cp docker-compose.yml.dist docker-compose.yml

read -r -p "Welche Shopware Version soll geladen werden?[Bsp.: 6.4 oder 5.7.14 | default ist latest]?" SHOPWAREVersion

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
  read -r -p "Soll ein Alternative SSH/SFTP Port gesetzt werden?[Bsp.: 2222 | default ist 22]?" SSHPort
  if [ "$SSHPort" = "" ]; then
    SSHPort=22
  fi
  sed -i "s/22:22/$SSHPort:22/g" $YAML_FILE

  read -r -p "Soll ein Alternative Webserver Port gesetzt werden?[Bsp.: 8080 | default ist 80]?" WWWPort
  if [ "$WWWPort" = "" ]; then
    WWWPort=80
  fi
  sed -i "s/80:80/$WWWPort:80/g" $YAML_FILE

  read -r -p "Soll ein Alternative Datenbank Port gesetzt werden?[Bsp.: 0815 | default ist 3306]?" DBPort
  if [ "$DBPort" = "" ]; then
    DBPort=3306
  fi
  sed -i "s/3306:3306/$DBPort:3306/g" $YAML_FILE
fi