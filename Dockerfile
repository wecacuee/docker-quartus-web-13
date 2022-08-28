FROM i386/debian:bullseye
MAINTAINER Roberto Focosi, rfocosi@gmail.com

ENV HOME=/home
ENV PATH=$PATH:/home/altera/13.1/quartus/bin

RUN apt update && apt upgrade -y && \
    apt install -y make gcc zlib1g-dev libsm6 libxext6 libxrender-dev

COPY libpng-1.2.59.tar /tmp/

WORKDIR /tmp/

RUN tar -xvf libpng-1.2.59.tar

WORKDIR /tmp/libpng-1.2.59/

RUN ./configure && make && make install

RUN ldconfig

ADD quartus-install /tmp/quartus-install

WORKDIR /tmp/quartus-install

RUN ./QuartusSetupWeb-13.1.0.162.run --unattendedmodeui none --mode unattended --installdir /home/altera/13.1
RUN ./QuartusSetup-13.1.4.182.run --unattendedmodeui none --mode unattended --installdir /home/altera/13.1

RUN apt purge -y make gcc
RUN apt autoremove -y
RUN rm -rf /tmp/*

WORKDIR ${HOME}

CMD ["/home/altera/13.1/quartus/bin/quartus"]
