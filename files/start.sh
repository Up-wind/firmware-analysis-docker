#!/bin/bash

cd /data/postgresql/data
sudo -u postgres /usr/lib/postgresql/9.5/bin/pg_ctl -D /data/postgresql/data -l logfile start

tail -f /dev/null
