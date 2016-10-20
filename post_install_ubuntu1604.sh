#!/bin/bash
ROOT_UID="0"
#Checking if run as root
if [ "$UID" -ne "$ROOT_UID" ]
	then
		echo "You must be root to run this script!"
		echo "sudo ./post_install_ubuntu"
		exit 1
fi

echo "# -----------------------------------------------------------"
echo "#"
echo "#  Ubuntu 16.04 LTS Post-installation script - CINVESTAV 2016"
echo "#"
echo "# -----------------------------------------------------------"
echo
echo "Finishing the installation may take several minutes"
echo
echo "Do you want to continue (y/n)?"
echo
read yes
if [ "$yes" = "y" ]
	then
	# --------------- Full System Update ----------------
	apt-get -y update
	apt-get -y upgrade
	# ---------------------------------------------------
	# ---------------- System Utilities -----------------
	# package management tools
	apt-get -y install ppa-purge synaptic git terminator htop mc vim ncftp tree
	# complementary compression format
	apt-get -y install p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract file-roller apt-get install binfmt-support
	# ---------------------------------------------------
	# ------------------- Java Runtime ------------------
	apt-get -y install default-jre
	apt-get -y install icedtea-8-plugin openjdk-8-jre
	# ---------------------------------------------------
	# --------------- Latest Libre Office --------------
	add-apt-repository -y ppa:libreoffice/ppa
	apt-get update
	apt-get -y dist-upgrade
	apt-get -y install libreoffice libreoffice-pdfimport

#	gsettings set com.canonical.Unity.Launcher launcher-position Bottom
#	gsettings set com.canonical.Unity.Launcher launcher-position Left
	apt-get -y install unity-tweak-tool

	# ---------------------------------------------------
	# ------------------ Graphical Apps -----------------
	# misc graphical apps
	apt-get -y install inkscape gimp
	# ---------------------------------------------------
	# ------------ Multimedia Codecs & Flash ------------
	# medibuntu codecs & flash
	echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
	apt-get -y install ubuntu-restricted-extras nautilus-actions
	fc-cache -fv
	apt-get -y install ffmpeg gxine libdvdread4 icedax tagtool libdvd-pkg libavcodec-extra gstreamer1.0-libav

	#Stuff
	apt-get -y install python-dev python-pip python-biopython samtools

	#Install R repo para Ubuntu 14.04
	echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list
	apt-get update
	apt-get -y upgrade
	apt-get -y install r-base r-base-dev

	#Extra packages for QIIME
	apt-get -y install python-dev libncurses5-dev libssl-dev libzmq-dev libgsl-dev openjdk-8-jdk libxml2 libxslt1.1 libxslt1-dev ant git subversion build-essential zlib1g-dev libpng12-dev libfreetype6-dev libmeep-mpich2-8 libreadline-dev gfortran unzip libmysqlclient20 libmysqlclient-dev ghc sqlite3 libsqlite3-dev libc6-i386 libbz2-dev tcl-dev tk-dev libatlas-dev libatlas-base-dev liblapack-dev swig libhdf5-serial-dev


	# ----------------- System Cleanup ------------------
	apt-get autoremove && sudo apt-get autoclean && sudo apt-get clean
	# ---------------------------------------------------
	echo
	echo
	echo "########"
	echo "  DONE  "
	echo "########"
	echo
	echo
else
    exit
fi;
