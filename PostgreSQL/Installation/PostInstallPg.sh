echo  Installing Patroni Packages
yum install -y gcc python-devel epel-release
yum install -y python-psycopg2 python-pip PyYAML
yum install -y python2-pip
pip install --upgrade pip
pip install --upgrade setuptools
pip install patroni
pip install python-etcd
pip install --ignore-installed psycopg2-binary

echo  Installing Monitoring Packages
yum install -y htop
yum install -y pg_activity
