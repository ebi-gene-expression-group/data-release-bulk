#!/usr/bin/env bash
set -e

# Apparently this step is not needed anymore, the table producing it has been deleted.

[ ! -z ${dbConnection+x} ] || ( echo "Env var dbConnection needs to be defined." && exit 1 )
[ ! -z ${ATLAS_EXPS+x} ] || ( echo "Env var ATLAS_EXPS path to the experiment needs to be defined." && exit 1 )

echo "refresh materialized view VW_DIFFANALYTICS_DUMP WITH DATA;" | psql $dbConnection
echo -e "Gene ID\tGene Name\tOrganism\tExperiment\tComparison id\tp-value\tlog2foldchange\tt-statistic" > $ATLAS_EXPS/differential_analytics.tsv
echo "select IDENTIFIER, NAME, ORGANISM, EXPERIMENT, CONTRASTID, PVAL, LOG2FOLD, TSTAT from VW_DIFFANALYTICS_DUMP" \
  | psql $dbConnection | tail -n +3 | perl -p -e 's|^ +||g' \
  | perl -p -e 's/ +\| +/\t/g' | grep -v '^$' >> $ATLAS_EXPS/differential_analytics.tsv
# Remove the last line (e.g. 5147277 rows selected.)
sed -i '$ d'  $ATLAS_EXPS/differential_analytics.tsv
