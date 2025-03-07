FROM ubuntu:20.04 AS quartusdeps
LABEL AUTHOR="Roberto Focosi, rfocosi@gmail.com"

ARG ALTERA_INSTALLPATH=/home/altera/13.1
ENV HOME=/home
ENV PATH="$PATH":"${ALTERA_INSTALLPATH}/quartus/bin"
ENV QUARTUS_64BIT=1

RUN apt update && apt upgrade -y && \
    apt install -y make gcc-multilib \
     libfontconfig1 \
     libsm6  \
     libxext6  \
     libxrender-dev \
     zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

FROM quartusdeps AS modelsimdeps

# https://www.intel.com/content/www/us/en/docs/programmable/683472/14-1/introduction.html
# https://cdrdv2-public.intel.com/704826/quartus_install-14.1-683472-704826.pdf
# The following additional RPM packages are required to run the ModelSim-Altera Edition software and
# SoC EDS on systems running Red Hat Linux Enterprise 6 and 7:
# 32-bit libraries: unixODBC-libs, unixODBC, ncurses, ncurses-libs, libzmq3, libXext, alsa-lib, libXtst, libXft, libxml2, libedit, libX11, libXi
RUN dpkg --add-architecture i386
RUN apt-get update && \
    apt-get install -y\
        expat:i386\
        fontconfig:i386\
        g++-multilib\
        gcc-multilib\
        lib32gcc-s1\
        lib32stdc++6\
        lib32z1\
        libc6:i386\
        libcanberra0:i386\
        libfreetype6:i386\
        libgtk-3-0:i386\
        libice6:i386\
        libncurses5:i386\
        libpng16-16:i386\
        libsm6:i386\
        libx11-6:i386\
        libxau6:i386\
        libxdmcp6:i386\
        libxext6:i386\
        libxext6:i386\
        libxft2:i386\
        libxi6:i386\
        libxml2:i386\
        libxrender1:i386\
        libxt6:i386\
        libxtst6:i386\
        libzmq5:i386\
        unixodbc:i386\
        zlib1g:i386\
    && rm -rf /var/lib/apt/lists/*

COPY libpng-1.2.59.tar /tmp/

WORKDIR /tmp/

RUN tar -xvf libpng-1.2.59.tar \
    && cd /tmp/libpng-1.2.59/ \
    && ./configure && make && make install \
    && rm -rf /tmp/libpng-1.2.59/  \
    && ldconfig

# https://gist.github.com/robodhruv/e2c0945cc78006b00d4206846bdb7657
RUN apt-get update \
    && apt-get install -y wget build-essential libxrender1:i386 \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://cfhcable.dl.sourceforge.net/project/freetype/freetype2/2.12.1/freetype-2.12.1.tar.gz -O /tmp/freetype-2.12.1.tar.gz \
    && cd /tmp/ \
    && tar xf /tmp/freetype-2.12.1.tar.gz \
    && cd /tmp/freetype-2.12.1 \
    && ./configure --build=i386-pc-linux-gnu "CFLAGS=-m32" "CXXFLAGS=-m32" "LDFLAGS=-m32" --with-zlib=no --with-png=no --with-harfbuzz=no \
    && make install \
    && ldconfig

FROM modelsimdeps AS withquartus
ADD quartus-install /tmp/quartus-install

WORKDIR /tmp/

RUN chmod +x ./quartus-install/components/*.run
RUN env QUARTUS_64BIT=1 ./quartus-install/components/QuartusSetupWeb-13.1.0.162.run --unattendedmodeui none --mode unattended --installdir $ALTERA_INSTALLPATH  \
    && env QUARTUS_64BIT=1 ./quartus-install/components/QuartusSetup-13.1.4.182.run --unattendedmodeui none --mode unattended --installdir $ALTERA_INSTALLPATH
    \
RUN apt purge -y make gcc \
    && apt autoremove -y \
    && rm -rf /tmp/*


ENV MODELSIM_DIR=$ALTERA_INSTALLPATH/modelsim_ase
RUN sed -i -e 's/linux_rh60/linux/' $MODELSIM_DIR/bin/vsim
RUN sed -i -e 's/MTI_VCO_MODE:-""/MTI_VCO_MODE:-"32"/' $MODELSIM_DIR/bin/vsim
RUN ln -s $MODELSIM_DIR/linux $MODELSIM_DIR/bin/linux
RUN mkdir -p $MODELSIM_DIR/bin/lib32 && cp /usr/local/lib/libfreetype* $MODELSIM_DIR/bin/lib32
ENV LD_LIBRARY_PATH=$MODELSIM_DIR/bin/lib32

WORKDIR ${HOME}

CMD ["/home/altera/13.1/quartus/bin/quartus"]
#CMD ["/home/altera/13.1/modelsim_ase/bin/vsim"]
