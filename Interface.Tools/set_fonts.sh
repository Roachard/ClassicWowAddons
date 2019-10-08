#!/bin/bash
cd `dirname $0`/..
FONT=Interface.Tools/Fonts/${1:-fzcy}.ttf
mkdir -p Fonts
cp $FONT Fonts/ARHei.TTF
cp $FONT Fonts/ARIALN.TTF
cp $FONT Fonts/ARKai_C.TTF
cp $FONT Fonts/ARKai_T.TTF
cp $FONT Fonts/FRIZQT__.TTF
