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
install_printul () {
    echo 'https://repo.pritunl.com/stable/apt $UBUNTU_CODENAME main' > /etc/apt/sources.list.d/pritunl.list
    
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

# install rofi
install_rofi () {
    echo "start to install rofi,if you under 20.10 and want latest version, Please install from build."
    sudo apt-get install -y rofi
    # build need many package extend in install docs.
    #   apt-get install gcc make autoconf automake pkg-config flex bison check libxkbcommon0 libxkbcommon-dev  libglib2.0-dev  xcb  texinfo
    # you should upgrade check to new under 20.10 ubuntu.
    # https://github.com/libcheck/check
}

export  $(grep CODENAME /etc/os-release | xargs)


which   fzf                                       || install_fzf
netstat -apn  |grep "0.0.0.0:1091"                || install_proxy_network
find /root/.trojan -name "trojan" -type d         || install_trojan
dpkg -l       |grep pritunl-client-electron       || install_pritunl
dpkg -l       |grep rofi                          || install_rofi
