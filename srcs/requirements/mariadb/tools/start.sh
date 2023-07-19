#!/bin/bash

mysql_install_db

/etc/init.d/mysql start

mariadb --version

if [ ! $? -eq 0 ]
    then
        echo "Install mariadb fail: MariaDB not set up!";
        exit 1;
fi

if [ ! -d /var/lib/mysql/$MYSQL_DATABASE ]
then
echo "Start Install SQL ...";

mysql_secure_installation  << _EOF_

Y
$MYSQL_ROOT_PASSWORD
$MYSQL_ROOT_PASSWORD
Y
N
Y
Y
_EOF_

# # Make sure that NOBODY can access the server without a password
# echo "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User = 'root'"
# mysql -e "UPDATE mysql.user SET Password = PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User = 'root'"
# # Kill the anonymous users
# echo "DROP USER ''@'localhost'"
# mysql -e "DROP USER ''@'0.0.0.0'"
# # Because our hostname varies we'll use some Bash magic here.
# echo "DROP USER ''@'$(hostname)'"
# mysql -e "DROP USER ''@'$(hostname)'"
# # Kill off the demo database
# echo  "DROP DATABASE test"
# mysql -e "DROP DATABASE test"
# # Make our changes take effect
# echo "FLUSH PRIVILEGES"
# mysql -e "FLUSH PRIVILEGES"
# # Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param

echo "Start GRANT ALL ...";
echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
# echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
# echo "CREATE USER IF NOT EXISTS $MYSQL_USER@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
# echo "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot -p$MYSQL_ROOT_PASSWORD
# echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';" | mysql -uroot -p$MYSQL_ROOT_PASSWORD

mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql
echo "Database installs Success !!!";
else
echo "Database has already installed ...";
fi

/etc/init.d/mysql stop

echo "Start executer command"
exec "$@"