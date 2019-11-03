## Create CentOS7.7 Base Image with Core packages installed
FROM centos:7
ENV container docker
RUN yum -y update
## Install Base packages
RUN yum group install -y "Compute Node"

## Enable Systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]


## Enable SSHD
RUN yum install -y \
        openssh-server


RUN  mkdir /var/run/sshd
RUN echo 'root:Passw0rd' | chpasswd
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
RUN sed -i '/UseLogin no/a UseDNS no' /etc/ssh/sshd_config
RUN sshd-keygen

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
