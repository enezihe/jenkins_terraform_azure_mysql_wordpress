FROM wordpress:latest
ENV WORDPRESS_DB_HOST=nbtdb-wordpress.mysql.database.azure.com
ENV WORDPRESS_DB_USER=nbt
ENV WORDPRESS_DB_PASSWORD=Password1234
ENV WORDPRESS_DB_NAME=wordpress
EXPOSE 80
