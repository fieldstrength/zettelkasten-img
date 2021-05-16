#!/bin/bash

set -euo pipefail

CURRENT_DIR=`pwd`
echo Current dir: $CURRENT_DIR
TEX_DIR=$CURRENT_DIR/tex
OUT_DIR=$CURRENT_DIR/out

rm -r $OUT_DIR
mkdir $OUT_DIR

INPUT_FILES=`find $TEX_DIR -name '*.tex'`

for texFile in $INPUT_FILES; do
  echo Working on $texFile
  ./renderTex.sh $texFile $OUT_DIR
  echo Done it!
done
