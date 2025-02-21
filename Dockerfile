FROM ubuntu:20.04
LABEL AUTHOR="Roberto Focosi, rfocosi@gmail.com"

ARG ALTERA_INSTALLPATH=/home/altera/13.1
ENV HOME=/home
ENV PATH="$PATH":"${ALTERA_INSTALLPATH}/quartus/bin"

RUN apt update && apt upgrade -y && \
    apt install -y make gcc-multilib \
     libfontconfig1 \
     libsm6  \
     libxext6  \
     libxrender-dev \
     zlib1g-dev

COPY libpng-1.2.59.tar /tmp/

WORKDIR /tmp/

RUN tar -xvf libpng-1.2.59.tar

WORKDIR /tmp/libpng-1.2.59/

RUN ./configure && make && make install

RUN ldconfig

ADD quartus-install /tmp/quartus-install

WORKDIR /tmp/

RUN chmod +x ./quartus-install/components/*.run
RUN env QUARTUS_64BIT=1 ./quartus-install/components/QuartusSetupWeb-13.1.0.162.run --unattendedmodeui none --mode unattended --installdir $ALTERA_INSTALLPATH
RUN env QUARTUS_64BIT=1 ./quartus-install/components/QuartusSetup-13.1.4.182.run --unattendedmodeui none --mode unattended --installdir $ALTERA_INSTALLPATH

RUN apt purge -y make gcc
RUN apt autoremove -y
RUN rm -rf /tmp/*

WORKDIR ${HOME}
ENV QUARTUS_64BIT=1

CMD ["/home/altera/13.1/quartus/bin/quartus"]
