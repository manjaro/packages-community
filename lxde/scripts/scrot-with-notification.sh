#!/bin/sh
pictures_folder=$(xdg-user-dir PICTURES)
cd $pictures_folder
scrot  && \
notify-send "Screenshot Taken!" "placed in $pictures_folder" || \
notify-send "Something went wrong" "screenshot error!"
