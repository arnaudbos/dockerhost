#!/bin/sh
VBOX_VERSION="5.1.2"
VBOX_GUEST_ISO_URL="http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso"
VBOX_GUEST_ISO_PATH="VBoxGuestAdditions.iso"
VBOX_GUEST_MEDIA="/media/VBoxGuestAdditions"

# Download VBoxGuestAdditions
wget $VBOX_GUEST_ISO_URL -O $VBOX_GUEST_ISO_PATH

# Install dependencies
sudo apt-get install -yq linux-headers-$(uname -r) build-essential dkms

# Install the thing
sudo mkdir /media/VBoxGuestAdditions
sudo mount -o loop,ro $VBOX_GUEST_ISO_PATH $VBOX_GUEST_MEDIA
sudo sh $VBOX_GUEST_MEDIA/VBoxLinuxAdditions.run
rm $VBOX_GUEST_ISO_PATH
sudo umount $VBOX_GUEST_MEDIA
sudo rmdir $VBOX_GUEST_MEDIA
