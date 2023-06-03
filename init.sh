#!/bin/bash

cd /data/postgresql/data

sudo -u postgres createuser -h localhost -P firmadyne
sudo -u postgres createdb -h localhost -O firmadyne firmware
sudo -u postgres psql -h localhost -d firmware < /root/FirmAFL/firmadyne/database/schema