echo "Provisioning"
echo "============"
# We don't want debconf prompts
export DEBIAN_FRONTEND=noninteractive
export PERL_MM_USE_DEFAULT=1
export JAVA_HOME=/usr/lib/jvm/java-6-openjdk
# export W3C_VALIDATOR_CFG=/etc/w3cvalidator/validator.conf

echo "Running initial apt-get update"
apt-get -y update >/dev/null

echo "Install dependencies"
apt-get -y install build-essential git vim screen \
    tomcat7  tomcat7-admin default-jdk \
    mysql-client mysql-server \
    php5-common libapache2-mod-php5 php5-gd php5-cli php5-mysql

echo "Configure MySQL"
# root password ...

# see:
# http://validator.w3.org/docs/install.html#install-fromsource
# http://www.mattzuba.com/2011/03/install-w3c-markup-validation-service-on-ubuntu/
# https://gist.github.com/magnetikonline/5965406
echo "Install w3c validator dependencies"
apt-get -y install opensp libosp-dev libtidy-dev apache2-mpm-prefork libapache2-mod-perl2 libxml-libxml-perl
cpan Bundle::W3C::Validator


echo "Download and install w3c validator"
mkdir -p /usr/local/validator
curl -O http://validator.w3.org/validator.tar.gz
tar zxvf validator.tar.gz
mv validator-1.3/{htdocs,share,httpd} /usr/local/validator

curl -O http://validator.w3.org/sgml-lib.tar.gz
tar zxvf sgml-lib.tar.gz
mv validator-1.1/htdocs/sgml-lib/ /usr/local/validator/htdocs/


echo "Install validator.nu for HTML5"
# see: http://about.validator.nu/#src
curl -L -O https://github.com/validator/validator.github.io/releases/download/20140222/vnu-20140222.zip
unzip vnu-20140222.zip
mv vnu /usr/local/

mv /home/vagrant/config/vnu/vnu_daemon /etc/init.d/vnu
chmod +x /etc/init.d/vnu

# start validator
#java -Xss512k -cp /usr/local/vnu/vnu.jar nu.validator.servlet.Main 8888

echo "Configure w3c validator"
mkdir -p /etc/w3c
cp /usr/local/validator/htdocs/config/* /etc/w3c

# copy configuraiton files
cp /home/vagrant/config/validator.conf /etc/w3c
cp /home/vagrant/config/apache2/w3c-validator.conf /etc/apache2/conf-available/
# cp /usr/local/validator/httpd/conf/httpd.conf /etc/w3c
# ln -fs /etc/w3c/httpd.conf /etc/apache2/conf-available/w3c-validator.conf

echo "Install css validator"
cp /home/vagrant/config/css-validator.war /var/lib/tomcat7/webapps/


echo "Install AChecker"
curl -L -o achecker.zip https://github.com/atutor/AChecker/archive/master.zip
unzip achecker.zip
mv AChecker-master /var/www/html/achecker


echo "Configure AChecker"
mysql < /home/vagrant/config/achecker/createdb.sql
mysql achecker < /home/vagrant/config/achecker/achecker_dump.sql
mv /home/vagrant/config/achecker/config.inc.php /var/www/html/achecker/include/config.inc.php
mkdir -p /var/www/html/achecker/temp
chown www-data:www-data -R /var/www/html/achecker/


# Permissions - chown www-data:www-data -R /usr/local/validator/

echo "Configure Apache2"
a2enmod rewrite
a2enmod expires
a2enmod include
a2enmod php5
a2enconf w3c-validator
service apache2 restart
# TODO: it is necessary()
# update-rc.d tomcat7 enable
service tomcat7 restart
update-rc.d vnu enable
# ACHECKER API - 78495f0ba58afa678a87e97733ba7e96b9143433
