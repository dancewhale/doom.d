#!/bin/bash


install_check () {
    pushd check
    git checkout 0.15.2
    apt-get install -y libtool texinfo
    autoreconf --install
    ./configure
    make
    make check
    sudo make install
    sudo ldconfig
    popd
}

install_rofi () {
    sudo apt-get install -y gcc make autoconf automake  pkg-config flex bison
    install_check
    sudo apt-get install -y libpangox-1.0-dev  libxkbcommon-dev libxcb-util0-dev  libxcb-ewmh-dev  libxcb-icccm4-dev  libxkbcommon-x11-dev libxcb-randr0-dev  libxcb-xinerama0-dev  libxcb-xrm-dev  libpango1.0-dev libstartup-notification0-dev  libgdk-pixbuf2.0-dev
    pushd rofi
    git checkout 1.6.1
    mkdir -p build
    pushd build
    ../configure
    make
    sudo make install
    popd
    popd
}
