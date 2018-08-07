# Pre install JBoss EAP

Download software to

```
software\
jboss-eap-7.1.0.zip
p28279050_180181_Linux-x86-64.zip
```

Create software owner
```
useradd jboss-as
passwd jboss-as
```

Ensure unzip utility has been installed
```
yum install unzip
```

Ensure that a supported Java Development Kit (JDK) has been installed.

Install JDK 8  (As root?)  /usr/lib/jvm/default-java

```
unzip p28279050_180181_Linux-x86-64.zip
cd /opt
tar zxvf /root/jdk-8u181-linux-x64.tar.gz -C /opt
export PATH=/opt/jdk1.8.0_181/bin:$PATH
java -version

```





# Install JBoss  

(As root?)

```
cd /opt
cp /vagrant/software/jboss-eap-7.1.0.zip .
unzip jboss-eap-7.1.0.zip
chown -R jboss-as:jboss-as jboss-eap-7.1/   <---?
rm jboss-eap-7.1.0.zip
```

# Configure JBoss

Configuring JBoss EAP as a Service in Red Hat Enterprise Linux

As a minimum supply values for
- JBOSS_HOME
- JBOSS_USER




```
export EAP_HOME=/opt/jboss-eap-7.1
vi $EAP_HOME/bin/init.d/jboss-eap.conf

    ## Location of JDK
    JAVA_HOME="/opt/jdk1.8.0_181"

    ## Location of JBoss EAP
    JBOSS_HOME="/opt/jboss-eap-7.1"

    ## The username who should own the process.
    JBOSS_USER=jboss-as


cp $EAP_HOME/bin/init.d/jboss-eap.conf /etc/default
```
Copy the startup script
```
cp $EAP_HOME/bin/init.d/jboss-eap-rhel.sh /etc/init.d
chmod +x /etc/init.d/jboss-eap-rhel.sh
```
Add the new jboss_eap_rhel.sh to the list of automtically started services
```
chkconfig --add jboss-eap-rhel.sh
```
Start the service
```
service jboss-eap-rhel start
```
Make the service start automically on server startup
```
chkconfig jboss-eap-rhel.sh on
```

### Modify standalone.xml 

Change localhost for external IP address

```
vi /opt/jboss-eap-7.1/standalone/configuration/standalone.xml

    <interfaces>
        <interface name="management">
            <inet-address value="${jboss.bind.address.management:192.168.33.31}"/>
        </interface>
        <interface name="public">
            <inet-address value="${jboss.bind.address:192.168.33.31}"/>
        </interface>
    </interfaces>
```

Test
```
curl http://192.168.33.31:8080
```

### Add console admin user

To add a new user execute the add-user.sh script within the bin folder of your JBoss EAP 7 installation and enter the requested information.

```
sudo su - jboss-as

[jboss-as@localhost ~]$ /opt/jboss-eap-7.1/bin/add-user.sh

What type of user do you wish to add?
 a) Management User (mgmt-users.properties)
 b) Application User (application-users.properties)
(a):

Enter the details of the new user to add.
Using realm 'ManagementRealm' as discovered from the existing property files.
Username : anthony
Password recommendations are listed below. To modify these restrictions edit the add-user.properties configuration file.
 - The password should be different from the username
 - The password should not be one of the following restricted values {root, admin, administrator}
 - The password should contain at least 8 characters, 1 alphabetic character(s), 1 digit(s), 1 non-alphanumeric symbol(s)
Password :
WFLYDM0098: The password should be different from the username
Are you sure you want to use the password entered yes/no? yes
Re-enter Password :
What groups do you want this user to belong to? (Please enter a comma separated list, or leave blank for none)[  ]:
About to add user 'anthony' for realm 'ManagementRealm'
Is this correct yes/no? yes
Added user 'anthony' to file '/opt/jboss-eap-7.1/standalone/configuration/mgmt-users.properties'
Added user 'anthony' to file '/opt/jboss-eap-7.1/domain/configuration/mgmt-users.properties'
Added user 'anthony' with groups  to file '/opt/jboss-eap-7.1/standalone/configuration/mgmt-groups.properties'
Added user 'anthony' with groups  to file '/opt/jboss-eap-7.1/domain/configuration/mgmt-groups.properties'
Is this new user going to be used for one AS process to connect to another AS process?
e.g. for a slave host controller connecting to the master or for a Remoting connection for server to server EJB calls.
yes/no? yes
To represent the user add the following to the server-identities definition <secret value="YW50aG9ueQ==" />
```

# Check

```
ps -ef | grep java
```


# Troubleshooting

## Issue 1
```
Redirecting to /bin/systemctl start jboss-eap-rhel.service

Job for jboss-eap-rhel.service failed because a configured resource limit was exceeded. See "systemctl status jboss-eap-rhel.service" and "journalctl -xe" for details.
```

### Resolution
Verify that the JBOSS_USER variable is set. It should be set in the jboss-as.conf file that you placed in /etc/jboss-as per the installation documentation. If it is not, then this error will appear when you try to start the service.


## Issue 2
```
curl: (7) Failed connect to 192.168.33.31:8080; Connection refused
```
Connection refused

### Reason
By default (due to security reasons) JBoss AS binds only to localhost. If you want to access it via your hostname or IP, then you can edit the JBOSS_HOME/standalone/configuration/standalone.xml to change the "public" and "management" interfaces to point to the hostname of your system:

```
<interfaces>  
  <interface name="management">  
    <!-- bind to the hostname -->  
     <inet-address value="your-hostname"/>  
  </interface>  
  <interface name="public">  
    <!-- bind to the hostname -->  
     <inet-address value="your-hostname"/>  
 </interface>  
</interfaces> 
```



# Additional

zip install above is not the preferred method to install JBoss. To install JBoss use the jar method, however this requires the GUI


```
java -jar jboss-eap-7.1.0-installer.jar
```

Automated JBoss install

```
java -jar jboss-eap-7.1.0-installer.jar auto.xml
```

Use the jar installer to generate the xml for the automated install
Use a ```.variables``` file for passwords

Or pass them as parameters
```
java -jar jboss-eap-7.1.0-installer.jar auto.xml -variables adminPassword=password#2,vault.keystorepwd=vaultkeystorepw,ssl.password=user12345
```
#### NOTE
It is important that you do not have any spaces when specifying the -variables key/value pairs.

