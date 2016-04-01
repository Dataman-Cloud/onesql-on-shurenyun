# "ported" by Adam Miller <maxamillion@fedoraproject.org> from
#   https://github.com/fedora-cloud/Fedora-Dockerfiles
#
# Originally written for Fedora-Dockerfiles by
#   scollier <scollier@redhat.com>

FROM centos:centos6
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update
RUN yum clean all
RUN yum -y install wget
RUN yum -y install tar
RUN yum -y install perl
RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install pwgen supervisor bash-completion psmisc net-tools; yum clean all
RUN wget -P /opt http://www.onexsoft.cn/software/onesql-5.6.27-all-rhel6-linux64.tar.gz
RUN cd /opt && tar zxvf onesql-5.6.27-all-rhel6-linux64.tar.gz -C /usr/local/
RUN ln -s /usr/local/onesql5627 /usr/local/onesql
RUN mkdir -p /etc/onesql
RUN mkdir -p /data/onesql/data
RUN mkdir -p /data/onesql/data/92bin

ADD my.cnf /etc/onesql/my.cnf
ADD ./run.sh /run.sh
ADD ./config_mysql.sh /config_mysql.sh
ADD ./supervisord.conf /etc/supervisord.conf
ADD ./initDB.sh /initDB.sh

# RUN echo %sudo	ALL=NOPASSWD: ALL >> /etc/sudoers

RUN chmod 755 /run.sh
RUN chmod 755 /config_mysql.sh
#RUN /config_mysql.sh

EXPOSE 3306

# CMD ["/bin/bash", "/start.sh"]
CMD ["/bin/bash", "/run.sh"]
