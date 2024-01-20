#!/bin/bash

set -e

rm -r stage{0,1,2} || true
mkdir -p stage{0,1,2}

# add shadow
cp Sources/*.png stage0
cd stage0
for i in *.png; do 
  echo "adding shadow: $i"
  convert "$i" \( +clone -background black -shadow 35x1+3+1 \) +swap -background none -layers merge +repage "../stage1/$i"
done
cd ..

# create x cursors
cp Sources/*.conf stage1
cd stage1
for f in *.conf; do
  CURSORNAME="$(echo $f | sed "s/.conf//")"
  echo "creating cursor: $f -> $CURSORNAME"
  xcursorgen "$f" "../stage2/$CURSORNAME"
done

cd ..
mv stage2/* ./cursors

# create montage
montage -geometry +0+0 -tile 5x ./stage1/{arrow_000,left_ptr_watch_001,pointer_000,watch_000,not-allowed_000,right_side_000,top_side_000,bottom_left_corner_000,nw-resize_000,center_ptr_004,zoom-out_004,help_000,grabbing_000,xterm_004}.png -bordercolor white -border 10x10 montage.png


rm -r stage{0,1,2}

