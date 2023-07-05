FROM ubuntu:16.04

COPY ./files/ /tmp/files

WORKDIR /root

RUN sed -i "s/archive.ubuntu.com/mirrors.tencentyun.com/g" /etc/apt/sources.list && \
    apt update && \
    apt install -y curl wget git sudo vim bison flex unzip && \
    apt install -y binutils-dev libsdl1.2-dev zlib1g-dev libglib2.0-dev libbfd-dev build-essential binutils qemu libboost-dev libtool autoconf xorg-dev && \
    apt install -y busybox-static fakeroot dmsetup kpartx netcat-openbsd nmap python-psycopg2 python3-psycopg2 snmp uml-utilities util-linux vlan && \
#
    unzip /tmp/files/FirmAFL.zip -d /root/ && \
    mv /root/FirmAFL-master /root/FirmAFL && \
    unzip /tmp/files/firmadyne.zip -d /root/FirmAFL/ && \
    mv /root/FirmAFL/firmadyne-master /root/FirmAFL/firmadyne && \
    mv /tmp/files/binaries/* /root/FirmAFL/firmadyne/binaries/ && \
    cd /root/FirmAFL/user_mode/ && \
    sed -i '40s/static //' util/memfd.c && \
    ./configure --target-list=mipsel-linux-user,mips-linux-user,arm-linux-user --static --disable-werror && \
    make && \
    cd /root/FirmAFL/qemu_mode/DECAF_qemu_2.10/ && \
    sed -i '40s/static //' util/memfd.c && \
    ./configure --target-list=mipsel-softmmu,mips-softmmu,arm-softmmu --disable-werror && \
    make && \
#
    cd /root/ && \
    mv /tmp/files/get-pip.py ./ && \
    python ./get-pip.py && \
    mv /tmp/files/Python-3.7.16.tgz ./ && \
    tar -xvzf ./Python-3.7.16.tgz && \
    cd /root/Python-3.7.16 && \
    ./configure --prefix=/usr/local/python3 --with-ssl && \
    mkdir /usr/local/python3 && \
    make && make install && \
    rm /usr/bin/python3 && \
    ln -s /usr/local/python3/bin/python3 /usr/bin/python3 && \
    ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3 && \
    mkdir -p /root/.config/pip && \
    cp /tmp/files/pip.conf /root/.config/pip/pip.conf && \
    pip3 install setuptools==46.4.0 && \
#
    unzip /tmp/files/sources/console.zip -d /root/FirmAFL/firmadyne/sources/ && \
    mv /root/FirmAFL/firmadyne/sources/console-c36ae8553fa4e9c82e8a65752906641d81c2360c/* /root/FirmAFL/firmadyne/sources/console && \
    unzip /tmp/files/sources/extractor.zip -d /root/FirmAFL/firmadyne/sources/ && \
    mv /root/FirmAFL/firmadyne/sources/extractor-1c60407adfb9af46b97963fb1cf1ca5a80623de7/* /root/FirmAFL/firmadyne/sources/extractor && \
    unzip /tmp/files/sources/libnvram.zip -d /root/FirmAFL/firmadyne/sources/ && \
    mv /root/FirmAFL/firmadyne/sources/libnvram-68ad8e9a9c25cb9d1202c690c1469df59e3f7cb3/* /root/FirmAFL/firmadyne/sources/libnvram && \
    unzip /tmp/files/sources/scraper.zip -d /root/FirmAFL/firmadyne/sources/ && \
    mv /root/FirmAFL/firmadyne/sources/scraper-3a0c3f552c64c6f4b337e009ff62f1c8300063e6/* /root/FirmAFL/firmadyne/sources/scraper && \
    rm -r /root/FirmAFL/firmadyne/sources/console-c36ae8553fa4e9c82e8a65752906641d81c2360c/ && \
    rm -r /root/FirmAFL/firmadyne/sources/extractor-1c60407adfb9af46b97963fb1cf1ca5a80623de7/ && \
    rm -r /root/FirmAFL/firmadyne/sources/libnvram-68ad8e9a9c25cb9d1202c690c1469df59e3f7cb3/ && \
    rm -r /root/FirmAFL/firmadyne/sources/scraper-3a0c3f552c64c6f4b337e009ff62f1c8300063e6/ && \
#
    unzip /tmp/files/binwalk/binwalk-2.zip -d /root/FirmAFL/ && \
    apt -y install python-lzma python-dev && \
    mv /root/FirmAFL/binwalk-master /root/FirmAFL/binwalk && \
    cd /root/FirmAFL/binwalk/ && \
    sed -i '65s/python3/python/' ./deps.sh && \
    sed -i '162,168 s/^/#/' ./deps.sh && \
    sed -i '118s/master/v0.8.5-master/' ./deps.sh && \
    ./deps.sh && \
    sed -i '959s/subprocess.DEVNULL/open(os.devnull, '"'"'wb'"'"')/' /root/FirmAFL/binwalk/src/binwalk/modules/extractor.py && \
    python ./setup.py install && \
    pip install git+https://github.com/ahupp/python-magic && \
    pip install git+https://github.com/sviehb/jefferson && \
    unzip /tmp/files/binwalk/binwalk-3.zip -d /root/ && \
    mv /root/binwalk-master /root/binwalk && \
    cd /root/binwalk/ && \
    sed -i '150s/ -i https:\/\/mirrors.aliyun.com\/pypi\/simple\///' ./deps.sh && \
    sed -i '187,193 s/^/#/' ./deps.sh && \
    ./deps.sh && \
    python3 ./setup.py install && \
    apt -y install python3-magic && \
#
    cp /tmp/files/data.xz /root/FirmAFL/firmadyne/database/ && \
    cd /root/FirmAFL/firmadyne/database/ && \
    xz -d data.xz && \
    mv data scheme && \
    chmod +x schema && \
    apt install -y postgresql libpq-dev && \
    cd /var/lib/postgresql && \
    echo 'postgres:firmadyne' | chpasswd && \
    mkdir /data && \
    chmod o+w /data && \
#
    sudo -u postgres mkdir -p /data/postgresql/data && \
    sudo -u postgres /usr/lib/postgresql/9.5/bin/initdb -D /data/postgresql/data && \
    sed -i '4s/#FIRMWARE_DIR=\/home\/vagrant\/firmadyne\//FIRMWARE_DIR=\/root\/FirmAFL\/firmadyne\//' /root/FirmAFL/firmadyne/firmadyne.config && \
    cp /root/FirmAFL/firmadyne_modify/makeImage.sh /root/FirmAFL/firmadyne/scripts/ && \
    cp /tmp/files/init.sh /root/

ENTRYPOINT ["/tmp/files/start.sh"]