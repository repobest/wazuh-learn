[Wazuh-Server]
curl -sO https://packages.wazuh.com/4.8/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

[Wazuh-Agent]
```sh
wget https://github.com/osTicket/osTicket/releases/download/v1.17.2/osTicket-v1.17.2.zip -O OSTicket-v1.17.2.zip
apt install php-cgi php-fpm php-imap php-pear php-intl php-apcu php-common -y
chown -R www-data:www-data /var/www/html/osticket
mv /var/www/html/osticket/upload/include/ost-sampleconfig.php /var/www/html/osticket/upload/include/ost-config.php
sudo apt install php php-mysql php-cgi php-fpm php-cli php-curl php-gd php-imap php-mbstring php-xml-util php intl php-apcu php-common php-gettext php-bcmath
sudo nano /etc/php/7.2/fpm/php.ini
sudo systemctl restart php7.2-fpm
sudo apt install mysql-server
sudo mysql_secure_installation
pw:rumahsakit
sudo mysql -u root -p
CREATE DATABASE osticket_db;
CREATE USER 'osticket_user'@'localhost'
SELECT user,authentication_string,plugin,host FROM mysql.user;
SELECT user FROM mysql.user;
CREATE USER 'osticket_user'@'localhost' IDENTIFIED BY '0sticketPass';
CREATE USER 'osticket_user'@'localhost' IDENTIFIED BY 'rumahsakit';
GRANT ALL PRIVILEGES ON osticket_db.* TO 'osticket_user'@'localhost';
FLUSH PRIVILEGES;
SHOW DATABASES;
sudo cp include/ost-sampleconfig.php include/ost config.php
chmod 666 /var/www/html/osticket/upload/include/ost-config.php
sudo chown -R apache:apache /var/www/osticket
/var/www/html/osticket/

curl -XGET "http://localhost/users/?id=SELECT+*+FROM+users";
curl -XGET "http://localhost/users/?id=1' OR '1'='1"
