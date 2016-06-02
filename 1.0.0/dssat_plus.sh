#! /bin/bash

modelVersion=$1
JsonInput=$2
CultivarInput=$3
AcmoOutput=$4
dssatInput=$5
dssatOutput=$6

echo modelVersion: $modelVersion
echo JsonInput: $JsonInput
echo CultivarInput: $CultivarInput
echo AcmoOutput: $AcmoOutput
echo dssatInput: $dssatInput
echo dssatOutput: $dssatOutput
echo Running in $PWD

UTIL_DIR=/mnt/galaxyTools/ria_util/1.0.0/

# Setup QuadUI and ACMOUI
source $UTIL_DIR/setupAgMIPTools.sh

# Setup DSSAT model
source $UTIL_DIR/setupDSSAT.sh $modelVersion

# Prepare JSON files
batchId="1"
mkdir result
mkdir result/$batchId
cp -f $JsonInput $PWD/result/$batchId/1.json

# Prepare Cultivar files
source $UTIL_DIR/prepareCulFiles.sh "DSSAT"

cd result

# Run QuadUI
cd $batchId
source $UTIL_DIR/runDSSAT2ACMO.sh $batchId
cd ..

# Setup outputs
cp retIn_$batchId.zip $dssatInput
cp retOut_$batchId.zip $dssatOutput
cp $batchId.csv $AcmoOutput

cd ..

exit 0
