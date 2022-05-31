#!/bin/bash

whoami > /tmp/whoami.txt

sudo sed -i "s/REPLACE_IT/CPUs=$(nproc)/g" /etc/slurm-llnl/slurm.conf

sudo service munge start
sudo service slurmctld start

# sudo rm -rf /home/admin/ondemand/dev
# sudo chown -R admin:admin /user_apps/admin
# sudo ln -s /user_apps/admin /home/admin/ondemand/dev

git -C ~/ondemand/dev clone https://github.com/dtenenba/bc_osc_example_shiny.git || true
git -C ~/ondemand/dev clone https://github.com/dtenenba/bc_rcc_rstudio_server.git || true
git -C ~/ondemand/dev/bc_rcc_rstudio_server checkout rstudio-1.4-updates || true
git -C ~/ondemand/dev clone https://github.com/dtenenba/bc_example_jupyter.git || true
git -C ~/ondemand/dev clone https://github.com/dtenenba/flask_passenger_wsgi_hello.git || true
git -C ~/ondemand/dev clone https://github.com/dtenenba/bc_example_flaskapp.git || true

git -C ~/ondemand/dev/bc_osc_example_shiny pull || true
git -C ~/ondemand/dev/bc_osc_rstudio_server pull || true
git -C ~/ondemand/dev/bc_example_jupyter pull || true
git -C ~/ondemand/dev/flask_passenger_wsgi_hello pull || true
git -C ~/ondemand/dev/bc_example_flaskapp pull || true




###
sudo /opt/ood/ood-portal-generator/sbin/update_ood_portal && sudo service apache2 restart
###

tail -f /dev/null
