FROM ubuntu:jammy

RUN apt-get update && apt-get install -y \
    build-essential \
    autoconf \
    autogen \
    libtool \
    libdnet-dev \
    libpcap-dev \
    libmysqlclient-dev \
    libdaq-dev \
    git \
    make

RUN ln -s /usr/include/dumbnet.h /usr/include/dnet.h \
    && ldconfig

RUN git clone https://github.com/it-mak/barnyard2.git /usr/local/src/barnyard2 \
    && cd /usr/local/src/barnyard2 \
    && autoreconf -fvi \
    && ./configure --with-mysql --with-mysql-libraries=/usr/lib/x86_64-linux-gnu \
    && make \
    && make install \
    && mkdir /var/log/barnyard2

RUN apt-get purge -y build-essential autoconf autogen libtool git \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /usr/local/src/barnyard2

ENTRYPOINT ["barnyard2"]

CMD ["-c", "/etc/barnyard2.conf"]
