yum -y install wget curl nano git 

cd /var/www/

wget https://github.com/glpi-project/glpi/releases/download/9.3.1/glpi-9.3.1.tgz

tar -xvzf glpi-9.3.1.tgz

mv glpi glpi-9.3.1

ln -s glpi-9.3.1 glpi

chmod -R 755 /var/www/glpi-9.3.1

chown -R apache:apache /var/www/glpi-9.3.1

echo '<VirtualHost *:80>

        ServerAdmin localhost
        ServerName localhost
        DocumentRoot /var/www/glpi

        ErrorLog "/var/log/httpd/glpi.com.log"
        CustomLog "/var/log/httpd/glpi.com.log" combined

        <Directory> /var/www/glpi/config>
                AllowOverride None
                Require all denied
        </Directory>

        <Directory> /var/www/glpi/files>
                AllowOverride None
                Require all denied
        </Directory>

</VirtualHost>' > /etc/httpd/conf.d/glpi.conf

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND