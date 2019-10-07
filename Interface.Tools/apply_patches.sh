#!/bin/bash
cd `dirname $0`/..
PATCH_DIR=Interface.Tools/Patches
ls $PATCH_DIR | xargs -I{} git apply -3 --whitespace=nowarn "$@" $PATCH_DIR/{}
