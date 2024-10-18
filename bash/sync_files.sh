#!/bin/bash

manga="/home/zorbax/Documents/Dropbox/zorbax/Manga/"
webdav="/media/verbatim/webdav/"
docs="/home/zorbax/Documents"

files=$(find ${manga} --path "${manga}/tofilter" -prune -o type f \( -name "*cbz" -o -name "*cbr" \) | wc -l)

while true; do
    sleep 30

    rsync -az --delete --exclude '.stfolder' ${docs}/Syncthing/Obsidian/ ${docs}/Dropbox/Data/Vault
    rsync -az --delete --exclude '.metube' /home/zorbax/Videos/ /media/verbatim/Videos
    chown zorbax:zorbax -R /media/verbatim/Videos

    newfiles=$(find ${manga} -type f \( -name "*cbz" -o -name "*cbr" \) | wc -l)
    if [ "$newfiles" -ne "$files" ]; then
        rsync -avz ${manga} --delete --exclude={'tofilter','*_tmp'} ${webdav}
        chmod 755 -R ${webdav} && chown www-data:www-data -R ${webdav}
        files=$newfiles
    fi
done
