#!/bin/bash
cd `dirname $0`/..
PATCH_DIR=Interface.Tools/Patches
ls $PATCH_DIR | xargs -I{} git apply --whitespace=nowarn "$@" $PATCH_DIR/{}
