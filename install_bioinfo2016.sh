#!/bin/bash
echo "======================================================================="
echo " 		Install packages:"
echo ""
echo "* FastQC"
echo "* "
echo "* Trimmomatic"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""

echo "======================================================================="

echo ""
date
echo ""




wget http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5_source.zip

wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-0.36.zip

mkdir -p $HOME/bin

cat <<EOF >> $HOME/.bashrc
if [ -d "$HOME/bin" ] ; then
    export PATH="\$HOME/bin:\$PATH"
fi
EOF

cat <<EOF >> $HOME/.bashrc
extract () {
  if [ -f \$1 ] ; then
          case \$1 in
                  *.tar.bz2)    tar xzf \$1     ;;
                  *.bz2)        bunzip2 \$1     ;;
                  *.rar)        rar x \$1       ;;
                  *.gz)         gunzip \$1      ;;
                  *.tar)        tar xf \$1      ;;
                  *.tbz2)       tar xjf \$1     ;;
                  *.tgz)        tar xzf \$1     ;;
                  *.zip)        unzip \$1       ;;
                  *.Z)          uncompress \$1  ;;
                  *)            echo "'\$1' cannot be extracted via extract()" ;;
          esac
  else
        echo "'\$1' is not a valid file"
  fi
}
EOF


echo "export R_LIBS=/home/zorbax/bin/R" >> $HOME/.bashrc
echo "PATH=\"\$HOME/bin/perl5/bin\${PATH+:}\${PATH}\"; export PATH;" >> $HOME/.bashrc
echo "PERL5LIB=\"\$HOME/bin/perl5/lib/perl5\${PERL5LIB+:}\${PERL5LIB}\"; export PERL5LIB;" >> $HOME/.bashrc


#INSTALL QIIME
#Install R repo para Ubuntu 14.04
echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install r-base r-base-dev

#Necesita los siguientes paquetes
sudo apt-get -y install python-dev libncurses5-dev libssl-dev libzmq-dev libgsl-dev openjdk-8-jdk libxml2 libxslt1.1 libxslt1-dev ant git subversion build-essential zlib1g-dev libpng12-dev libfreetype6-dev libmeep-mpich2-8 libreadline-dev gfortran unzip libmysqlclient20 libmysqlclient-dev ghc sqlite3 libsqlite3-dev libc6-i386 libbz2-dev tcl-dev tk-dev libatlas-dev libatlas-base-dev liblapack-dev swig libhdf5-serial-dev

### QIIME v 1.9.1

wget https://github.com/biocore/qiime/archive/1.9.1.tar.gz

###  Dependencias python

sudo pip install setuptools biom-format numpy scipy


#Compilar e instalar

python setup.py build

python setup.py install --install-scripts=/path/to/bin/ --install-purelib=/path/to/lib/


### Dependencias R (Version ≥ 3.0.0)
echo "install.packages(c('ape', 'biom', 'optparse', 'RColorBrewer', 'randomForest', 'vegan'))" >> install_packages.R
echo "source('http://bioconductor.org/biocLite.R')" >> install_packages.R
echo "biocLite(c('DESeq2', 'metagenomeSeq'))" >> install_packages.R
echo "q()" >> install_packages.R

Rscript install_packages.R
rm install packages.R

#### Dependencias QIIME 1.9.0

git clone git://github.com/qiime/qiime-deploy.git
git clone git://github.com/qiime/qiime-deploy-conf.git
cd qiime-deploy/
python qiime-deploy.py $HOME/bin/qiime_software/ -f $HOME/bin/qiime-deploy-conf/qiime-1.9.0/qiime.conf --force-remove-failed-dirs
source $HOME/.bashrc

### Test instalación
