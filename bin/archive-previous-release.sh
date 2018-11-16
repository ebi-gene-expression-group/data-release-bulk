#!/usr/bin/env bash

set -e

[ ! -z ${ATLAS_EXPS+x} ] || ( echo "Env var ATLAS_EXPS path to the experiment needs to be defined." && exit 1 )

# 1. cp $ATLAS_EXPS/atlas-latest-data.tar.gz $ATLAS_EXPS/archive/atlas-latest-data.tar.gz.<DDMonYYYY>
#    where <DDMonYYYY> is the date release happens, e.g. 07Jan2014
mkdir -p $ATLAS_EXPS/archive
today=`eval date +%d%b%Y`
cp $ATLAS_EXPS/atlas-latest-data.tar.gz $ATLAS_EXPS/archive/atlas-latest-data.tar.gz.${today}
