#! /bin/bash

#if [ $# -ne 7 ]
#then
#  echo "Usage: `basename $0` {dssat input} {dssat output}"
#  exit -1
#fi

dssatZipInput=$1
dssatOutput=$2

INSTALL_DIR=/mnt/galaxyTools/dssat_ria/model/4.6
cp $INSTALL_DIR/dssat_aux.tgz dssat_aux.tgz
tar xvzf dssat_aux.tgz
mv -f ./dssat_aux/* .

cp $dssatZipInput dssatZipInput.zip
#tar xvzf dssatZipInput
unzip -o -q dssatZipInput -d DSSAT/
cd DSSAT
rename -v -f 'y/a-z/A-Z/' *.[Cc][Uu][Ll]
cd ..
mv -f ./DSSAT/* .
./DSCSM046.EXE b DSSBatch.v46 DSCSM046.CTR 

mkdir ./output
mv -f *.OUT ./output
#mv -f ACMO_meta.dat ./output
cd output
zip -r -q ../retOut.zip *
cd ..
cp retOut.zip $dssatOutput
exit
