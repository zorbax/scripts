#!/bin/bash

declare -A USERKEY

USERKEY[otto]="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAglV5RBevBHQDTIIiL5c+615wTn4ruiE8YD3lcQUAE0zmrb6yhvDljNE+4YwCJvdttiBJcfUcGDVU8IZRDwfYMp5ekeNrpwQXexzoHiPunUYwgtMUM3baD9JA6vQkexvFKUItbH5Oct7zdDhoo/mjs0QC/Oze3ePgDSlEZbz6wEBgIZRBzVCs+PqP0IgfShQNJXg95aYMXT8EGrSPFtwlwwM0PK0Mu3ilkJzKaqZ8haWWTk9MwPeW98roBqf9W6xdEJ+hD7Yjc3IBM584WDFL8WheilohrgHG8p96CI7eQQeUtn2I9/G90fxN+QcxLbQrVUbLdx8G+YV/YrO6HJ1R otto"
#>>>


#>>>
declare -A SUDOUSER

SUDOUSER[otto]=y

for user in "${!USERKEY[@]}" ; do
  adduser --disabled-password --gecos "" $user

  if [ "${SUDOUSER[$user]}" == 'y' ] ; then
    usermod -a -G sudo $user
    echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
  fi

  mkdir /home/$user/.ssh
  echo "${USERKEY[$user]}" >> /home/$user/.ssh/authorized_keys

  chown -R $user:$user /home/$user/.ssh
  chmod -R go-rx /home/$user/.ssh
done
