#!/bin/sh

mariadb --version

echo "version $?"

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

mysql_install_db --user=mysql
chown -R mysql:mysql /var/lib/mysql

/etc/init.d/mysql start

echo "=========================================  Check file in $MYSQL_DATABASE ========================================= "


echo "========================================= Start Install SQL ... ========================================= ";

if [ -d /var/lib/mysql/$MYSQL_DATABASE ]
then

echo "Database has already installed ...";

else

mysql_secure_installation  << _EOF_

Y
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
N
Y
Y
_EOF_

echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD

mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql

echo "Database installs Success !!!";
fi

echo "========================================= Start Stop mysql ========================================= ";
sed -i "s|password =|password = $MYSQL_ROOT_PASSWORD|g" /etc/mysql/debian.cnf
/etc/init.d/mysql stop
echo "========================================= Finish Stop mysql ========================================= ";

echo "========================================= Start executer command ========================================= "
exec "$@"
