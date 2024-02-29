#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo mkdir -p /program
export USERNAME=$(whoami)
sudo chown -R $USERNAME:$USERNAME /program
# sudo chown -R test1:test1 /program
sudo apt install -y default-jre wget unzip perl-modules python3-pip git man-db gawk libncurses5-dev libncursesw5-dev libbz2-dev liblzma-dev openjdk-17-jdk git-lfs
sudo ln -sf /usr/bin/python3 /usr/bin/python
# sudo apt install -y gawk libncurses5-dev libncursesw5-dev libbz2-dev liblzma-dev

## install multiqc
pip install multiqc
sudo ln -s /home/$USERNAME/.local/bin/multiqc /usr/local/bin/multiqc

## install fastqc
wget "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.12.1.zip"
unzip fastqc_v0.12.1.zip -d /program
rm fastqc_v0.12.1.zip
chmod +x /program/FastQC/fastqc
echo 'export PATH="/program/FastQC:$PATH"' >> ~/.bash_profile

## install fastp
mkdir -p /program/fastp
wget http://opengene.org/fastp/fastp -O /program/fastp/fastp
chmod a+x /program/fastp/fastp
echo 'export PATH="/program/fastp:$PATH"' >> ~/.bash_profile

## install bwa
git clone https://github.com/lh3/bwa.git /program/bwa
cd /program/bwa; make
cd ~
echo 'export PATH="/program/bwa:$PATH"' >> ~/.bash_profile

# install samtool
wget https://github.com/samtools/samtools/releases/download/1.19.2/samtools-1.19.2.tar.bz2
tar -xjf samtools-1.19.2.tar.bz2 -C /program
mv /program/samtools-1.19.2 /program/samtools
cd /program/samtools
./configure --prefix=/program/samtools
make
make install
cd ~
echo 'export PATH="/program/samtools/bin:$PATH"' >> ~/.bash_profile

## install IGV
cd ~
wget https://data.broadinstitute.org/igv/projects/downloads/2.17/IGV_Linux_2.17.2_WithJava.zip
unzip IGV_Linux_2.17.2_WithJava.zip
mv IGV_Linux_2.17.2 IGV

## install snp-dist
git clone https://github.com/tseemann/snp-dists.git /program/snp-dists
cd /program/snp-dists; make
cd ~
echo 'export PATH="/program/snp-dists:$PATH"' >> ~/.bash_profile

## install gatk
git clone https://github.com/broadinstitute/gatk.git /program/gatk
cd /program/gatk
./gradlew bundle
cd ~
echo 'export PATH="/program/gatk:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
