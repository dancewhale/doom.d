#!/bin/bash

# install fzf package
install_fzf () {
pushd fzf
sudo apt-get install -y highlight golang
make
sudo make install
./install
popd
}

# setting local proxy network
install_proxy_network () {
echo "you should install and configure trojan"
sudo apt-get install -y redsocks privoxy
sudo cp -r etc/redsocks.conf  /etc/
sudo cp -r etc/privoxy        /etc/
sudo service redsocks restart
sudo service privoxy  restart
sudo cp   bin/proxy*  /usr/local/bin/
}

install_trojan () {
echo "start to install trojan"
sudo tar xvf tar/trojan-1.14.1-linux-amd64.tar.xz  -C /root
sudo mv /root/trojan  /root/.trojan
sudo cp  etc/systemd/system/trojan.service  /etc/systemd/system/
sudo systemctl daemon-reload
sudo service trojan start
} 

# install pritunl
install_pritunl () {
    sudo rm  /etc/apt/sources.list.d/pritunl.list
    echo 'deb https://repo.pritunl.com/stable/apt focal main' | sudo tee -a /etc/apt/sources.list.d/pritunl.list
    
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    sudo apt-get update
    sudo apt-get install -y pritunl-client-electron
}

# install dropbox
install_dropbox () {
    sudo dpkg -i deb/dropbox_2020.03.04_amd64.deb
    sudo apt-get install -f
    dropbox start -i
    dropbox autostart
    dropbox proxy manual http localhost 1091
}
# dropbox limit client number.
#which   dropbox                                   || install_dropbox

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

export  $(grep CODENAME /etc/os-release | xargs)


which   fzf                                       || install_fzf
which   rofi                                      || install_rofi
which   copyq                                     || sudo apt-get install -y copyq
netstat -apn  |grep "0.0.0.0:1091"                || install_proxy_network
find /root/.trojan -name "trojan" -type d         || install_trojan
dpkg -l       |grep pritunl-client-electron       || install_pritunl
