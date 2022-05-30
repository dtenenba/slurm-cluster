FROM ubuntu:20.04

RUN apt update -y && apt install munge -y && apt install vim -y && apt install build-essential -y && apt install git -y && apt-get install mariadb-server -y && apt install wget -y

ARG DEBIAN_FRONTEND=noninteractive
RUN apt install slurmd slurm-client -y
RUN apt install sudo -y && apt install python3.9 python3-pip -y && useradd -m admin -s /usr/bin/bash -d /home/admin && echo "admin:admin" | chpasswd && adduser admin sudo && echo "admin     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

COPY slurm.conf /etc/slurm-llnl/
COPY cgroup.conf /etc/slurm-llnl/
COPY docker-entrypoint.sh /etc/slurm-llnl/

EXPOSE 6817 6818 6819  

RUN apt update -y && apt install libopenmpi-dev -y && pip3 install mpi4py

###

# python packages

RUN pip3 install --upgrade pip
RUN pip3 install websockify numpy scipy flask sh

RUN /usr/bin/python3 -m pip uninstall -y markupsafe
RUN /usr/bin/python3 -m pip install markupsafe==2.0.1

# turbovnc

RUN apt-get install -y libxt6 x11-xkb-utils xkb-data curl

RUN curl -L -o /tmp/turbovnc.deb https://sourceforge.net/projects/turbovnc/files/2.2.7/turbovnc_2.2.7_amd64.deb/download
RUN dpkg -i /tmp/turbovnc.deb
RUN rm /tmp/turbovnc.deb

# ncat
RUN apt-get update -y
RUN apt-get install -y ncat

# R

RUN apt-get install -y --no-install-recommends software-properties-common dirmngr
RUN wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc > /dev/null

RUN apt-get update -y
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

RUN apt install -y --no-install-recommends r-base


# Apptainer

RUN apt-get install -y squashfs-tools

RUN curl -LO https://github.com/apptainer/apptainer/releases/download/v1.0.2/apptainer_1.0.2_amd64.deb
RUN dpkg -i apptainer_1.0.2_amd64.deb
RUN rm apptainer_1.0.2_amd64.deb

RUN mkdir -p /apps && chown -R admin:admin /apps


# shiny example app
RUN R -q -e 'install.packages("shiny", repos="https://cran.r-project.org")'



WORKDIR /apps
USER admin
RUN apptainer pull docker://openresty/openresty:alpine-amd64
# or wherever we were before
USER root
WORKDIR /

# RStudio Server

RUN apt-get install -y gdebi-core
RUN wget --no-verbose https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.2-485-amd64.deb
RUN gdebi -n rstudio-server-2022.02.2-485-amd64.deb
RUN rm rstudio-server-2022.02.2-485-amd64.deb

RUN service rstudio-server stop
RUN systemctl disable rstudio-server.service

RUN echo 'export PATH=$PATH:/usr/lib/rstudio-server/bin' |tee -a /etc/profile > /dev/null


RUN apt-get install -y proot # needed for RStudio Server

# RUN apt-get install -y nginx


# Anaconda

RUN curl -LO https://repo.anaconda.com/archive/Anaconda3-2022.05-Linux-x86_64.sh
RUN bash Anaconda3-2022.05-Linux-x86_64.sh -b -p /usr/local/anaconda3
RUN rm Anaconda3-2022.05-Linux-x86_64.sh


# Java

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
RUN apt-get update -y

RUN apt-get -y install adoptopenjdk-11-hotspot

# Cromwell

RUN curl -LO https://github.com/broadinstitute/cromwell/releases/download/79/cromwell-79.jar

RUN curl -LO https://github.com/broadinstitute/cromwell/releases/download/79/womtool-79.jar

RUN mkdir /usr/local/cromwell
RUN mv *.jar /usr/local/cromwell/

RUN ln -s /usr/bin/python3 /usr/bin/python

## mail

RUN apt-get install -y mailutils ssmtp
ADD ssmtp.conf /etc/ssmtp/


###

COPY openresty-with-session.sif /apps/

###

ENTRYPOINT ["/etc/slurm-llnl/docker-entrypoint.sh"]
