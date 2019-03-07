#!/usr/bin/env bash
set -e

[ ! -z ${ATLAS_EXPS+x} ] || ( echo "Env var ATLAS_EXPS path to the experiment needs to be defined." && exit 1 )
[ ! -z ${ATLAS_FTP+x} ] || ( echo "Env var ATLAS_FTP needs to be defined." && exit 1 )

# 9. Synch $ATLAS_FTP/experiments with what is in: $ATLAS_EXPS (note that this synch preserves timestamps, permissions, etc)
#    so e.g. private experiments in $ATLAS_EXPS will retain their restricted permissions in $ATLAS_FTP/experiments
cd $ATLAS_EXPS
find . -xdev -depth -print | cpio -pdm $ATLAS_FTP/experiments


if [ ! -z ${ATLAS_SC_EXPERIMENTS+x} ]; then
  echo "Performing sync for single cell experiments..."
  cd $ATLAS_SC_EXPERIMENTS
  find . -xdev -depth -print | cpio -pdm $ATLAS_FTP/sc_experiments
else
  echo "Variable ATLAS_SC_EXPERIMENTS is not set, skipping sync for single cell experiments."
fi
