#!/bin/bash

# Bash script to install Vert.x, OpenJDK 7, Apache and MySQL Server

# Set MySQL Server password
mysql_password="Passw0rd!"

# Set MySQL Server version to install
mysql_version="5.5"

# Set Vert.x filename to download. Change the location as necessary
vertx_version="vert.x-2.1.5"
vertx_download_location="https://bintray.com/artifact/download/vertx/downloads/$vertx_version".zip

# Install Vert.x, OpenJDK 7, and Apache
apt-get update
apt-get install unzip -y

# Default download location for Vert.x, change it if you want to use an alternative location
apt-get install openjdk-7-jdk -y
apt-get install apache2-utils -y
mkdir /usr/local/vertx && cd /usr/local/vertx
wget -qO- -O tmp.zip $vertx_download_location && unzip tmp.zip && rm tmp.zip
export PATH=/usr/local/vertx/$vertx_version/bin:$PATH

# Install MySQL Server in non-interactive mode
export DEBIAN_FRONTEND=noninteractive
echo "mysql-server-$mysql_version mysql-server/root_password password $mysql_password" | debconf-set-selections
echo "mysql-server-$mysql_version mysql-server/root_password_again password $mysql_password" | debconf-set-selections
apt-get install mysql-server -y

# Edit crontab to start MySQL Server service automatically on boot
(crontab -l 2>/dev/null; echo "@reboot service mysql start") | crontab -echo
