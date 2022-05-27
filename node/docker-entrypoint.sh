#!/bin/bash

sudo sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

sudo service munge start
sudo slurmd -N $(hostname)

# sudo rm -rf /home/admin/ondemand/dev
# sudo chown -R admin:admin /user_apps/admin
# sudo ln -s /user_apps/admin /home/admin/ondemand/dev


tail -f /dev/null
