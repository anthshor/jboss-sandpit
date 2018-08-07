#!/bin/bash

DATE=`date +%Y-%m-%d:%H:%M:%S`

[ -f /proxy/proxy.env ] && source /proxy/proxy.env $1

# PreReqs

useradd jboss-as
echo jboss | passwd --stdin jboss-as

yum -y install unzip

cp /vagrant/software/p28279050_180181_Linux-x86-64.zip .
unzip -n p28279050_180181_Linux-x86-64.zip
[ -d /bin/java ] || mkdir /bin/java
[ -d /bin/java/jdk1.8.0_181 ] || tar zxvf jdk-8u181-linux-x64.tar.gz -C /bin/java
export PATH=/bin/java/jdk1.8.0_181/bin:$PATH
java -version


# Install JBoss

cd /opt
cp /vagrant/software/jboss-eap-7.1.0.zip .
unzip -n jboss-eap-7.1.0.zip
chown -R jboss-as:jboss-as jboss-eap-7.1/
rm jboss-eap-7.1.0.zip


# Configure JBoss

export EAP_HOME=/opt/jboss-eap-7.1
cp -p $EAP_HOME/bin/init.d/jboss-eap.conf $EAP_HOME/bin/init.d/jboss-eap.conf_bkp_${DATE}

grep ^JAVA_HOME $EAP_HOME/bin/init.d/jboss-eap.conf  > /dev/null || echo 'JAVA_HOME="/bin/java/jdk1.8.0_181"'>>$EAP_HOME/bin/init.d/jboss-eap.conf
grep ^JBOSS_HOME $EAP_HOME/bin/init.d/jboss-eap.conf  > /dev/null || echo 'JBOSS_HOME="/opt/jboss-eap-7.1"'>>$EAP_HOME/bin/init.d/jboss-eap.conf
grep ^JBOSS_USE $EAP_HOME/bin/init.d/jboss-eap.conf  > /dev/null || echo 'JBOSS_USER=jboss-as'>>$EAP_HOME/bin/init.d/jboss-eap.conf


cp $EAP_HOME/bin/init.d/jboss-eap.conf /etc/default
cp $EAP_HOME/bin/init.d/jboss-eap-rhel.sh /etc/init.d
chmod +x /etc/init.d/jboss-eap-rhel.sh
chkconfig --add jboss-eap-rhel.sh
service jboss-eap-rhel start
chkconfig jboss-eap-rhel.sh on


#   - Modify firewalld
systemctl stop firewalld


# @@TODO
#   - Modify standalone.xml for IP
#   - Add console admin user
