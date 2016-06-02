#!/bin/bash

if [ -z "$PACKAGE_BASE" ];
then
  # For testing purposes
  export PACKAGE_BASE="/mnt/galaxyTools/dssat_ria/1.0.0"
  echo "Setting PACKAGE_BASE=$PACKAGE_BASE"
fi

export PATH=/mnt/galaxyTools/dssat_ria/1.0.0:$PATH
export CLASSPATH=/mnt/galaxyTools/dssat_ria/1.0.0:$CLASSPATH
