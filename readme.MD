# Create JBoss EAP sandpit

Download software to

```
software\
jboss-eap-7.1.0.zip
p28279050_180181_Linux-x86-64.zip
```


```
vagrant up
```

## Post steps not yet automated

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

#### Test
```
curl http://192.168.33.31:8080
```

### Add console admin user

To add a new user execute the add-user.sh script within the bin folder of your JBoss EAP 7 installation and enter the requested information.

```
sudo su - jboss-as
export PATH=/bin/java/jdk1.8.0_181/bin:$PATH

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