#!/bin/bash

#Create user if doesn't already exist
mkdir -p $DROPBOX_HOME
chown $DROPBOX_UID:$DROPBOX_GID $DROPBOX_HOME
id dropbox || addgroup --gid $DROPBOX_GID dropbox && adduser --uid $DROPBOX_UID --home $DROPBOX_HOME --no-create-home --system dropbox --ingroup dropbox

#Download dropbox if not already downloaded
if [[ ! -f $DROPBOX_HOME/.dropbox-dist/dropboxd ]]
then
	cd $DROPBOX_HOME && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf -	
fi

#Download dropbox.py if not already downloaded
if [[ ! -f $DROPBOX_HOME/.dropbox-dist/dropbox.py ]]
then
	wget -O $DROPBOX_HOME/.dropbox-dist/dropbox.py "https://www.dropbox.com/download?dl=packages/dropbox.py"
	chmod +x $DROPBOX_HOME/.dropbox-dist/dropbox.py
	chown $DROPBOX_UID:$DROPBOX_GID $DROPBOX_HOME/.dropbox-dist/dropbox.py
fi

#Make disk if doesn't exist
if [[ ! -f /mnt/dropbox.img ]]
then
	dd if=/dev/zero of=/mnt/dropbox.img bs=1G count=$DROPBOX_SIZE
	mkfs.ext4 /mnt/dropbox.img
fi

#Mount disk
mkdir -p $DROPBOX_HOME/Dropbox
mount /mnt/dropbox.img $DROPBOX_HOME/Dropbox
chown $DROPBOX_UID:$DROPBOX_GID $DROPBOX_HOME/Dropbox

#Start dropbox
su dropbox -s /bin/bash -c '$DROPBOX_HOME/.dropbox-dist/dropbox.py start'
su dropbox -s /bin/bash -c '$DROPBOX_HOME/.dropbox-dist/dropbox.py status'
su dropbox -s /bin/bash -c '$DROPBOX_HOME/.dropbox-dist/dropbox.py exclude add "$DROPBOX_HOME/Dropbox/lost+found"'

while true
do
	rsync -avhPz $DROPBOX_HOME/Dropbox/ $DROPBOX_HOME/Dropbox_copy/
	sleep 60
done
