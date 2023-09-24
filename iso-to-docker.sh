#!/usr/bin/env bash
# https://medium.com/@SofianeHamlaoui/convert-iso-images-to-docker-images-4e1b1b637d75
# https://stackoverflow.com/questions/42385527/how-to-create-docker-image-from-an-iso-file

SQUASHFS="unsquashfs"
ROOTFS="rootfs"
FS="minimal.squashfs"
ISO="ubuntu23.04-desktop.iso"

wget # url to iso
mkdir $ROOTFS $SQUASHFS
sudo mount -o loop $ISO $ROOTFS
sudo unsquashfs -f -d $SQUASHFS $ROOTFS/casper/$FS
sudo tar -C $SQUASHFS -c . | sudo docker - ubuntu/desktop

# Validation
sudo docker image list
sudo docker run -ti --rm ubuntu/desktop bash