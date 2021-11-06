#!/bin/sh
echo "
Welcome to the

███████╗███████╗    ██████╗ ███████╗
██╔════╝╚══███╔╝   ██╔═══██╗██╔════╝
█████╗    ███╔╝    ██║   ██║███████╗
██╔══╝   ███╔╝     ██║   ██║╚════██║
███████╗███████╗██╗╚██████╔╝███████║
╚══════╝╚══════╝╚═╝ ╚═════╝ ╚══════╝        

After install helper. Relax, take a break and in a few minutes enjoy your new 
system! ;).
"

echo "
###################################################
        Config Git folder
###################################################
"

mkdir git

echo "Done!"

echo "
###################################################
        INSTALLING AUR HELPER
###################################################
"

cd git
git clone https://aur.archlinux.org/paru.git
cd paru
sudo makepkg -si
cd ../..

echo "Done!"

echo "
###################################################
        INSTALLING UTILITY PACKAGES
###################################################
"

sudo pacman -S --needed - < pkgs/utility_pkglist.txt --noconfirm

sudo paru -S pamac-aur pamac-tray-icon-plasma

sudo paru -S foxitreader google-chrome vitables wps-office kalendar-git

echo "Done!
"

echo "
###################################################
        INSTALLING WORK PACKAGES
###################################################
"

sudo pacman -S --needed - < pkgs/work_pkglist.txt --noconfirm

sudo paru -S visual-studio-code-bin teams webapp-manager armadillo 

conda install nomkl numpy scipy pandas numexpr scikit-learn bokeh matplotlib jupyter jupyterlab numba openblas pip pep8 autopep8 pylint sympy cvxpy tqdm dash tenssorflow keras plotly nodejs h5py
pip install tensorly tikzplotlib cvxopt

jupyter labextension install @jupyter-widgets/jupyterlab-manager

echo "Done!
"

echo "
###################################################
        INSTALLING CUSTOMIZATION PACKAGES
###################################################
"

sudo paru -S paper-icon-theme-git ttf-meslo-nerd-font-powerlevel10k

echo "set -g default-terminal \"screen-256color\"" > .tmux.conf

echo "Done!
"

echo "All done. Bye!

  ██╗ 
██╗╚██╗
╚═╝ ██║
██╗ ██║
╚═╝██╔╝
   ╚═╝ 
"
