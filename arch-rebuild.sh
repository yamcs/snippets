#/bin/bash

# This script can be used to export and import the tm,pp and events tables in order to bring them to the latest definition
#
# It can also be run to repartition the data because once a table has been created with a partitioning schema it cannot be changed unless dropping it and recreating it.
#
# IMPORTANT: make sure you take a backup of the yamcs-data directory before running this.
set -e 


INSTANCE="myproject"
echo "Stopping the instance $INSTANCE"
yamcs instances stop $INSTANCE

echo "Exporting tm, events and pp tables"
yamcs tables dump --gzip tm
yamcs tables dump --gzip events
yamcs tables dump --gzip pp


echo "Dropping the tm, events and pp tables"
yamcs dbshell -c "drop table tm"
yamcs dbshell -c "drop table events"
yamcs dbshell -c "drop table pp"

echo "starting the instance in order to recreate the tables"
yamcs instances start $INSTANCE

echo "importing back the data"
yamcs tables load --gzip tm
yamcs tables load --gzip events
yamcs tables load --gzip pp

echo "rebuilding the histograms for the tm and pp tables"
yamcs tables rebuild-histogram tm
yamcs tables rebuild-histogram pp

echo "rebuilding the ccsds completeness index"
yamcs packets rebuild-ccsds-index

