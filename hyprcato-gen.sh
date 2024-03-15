#!/bin/bash
# set -o nounset
shopt -s extglob
SVGDIR=$1
NAMED="${2:-antmode}"
ANIMONE="${3:-"wait"}"
ANIMTWO="${4:-"progress"}"
#conditions should be met first

if [ -n "$1" ]; then
  if [ -d "$1" ]; then
    if [ ! -f "$1/manifest.hl" ]; then
      echo "All conditions met, proceeding with conversion..."
    else
      echo "Error: $1 already has a manifest.hl file."
      exit 1
    fi
  else
    echo "Error: $1 is not a directory."
    exit 1
  fi
else
  echo "Error: No argument provided."
  exit 1
fi

#prepare directory, remove any extraneous files

cd "$SVGDIR"
rm -rf cursors *_24.svg
mkdir cursors $ANIMONE $ANIMTWO
mv $ANIMONE-* $ANIMONE
mv $ANIMTWO-* $ANIMTWO
#create a containing folder with name of icon

for file in *.svg; do
  file_contents="resize_algorithm = bilinear
define_size = 64, $file"
  direct="${file%.svg}"
  mkdir -- "$direct"
  mv -- "$file" "$direct"
  echo "$file_contents" >$direct/meta.hl
done

#wait cursor meta
echo "resize_algorithm = bilinear
define_size = 64, $ANIMONE-01.svg,500
define_size = 64, $ANIMONE-02.svg,500
define_size = 64, $ANIMONE-03.svg,500
define_size = 64, $ANIMONE-04.svg,500
define_size = 64, $ANIMONE-05.svg,500
define_size = 64, $ANIMONE-06.svg,500
define_size = 64, $ANIMONE-07.svg,500
define_size = 64, $ANIMONE-08.svg,500
define_size = 64, $ANIMONE-09.svg,500
define_size = 64, $ANIMONE-10.svg,500
define_size = 64, $ANIMONE-11.svg,500
define_size = 64, $ANIMONE-12.svg,500
" >>$ANIMONE/meta.hl

#progress cursor meta
echo "resize_algorithm = bilinear
define_size = 64, $ANIMTWO-01.svg,500
define_size = 64, $ANIMTWO-02.svg,500
define_size = 64, $ANIMTWO-03.svg,500
define_size = 64, $ANIMTWO-04.svg,500
define_size = 64, $ANIMTWO-05.svg,500
define_size = 64, $ANIMTWO-06.svg,500
define_size = 64, $ANIMTWO-07.svg,500
define_size = 64, $ANIMTWO-08.svg,500
define_size = 64, $ANIMTWO-09.svg,500
define_size = 64, $ANIMTWO-10.svg,500
define_size = 64, $ANIMTWO-11.svg,500
define_size = 64, $ANIMTWO-12.svg,500
" >>$ANIMTWO/meta.hl

mv !(cursors) ./cursors
rm cursors/index.theme

echo "[Icon Theme]
Name=$NAMED
Comment=generated by hyprman
" >>index.theme

echo "name = $NAMED
description = let there be ants
version = 0.1
cursors_directory = cursors
" >>manifest.hl

hyprcursor-util --create .
