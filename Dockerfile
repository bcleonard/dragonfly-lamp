FROM centos:7
MAINTAINER Bradley Leonard <bradley@stygianresearch.com>

# install httpd
RUN yum -y update\
 && yum -y install httpd wget\
 && yum clean all

RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf
RUN echo "<html><head></head><body><h1>It Works</h1></body></html>" > /var/www/html/index.html

EXPOSE 80

# install php
RUN yum -y install php\
 && yum clean all

RUN echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php

#ENV MYSQL_PACKAGE_URL https://repo.mysql.com/yum/mysql-5.5-community/docker/x86_64/mysql-community-server-minimal-5.5.43-2.el7.x86_64.rpm

# install mariadb
RUN yum -y install mariadb-server mariadb php-mysql hostname\
 && yum clean all\
 && echo "mysql_install_db" > /tmp/config\
 && echo "chown -R mysql.mysql /var/lib/mysql" >> /tmp/config\
 && echo "mysqld_safe &" >> /tmp/config\
 && echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config\
 && echo "mysqladmin -u root password drowssap" >> /tmp/config\
 && bash /tmp/config\
 && rm -f /tmp/config

VOLUME /var/lib/mysql

EXPOSE 3306

# install & conifgure Java, Tomcat and MySQL JDBC Drivers
RUN yum -y install java mysql-connector-java tomcat tomcat-webapps\
 && yum clean all\
 && sed -i '$i<role rolename="tomcat"/>\n<role rolename="manager-gui"/>\n<user username="tomcat" password="tomcat" roles="tomcat,manager-gui"/>' /etc/tomcat/tomcat-users.xml

EXPOSE 8080

ADD run.sh /tmp/run.sh
RUN chmod 755 /tmp/run.sh

CMD ["/tmp/run.sh"]
