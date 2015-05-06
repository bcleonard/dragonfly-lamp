#!/bin/sh

# run mariadb
mysqld_safe &

# start tomcat
/usr/libexec/tomcat/server start &

# start apache
/usr/sbin/httpd -DFOREGROUND
