#!/bin/bash -e
# Setup an Ubuntu box after a minimal install.
# Prefer snap and flatpak apps over apt packages.
#
# Copyright 2025 Thomas M. Parks <tmparks@yahoo.com>

if [ "$USER" != root -o "$SUDO_USER" = root -o -z "$SUDO_USER" ]
then
	echo Please use sudo to run this script!
	exit
fi

source /etc/os-release
DPKG_ARCHITECTURE=$(dpkg --print-architecture)

################################################################################
function purge_packages () {
	# Uninstall conflicting packages
	for package in $*
	do
		apt-get purge --autoremove --assume-yes $package || true # allowed to fail
	done
}

################################################################################
# Use in-memory filesystem for /tmp
# https://askubuntu.com/questions/1232004/mounting-tmp-as-tmpfs-on-ubuntu-20-04
function enable_tmpfs () {
	systemctl enable /usr/share/systemd/tmp.mount
}

################################################################################
# Install Flatpak
# https://flatpak.org/setup/Ubuntu
function install_flatpak () {
	add-apt-repository ppa:flatpak/stable
	apt-get update
	apt-get install --assume-yes \
		flatpak \
		gnome-software-plugin-flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

################################################################################
# Uninstall conflicting or obsolete docker packages
function purge_docker () {
	purge_packages \
		containerd \
		containerd.io \
		docker.io \
		docker-ce \
		docker-ce-cli \
		docker-doc \
		docker-buildx-plugin \
		docker-compose \
		docker-compose-v2 \
		docker-compose-plugin \
		podman-docker \
		runc
}

# Install official docker packages from docker.com
# https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository
# https://wiki.debian.org/DebianRepository/UseThirdParty
function install_docker_apt () {
	purge_docker

	# Add Docker's official GPG key:
	apt-get update
	apt-get install --assume-yes \
		ca-certificates \
		curl
	install --mode=0755 --directory /etc/apt/keyrings
	curl --fail --silent --show-error --location \
		--output /etc/apt/keyrings/docker.asc \
		https://download.docker.com/linux/ubuntu/gpg
	chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo "deb [arch=$DPKG_ARCHITECTURE signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $VERSION_CODENAME stable" > /etc/apt/sources.list.d/docker.list
	apt-get update

	# Install the latest version
	apt-get install --assume-yes \
		containerd.io \
		docker-ce \
		docker-ce-cli \
		docker-buildx-plugin \
		docker-compose-plugin

	# Add user to docker group
	usermod --append --groups docker $SUDO_USER
}

# Install docker snap
function install_docker_snap () {
	purge_docker

	# Install the latest stable version
	snap install docker

	# Add user to docker group
	usermod --append --groups docker $SUDO_USER
}

################################################################################
# Install firefox
# https://support.mozilla.org/en-US/kb/install-firefox-linux
function install_firefox () {
	purge_packages firefox firefox-locale-en
	snap install --channel=esr firefox
}

################################################################################
# Install Handbrake
# https://www.videolan.org/developers/libdvdcss.html
function install_handbrake_apt () {
	apt-get install --assume-yes \
		handbrake \
		libdvd-pkg
	dpkg-reconfigure libdvd-pkg
}

function install_handbrake_flatpak () {
	purge_packages handbrake libdvd-pkg
	flatpak install flathub \
		fr.handbrake.ghb \
		fr.handbrake.ghb.Plugin.dvdcss \
		fr.handbrake.ghb.Plugin.IntelMediaSDK
}

################################################################################
# Install VLC Media Player
# https://www.videolan.org/vlc/download-ubuntu.html
function install_vlc () {
	snap install vlc
}

################################################################################
# Install Visual Studio Code
# https://code.visualstudio.com/docs/setup/linux#_snap
function install_vscode () {
	snap install --classic code
}

################################################################################
function install_misc () {
	apt-get install --assume-yes \
		git \
		git-lfs \
		gnome-tweaks
}

################################################################################
function efi_label () {
	efibootmgr --verbose --create --disk /dev/sdb --part 1 \
		--loader '\EFI\ubuntu\shimx64.efi' \
		--label "$NAME $VERSION"

}

################################################################################
enable_tmpfs
install_flatpak
# install_docker_apt
install_docker_snap
install_firefox
# install_handbrake_apt
install_handbrake_flatpak
install_vlc
install_vscode
install_misc
# efi_label
