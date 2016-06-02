#! /bin/bash

# Check if the number of parameters is correct
if [ $# -ne 6 ]
then
    echo "Usage: dssat_plus.sh <model_version> <json_input> <cultivar_input> <acmo_output> <dssat_input> <dssat_output>"
    exit -1
fi

THISDIR=`pwd`
#Uncomment the following line to trap the exceution somewhere
#THISDIR="/scratch/wrf/scratch/dssat_plus"
cd $THISDIR

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Save a copy of a command line for fast debug
cat > `basename $0`_debug.sh << EOF
source $DIR/env.sh
$0 $@
EOF

chmod +x `basename $0`_debug.sh

####################################################################

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
