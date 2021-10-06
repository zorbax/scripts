#!/bin/bash

music_collection="$HOME/Music"
backup_dir="$HOME/mp3organizer_backups"
mode="copy"
unknown_dir="$music_collection/unknown"
working_dir="$HOME/.mp3organizer_temporary_files"

if [ -z "$1" ];then
    echo "Doh!  You have to pass a directory where the music is you want to organize!"
    exit
else
    echo "Working from supplied directory"
    echo "$1"
    new_music="$1"
fi

if [ ! -d "$new_music" ];then
    echo "Can't find the search directory $new_music"
    echo "For SABNZBD, in the admin go to Settings > Switches and set REPLACE SPACES WITH UNDERSCORSES"
    exit
fi

if [ ! -d "$working_dir" ];then
    echo "Creating $working_dir"
    mkdir $working_dir
fi

if [ ! -d "$music_collection" ];then
    echo "Creating $music_collection"
    mkdir $music_collection
fi

if [ ! -d "$unknown_dir" ];then
    echo "Creating $unknown_dir"
    mkdir $unknown_dir
fi

if [ ! -d "$backup_dir" ];then
    echo "Creating $backup_dir"
    mkdir $backup_dir
fi

if [ "$mode" = 'move' ]; then
    find $new_music -iname "*.mp3" -exec mv {} $working_dir \;
else
    find $new_music -iname "*.mp3" -exec cp {} $working_dir \;
fi

cd $working_dir || exit

for F in ./*
do
    if [ -f "$F" ];then
        artist=$(mminfo "$F"|grep artist|awk -F: '{print $2}'|sed 's/^ *//g'|sed 's/[^a-zA-Z0-9\ \-\_]//g')
        title=$(mminfo "$F"|grep title|awk -F: '{print $2}'|sed 's/^ *//g'|sed 's/[^a-zA-Z0-9\ \-\_]//g')
        album=$(mminfo "$F"|grep album|awk -F: '{print $2}'|sed 's/^ *//g'|sed 's/[^a-zA-Z0-9\ \-\_]//g')
        trackno=$(mminfo "$F"|grep trackno|awk -F: '{print $2}'|sed 's/^ *//g'| awk '{printf "%02d\n", $1;}')

        echo "============================"
        echo "artist:" $artist
        echo "title:" $title
        echo "album:" $album
        echo "trackno:" $trackno

        if [  -n "$artist"  ] && [ -n "$album" ] && [  -n "$title"  ];then
            filename="$trackno - $title.mp3";
            if [ -n  "$backup_dir" ];then
                cp "$F" "$backup_dir/"
            fi
            if [ -d "$music_collection/$artist - $album" ];then
                mv "$F" "$music_collection/$artist - $album/$filename"
            else
                mkdir "$music_collection/$artist - $album"
                mv "$F" "$music_collection/$artist - $album/$filename"
            fi
        else
            mv "$F" "$unknown_dir/"
            echo -e "UNKNOWN: $F \n"
        fi
    fi
done
