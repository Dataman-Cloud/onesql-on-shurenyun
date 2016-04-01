#!/bin/bash

__mysql_config() {
# Hack to get MySQL up and running... I need to look into it more.
echo "Running the mysql_config function."
cp /etc/onesql/my.cnf /data/onesql/data/
/usr/local/onesql/scripts/mysql_install_db --defaults-file=/data/onesql/data/my.cnf --basedir=/usr/local/onesql/ --user=root
touch /data/onesql/data/mysql_install_db_success
/usr/local/onesql/bin/mysqld_safe --defaults-file=/data/onesql/data/my.cnf --basedir=/usr/local/onesql/ --user=root --socket=/tmp/mysql3306.sock & 
sleep 10
}



__start_mysql() {
echo "Running the start_mysql function."
/usr/local/onesql/bin/mysqladmin --socket=/tmp/mysql3306.sock -u root password mysqlPassword
/usr/local/onesql/bin/mysql --socket=/tmp/mysql3306.sock -uroot -pmysqlPassword -e "CREATE DATABASE testdb"
/usr/local/onesql/bin/mysql --socket=/tmp/mysql3306.sock -uroot -pmysqlPassword -e "GRANT ALL PRIVILEGES ON testdb.* TO 'testdb'@'localhost' IDENTIFIED BY 'mysqlPassword'; FLUSH PRIVILEGES;"
/usr/local/onesql/bin/mysql --socket=/tmp/mysql3306.sock -uroot -pmysqlPassword -e "GRANT ALL PRIVILEGES ON *.* TO 'testdb'@'%' IDENTIFIED BY 'mysqlPassword' WITH GRANT OPTION; FLUSH PRIVILEGES;"
/usr/local/onesql/bin/mysql --socket=/tmp/mysql3306.sock -uroot -pmysqlPassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'mysqlPassword' WITH GRANT OPTION; FLUSH PRIVILEGES;"
/usr/local/onesql/bin/mysql --socket=/tmp/mysql3306.sock -uroot -pmysqlPassword -e "select user, host FROM mysql.user;"
killall mysqld
sleep 10
}

# Call all functions

if [ ! -e /data/onesql/data/mysql_install_db_success ]
then
    __mysql_config
    __start_mysql
fi
