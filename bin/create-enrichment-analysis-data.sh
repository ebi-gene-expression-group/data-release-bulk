#!/usr/bin/env bash

[ ! -z ${ATLAS_EXPS+x} ] || ( echo "Env var ATLAS_EXPS path to the experiment needs to be defined." && exit 1 )

checkExecutableInPath() {
  [[ $(type -P $1) ]] || (echo "$1 binaries not in the path." && exit 1)
  [[ -x $(type -P $1) ]] || (echo "$1 is not executable." && exit 1)
}

checkExecutableInPath gsa_prepare_data.sh

# 8. Prepare data for the on-the-fly gene set enrichment analysis against differential comparisons in Expression Atlas
echo "Preparing data for on-the-fly gene set enrichment analysis against differential comparisons in Atlas..."
# ${ATLAS_PROD}/sw/atlasinstall_prod/atlasprod/analysis/gsa/scripts/gsa_prepare_data.sh
gsa_prepare_data.sh
# This requires contrast details files on $ATLAS_EXPS

if [ $? -ne 0 ]; then
    echo "Error preparing gene set enrichment analysis data."
    exit 1
else
    echo "Gene set enrichment analysis data prepared."
fi
