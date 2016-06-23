#!/bin/bash
ROOT_UID="0"
#Checking if run as root
if [ "$UID" -ne "$ROOT_UID" ]
	then
		echo "You must be root to run this script!"
		echo "sudo ./post_install_ubuntu"
		exit 1
fi

echo "# -------------------------------------------------------"
echo "#"
echo "#  Ubuntu 16.04 LTS Post-installation script - CINVESTAV 2016"
echo "#"
echo "# -------------------------------------------------------"
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
	apt-get -y install ppa-purge synaptic git terminator htop mc vim
	# complementary compression format
	apt-get -y install p7zip-rar p7zip-full unace unrar zip unzip sharutils rar uudeview mpack arj cabextract file-roller
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
	apt-get -y install ubuntu-restricted-extras
	apt-get -y install ffmpeg gxine libdvdread4 icedax tagtool libdvd-pkg libavcodec-extra gstreamer1.0-libav

	#Stuff
	apt-get -y install python-dev python-pip python-biopython samtools r-base
	#Add repositories Bio-Linux
#	echo "deb http://nebc.nerc.ac.uk/bio-linux/ unstable bio-linux" | tee -a /etc/apt/sources.list
#	apt-get update
#	Install keyring
#	apt-get -y --force-yes install bio-linux-keyring
#	apt-get update
	#BioLinux software
#	apt-get -y install bio-linux-base-directories
#       apt-get -y install bio-linux-paml bio-linux-phyml bio-linux-dotter bio-linux-mountapp bio-linux-treeview bio-linux-ape bio-linux-blixem bio-linux-fasta bio-linux-oligoarrayaux bio-linux-hmmer bio-linux-fastDNAml bio-linux-tree-puzzle bio-linux-estscan bio-linux-sequin bio-linux-migrate bio-linux-fluctuate bio-linux-recombine bio-linux-coalesce bio-linux-usb-maker bio-linux-nrdb bio-linux-grid bio-linux-grid-certs bio-linux-transterm-hp bio-linux-happy bio-linux-qtlcart bio-linux-cap3 bio-linux-blast+ bio-linux-clcsequenceviewer bio-linux-mothur bio-linux-mummer bio-linux-mrbayes-multi bio-linux-splitstree bio-linux-tetra bio-linux-trnascan bio-linux-arb bio-linux-mspcrunch bio-linux-lucy bio-linux-njplot bio-linux-netblast bio-linux-readseq bio-linux-seaview bio-linux-primer3 bio-linux-glimmer3 bio-linux-assembly-conversion-tools bio-linux-staden bio-linux-wise2 bio-linux-exchanger bio-linux-documentation bio-linux-rasmol bio-linux-ocount bio-linux-peptidemapper bio-linux-phylip bio-linux-dotur bio-linux-prank bio-linux-dust bio-linux-cd-hit bio-linux-mrbayes bio-linux-transterm bio-linux-mira bio-linux-omegamap bio-linux-chimeraslayer bio-linux-cdbfasta bio-linux-rbs-finder bio-linux-mview bio-linux-cytoscape bio-linux-python-cogent bio-linux-themes bio-linux-samtools bio-linux-clustal bio-linux-mesquite bio-linux-handlebar bio-linux-genquery bio-linux-sampledata bio-linux-das-prep bio-linux-dialign bio-linux-xcut bio-linux-backups bio-linux-ncbi-tools-x11 bio-linux-bldp-files bio-linux-big-blast bio-linux-priam bio-linux-blast bio-linux-tutorials bio-linux-jprofilegrid bio-linux-muscle bio-linux-rdp-classifier bio-linux-trace2dbest bio-linux-zsh bio-linux-artemis bio-linux-act bio-linux-mira-3rd-party bio-linux-pfaat bio-linux-pedro bio-linux-squint bio-linux-oligoarray bio-linux-prot4est bio-linux-maxd bio-linux-mcl bio-linux-keyring bio-linux-dendroscope bio-linux-denoiser bio-linux-envbase-for-pedro bio-linux-taxinspector bio-linux-forester bio-linux-partigene bio-linux-taverna bio-linux-jalview bio-linux-t-coffee bio-linux-stars bio-linux-biojava bio-linux-assembly-conversion-tools
#       apt-get -y install bio-linux-emboss bio-linux-emboss-kmenus bio-linux-glimmer3 bio-linux-pftools bio-linux-qiime bio-linux-themes-v5 bio-linux-clcworkbench bio-linux-barcodebase bio-linux-fasttree bio-linux-lamarc bio-linux-msatfinder bio-linux-yamap
#       update-menus
	# ------------------------------------------------------------

	# ----------------- System Cleanup ------------------
	apt-get -y autoremove
	apt-get -y autoclean
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
