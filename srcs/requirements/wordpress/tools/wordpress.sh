#!/bin/sh

if [ -f ./wp-config.php ]
	then
		echo "wordpress have already been installed"
	else
		wget https://wordpress.org/latest.tar.gz
		tar -xvf latest.tar.gz
		mv wordpress/* .
		rm -rf latest.tar.gz
		rm -rf wordpress

		cp wp-config-sample.php wp-config.php
		sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config.php
		sed -i "s/username_here/$MYSQL_USER/g" wp-config.php 
		sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config.php 
		sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config.php 
fi

exec "$@"
