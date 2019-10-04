#!/bin/bash
cd `dirname $0`/../Interface/AddOns
git clean -dfX "$@" .
