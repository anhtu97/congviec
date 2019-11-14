echo 'Setting timezone'
yum -y install ntp
ln -f -s /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime
ntpdate vn.pool.ntp.org
systemctl enable ntpd

echo 'Install mariaDB'
yum -y install mariadb-server mariadb-devel
systemctl enable mariadb
systemctl start mariadb
echo "Cau hinh cho mysql"
mysql_secure_installation

echo 'update mariaDB'
echo '[mariadb] 
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' > /etc/yum.repos.d/MariaDB10.repo
systemctl stop mariadb
yum remove mariadb-server mariadb mariadb-libs -y
yum clean all
yum -y install MariaDB-server MariaDB-client
systemctl start mysql
systemctl enable mysql


echo "Cau hinh cho mysql"
mysql_secure_installation
echo "Dang nhap mysql"
read -p "-username: "  user
read -p "-passsword: "  passwd
read -p "-database: "  database
echo "Infor username and passsword of glpi"
read -p "-glpi user:" glpiuser
read -p "-glpi pass:" glpipass

mysql -u$user -p$passwd -e "create database $database;"
mysql -u$user -p$passwd -e "create user '$glpiuser'@'localhost' identified BY '$glpipass';"
mysql -u$user -p$passwd -e "grant all privileges on $database.* to $glpiuser@localhost ;"
mysql -u$user -p$passwd -e "flush privileges;"

echo "Install php"
yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm -y 
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum install yum-utils -y
yum-config-manager --enable remi-php72
yum install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo php-imap php-pear php-devel httpd-devel pcre-devel gcc make php-pecl-apcu php-xmlrpc -y 
yum -y install httpd php php-mysql php-pdo php-gd php-mbstring  php-imap php-ldap
systemctl enable httpd
systemctl start httpd

echo "Install GLPI"
cd /var/www/
wget https://github.com/glpi-project/glpi/releases/download/9.3.2/glpi-9.3.2.tgz
tar -xvzf glpi-9.3.2.tgz

cd /var/www/
mv glpi glpi-9.3.2
ln -s glpi-9.3.2 glpi
chmod -R 755 /var/www/glpi-9.3.2
chown -R apache:apache /var/www/glpi-9.3.2

sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --reload

sed -i 's/;date\.timezone =/date\.timezone = Asia\/Ho_Chi_Minh/g' /etc/php.ini
systemctl restart httpd

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

echo '<VirtualHost *:80>

        ServerAdmin localhost
        ServerName localhost
        DocumentRoot /var/www/glpi

        ErrorLog "/var/log/httpd/glpi.techspacekh.com.log"
        CustomLog "/var/log/httpd/glpi.techspacekh.com.log" combined

        <Directory> /var/www/glpi/config>
                AllowOverride None
                Require all denied
        </Directory>

        <Directory> /var/www/glpi/files>
                AllowOverride None
                Require all denied
        </Directory>

</VirtualHost>' > /etc/httpd/conf.d/glpi.conf
systemctl restart httpd

reboot