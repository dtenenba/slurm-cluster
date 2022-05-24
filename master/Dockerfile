FROM ubuntu:20.04

RUN apt update -y && apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y && apt install wget -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurmd slurm-client slurmctld -y
RUN apt install sudo -y && apt install python3.9 python3-pip -y && useradd -m admin -s /usr/bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

RUN apt update -y && apt install libopenmpi-dev -y && pip3 install mpi4py

COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/
COPY docker-entrypoint.sh /etc/slurm-llnl/

###


RUN wget -O /tmp/ondemand-release.deb https://apt.osc.edu/ondemand/latest/ondemand-release-web-latest_2_all.deb
RUN apt install -y /tmp/ondemand-release.deb
RUN apt install -y apt-transport-https
# TODO switch to release version at some point
# instead of nightly
RUN echo "deb [arch=amd64] https://apt.osc.edu/ondemand/nightly/web/apt focal main" | tee -a /etc/apt/sources.list.d/ondemand-web.list > /dev/null
RUN apt-get update -y
RUN apt-get install -y ondemand
RUN rm /tmp/ondemand-release.deb


RUN pip3 install flask sh ipython websockify

RUN apt-get install -y libapache2-mod-authnz-pam


RUN a2enmod ssl
RUN a2enmod proxy_wstunnel
RUN a2enmod authnz_pam

RUN mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak

# RUN cp /etc/pam.d/sshd /etc/pam.d/ood
COPY pam.d/ood /etc/pam.d/

RUN chmod 640 /etc/shadow
RUN chgrp www-data /etc/shadow


# allow admin to develop apps

RUN mkdir -p /var/www/ood/apps/dev/admin
WORKDIR  /var/www/ood/apps/dev/admin
RUN mkdir -p /home/admin/ondemand/dev && chown admin:www-data /home/admin/ondemand/dev
RUN ln -s /home/admin/ondemand/dev gateway
WORKDIR /home/admin

# configure openondemand

COPY ood-config/ood_portal.yml /etc/ood/config/
COPY ood-config/clusters.d/cluster.yml /etc/ood/config/clusters.d/

# set up shell command

RUN mkdir -p /etc/ood/config/apps/shell/
COPY shell/env /etc/ood/config/apps/shell/
COPY shell/ssh_wrapper /usr/bin/




###

EXPOSE 6817 6818 6819 3306 

WORKDIR /home/admin

ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
