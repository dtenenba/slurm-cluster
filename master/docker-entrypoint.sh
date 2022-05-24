#!/bin/bash

sudo sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

sudo service munge start
sudo service slurmctld start

###
sudo /opt/ood/ood-portal-generator/sbin/update_ood_portal && sudo service apache2 restart
###

tail -f /dev/null
