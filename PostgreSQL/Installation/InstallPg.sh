yum install -y gcc python-devel epel-release
yum install -y python-psycopg2 python-pip PyYAML
yum install -y python2-pip
yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
yum install -y postgresql11-server
yum install -y postgresql11-contrib && echo PostgreSQL requirements were satisfied and installed. Please initialize db or install the other dependicies before completing the installation.
echo  The OS will change the current user as postgres.Continue with the other steps. 
sleep 2
echo  The PostgreSQL Version: 11.2
sleep 2
su - postgres