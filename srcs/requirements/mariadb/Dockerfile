FROM debian:buster

RUN apt update -y
RUN apt-get install -y mariadb-client mariadb-server vim \
&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld \
&& chown -R mysql:mysql /var/run/mysqld \
&& chmod 777 /var/run/mysqld

EXPOSE 3306

COPY ./tools/start.sh /usr/local/bin/
COPY ./conf/wordpress.sql /usr/local/bin/

RUN chmod +x  /usr/local/bin/start.sh
RUN chmod +x  /usr/local/bin/wordpress.sql

ENTRYPOINT [ "/usr/local/bin/start.sh" ]

# RUN service mysql start  && bash /usr/local/bin/start.sh && rm -f /usr/local/bin/wordpress.sql;
CMD ["mysqld", "--bind-address=0.0.0.0", "--user=mysql"]
