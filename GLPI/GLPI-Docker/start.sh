chmod -R 755 /var/www/html/glpi

chown -R apache:apache /var/www/html/glpi

echo '<VirtualHost *:80>
        ServerAdmin localhost
        ServerName localhost
        DocumentRoot /var/www/html/glpi
        ErrorLog "/var/log/httpd/glpi.com.log"
        CustomLog "/var/log/httpd/glpi.com.log" combined
        <Directory> /var/www/html/glpi/config>
                AllowOverride None
                Require all denied
        </Directory>
        <Directory> /var/www/html/glpi/files>
                AllowOverride None
                Require all denied
        </Directory>
</VirtualHost>' > /etc/httpd/conf.d/glpi.conf

rm -rf /run/httpd/* /tmp/httpd*
exec /usr/sbin/apachectl -DFOREGROUND