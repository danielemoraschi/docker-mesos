FROM dmoraschi/centos7

RUN yum install -y tar wget
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
ADD wandisco-svn.repo /etc/yum.repos.d/wandisco-svn.repo
RUN yum groupinstall -y "Development Tools"
RUN yum install -y apache-maven python-devel java-1.7.0-openjdk-devel zlib-devel libcurl-devel openssl-devel cyrus-sasl-devel cyrus-sasl-md5 apr-devel subversion-devel apr-util-devel


WORKDIR /root
RUN git clone https://git-wip-us.apache.org/repos/asf/mesos.git 
WORKDIR /root/mesos
RUN ./bootstrap
RUN mkdir build
WORKDIR /root/mesos/build
RUN ../configure
RUN make
RUN make install

RUN ./bin/mesos-master.sh --ip=127.0.0.1 --work_dir=/var/lib/mesos && ./bin/mesos-slave.sh --master=127.0.0.1:5050
ENTRYPOINT /bin/bash
