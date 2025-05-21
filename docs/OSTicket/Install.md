```sh
# Step 1 – Install Apache and PHP
apt install apache2 php php-cli php-common php-imap php-redis php-snmp php-xml php-zip php-mbstring php-curl php-mysqli php-gd php-intl php-apcu libapache2-mod-php unzip -y

## After the installation, start and enable the Apache service.
systemctl start apache2
systemctl enable apache2

# Step 2 – Install and Configure MariaDB Database
## First, install the MariaDB database server using the following command:
apt install mariadb-server -y

## Next, connect to the MariaDB shell.
mysql
## After connecting to the MariaDB, create a database and user for osTicket.

CREATE DATABASE osticketdb;
GRANT ALL PRIVILEGES ON osticketdb.* TO osticket@localhost IDENTIFIED BY "osticketpass";
FLUSH PRIVILEGES;
EXIT;

# Step 3 – Install osTicket
## First, change the directory to Apache web root and download the latest osTicket version inside that directory.

cd /var/www/html; curl -s https://api.github.com/repos/osTicket/osTicket/releases/latest | grep browser_download_url | cut -d '"' -f 4 | wget -i -

## Next, unzip the downloaded file.
unzip osTicket*.zip -d osTicket

## Next, copy the osTicket sample configuration file.
cp /var/www/html/osTicket/upload/include/ost-sampleconfig.php /var/www/html/osTicket/upload/include/ost-config.php 

## Then, set the necessary permissions and ownership to the osTicket directory.
chown -R www-data:www-data /var/www/html/osTicket/
chmod -R 775 /var/www/html/osTicket/

# Step 4 – Configure Apache for osTicket
## Next, create an Apache virtual host configuration file for osTicket.
nano /etc/apache2/sites-available/osticket.conf

## Add the following configuration:
<VirtualHost *:80>
ServerName osticket.example.com
DocumentRoot /var/www/html/osTicket/upload

<Directory /var/www/html/osTicket>
AllowOverride All
</Directory>

ErrorLog ${APACHE_LOG_DIR}/error.log
CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

## Save and close the file, activate the Apache virtual host, and enable the Apache rewrite module.
a2enmod rewrite
a2ensite osticket.conf

## Finally, restart the Apache service to apply the changes.
systemctl reload apache2

# Step 5 – Access osTicket Web UI
## Now, open your web browser and access the osTicket using the URL http://osticket.example.com. You will see the osTicket prerequisites page.



 

## Click on Continue. You will see the osTicket configuration page.



 



## Provide your helpdesk name, URL, admin username, password, email, and database credentials, then click on Install Now. Once the osTicket is installed, you will see the following page.



 

## Click on Your Staff Control Panel. You will see the osTicket login page.



## Provide your admin username and password and click on Log In. You will see the osTicket system settings page.



## Modify the default settings as needed and click on the Dashboard tab. The osTicket dashboard will appear on the following page.



## Finally, remove the osTicket installation directory using the following command:

## rm -rf /var/www/html/osTicket/upload/setup/

## Conclusion
## osTicket provides businesses with a robust and customizable solution for managing customer support tickets efficiently. Using osTicket, organizations can centralize their support operations, streamline ticket management processes, and improve customer satisfaction. You can now test the osTicket application on dedicated server hosting from Atlantic.Net!