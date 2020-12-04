#!/bin/bash
chmod +x ~/.emacs.d/bin/doom

~/.emacs.d/bin/doom sync

# install zsh and theme.
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
pip install powerline-status --user

# install fonts
pushd /tmp
git clone https://github.com/powerline/fonts.git --depth=1
pushd fonts
./install.sh
popd

# install color theme.
git clone https://github.com/altercation/solarized
pushd solarized/iterm2-colors-solarized/
open .
popd

# install agnoster
git clone https://github.com/fcamblor/oh-my-zsh-agnoster-fcamblor.git
pushd oh-my-zsh-agnoster-fcamblor/
./install
sed -i "s/ZSH_THEME/agnoster/g" ~/.zshrc
