#!/usr/bin/env bash

set -o errexit
set -o pipefail
#set -o xtrace

ubuntu_version=`lsb_release -sr`

DEBIAN_FRONTEND=noninteractive

SSH_USERNAME="ubuntu"

# Add user to sudoers and systemd-journal
usermod -G sudo $SSH_USERNAME
usermod -a -G systemd-journal $SSH_USERNAME

apt-get -qqy update
apt-get install -qqy ansible fontconfig htop jq net-tools nvme-cli \
python-apt python3-pip unzip

if [ ${ubuntu_version} == 20.04 ]; then
    echo "Skipping python-argcomplete"
else
    apt-get install -qqy python-argcomplete
fi

update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

if [ ${ubuntu_version} == 20.04 ]; then
    update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2
elif [ ${ubuntu_version} == 18.04 ]; then
    update-alternatives --install /usr/bin/python python /usr/bin/python3.6 2
else
    update-alternatives --install /usr/bin/python python /usr/bin/python3.5 2
fi

update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
pip --version
python --version

#pip3 install --quiet awscli
apt-get install -qqy awscli
#pip3 install --quiet boto3
apt-get install -qqy python3-boto3

# ansible
if [ ${ubuntu_version} == 20.04 ]; then
    echo "Skipping adding ansible ppa repo"
else
    apt-add-repository -y ppa:ansible/ansible
    apt-get -qqy update
fi
apt-get install -qqy ansible python-apt

# Remove snapd
case "$PACKER_BUILDER_TYPE" in
amazon-ebs)
    snap remove amazon-ssm-agent
    snap remove lxd
    apt purge -y snapd
    rm -rf ~/snap
    apt-get install -qqy lxcfs
esac

# Final updates
apt-get upgrade -qqy
apt-get dist-upgrade -qqy
apt-get autoremove -qqy

# SSH
sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
echo 'UseDNS no' | tee -a /etc/ssh/sshd_config
systemctl restart sshd

# IPv6 disable
# sed -i -e 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
# update-grub

# Disable network time
#timedatectl set-ntp off
# Stop chrony
systemctl stop chrony

# NVMe mapping
apt-get install -qqy nvme-cli