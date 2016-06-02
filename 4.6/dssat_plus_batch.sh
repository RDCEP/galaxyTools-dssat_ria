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
cp -f $JsonInput $PWD/json.zip
unzip -o -q json.zip -d json/
mkdir result
cd json
for file in *.json; do
{
  filename="${file%.*}"
  mkdir ../result/$filename
  cp -f $filename.json ../result/$filename/1.json
}
done
cd ..

# Prepare Cultivar files
source $UTIL_DIR/prepareCulFiles.sh "DSSAT"

# Loop all the input JSON file
cd result
for dir in */; do
{
  cd $dir
  batchId=${dir%/}
  
  # Run QuadUI
  source $UTIL_DIR/runDSSAT2ACMO.sh $batchId
  
  cd ..
}
done

# Setup outputs
zip -r -q retIn.zip retIn_*
cp retIn.zip $dssatInput

zip -r -q retOut.zip retOut_*
cp retOut.zip $dssatOutput

zip -r -q acmo.zip *.csv
cp acmo.zip $AcmoOutput

cd ..

exit 0
