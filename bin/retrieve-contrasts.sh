#!/usr/bin/env bash

# 2. Retrieve contrastdetails.tsv and assaygroupsdetails.tsv from wwwdev.gxa and put them into $ATLAS_EXPS
# This step doesn't seem to require step 1, and could be run separately/parallely.
stagingApiUrl=${stagingApiUrl:-https://wwwdev.ebi.ac.uk/gxa/api}

[ ! -z ${ATLAS_EXPS+x} ] || ( echo "Env var ATLAS_EXPS path to the experiment needs to be defined." && exit 1 )
[ ! -z ${ATLAS_FTP+x} ] || ( echo "Env var ATLAS_FTP path to the experiment needs to be defined." && exit 1 )

contrastdetails=$ATLAS_EXPS/contrastdetails.tsv
curl -s -o $contrastdetails "$stagingApiUrl/contrastdetails.tsv"
fetchStatus=$?

# HTML in the tsv output spells trouble
grep -q '<html>' $contrastdetails
errorStatus=$?

if [ $fetchStatus -ne 0 ] || [ $errorStatus -eq 0 ]; then
    echo "ERROR: Failed to retrieve $stagingApiUrl/contrastdetails.tsv" 1>&2
    rm -rf $contrastdetails
    exit 1
fi

assaygroupsdetails=$ATLAS_EXPS/assaygroupsdetails.tsv
curl -s -o $assaygroupsdetails "$stagingApiUrl/assaygroupsdetails.tsv"
fetchStatus=$?
grep -q '<html>' $assaygroupsdetails
errorStatus=$?

if [ $fetchStatus -ne 0 ] || [ $errorStatus -eq 0 ]; then
    echo "ERROR: Failed to retrieve $stagingApiUrl/assaygroupsdetails.tsv" 1>&2
    rm -rf $assaygroupsdetails
    exit 1
fi

## copy files to $ATLAS_FTP from $ATLAS_EXPS
cp -p $contrastdetails $ATLAS_FTP/experiments
cp -p $assaygroupsdetails $ATLAS_FTP/experiments
