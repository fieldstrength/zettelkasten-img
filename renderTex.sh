#!/bin/bash

set -euo pipefail

# Input sources
INPUT_TEX_FILE=$1
OUT_DIR=$2
TEMPLATE_FILE=template.tex

# Create a temp directory
INPUT_BASENAME=`basename $INPUT_TEX_FILE`
MAIN_NAME=`echo $INPUT_BASENAME | sed 's/.tex//'`
WORK_DIR=`mktemp -dt $MAIN_NAME.XXXX`
echo Working in temp directory $WORK_DIR ...

# Determine work paths in temp directory
TMP_TEX_FILE="$WORK_DIR/$INPUT_BASENAME"
TMP_PDF_FILE="$WORK_DIR/$MAIN_NAME.pdf"
TMP_PNG_FILE="$WORK_DIR/$MAIN_NAME.png"

# Apply template to take care of latex ceremony
echo Creating TeX file from $TEMPLATE_FILE...
cat template-start.tex $INPUT_TEX_FILE template-end.tex > $TMP_TEX_FILE

cd $WORK_DIR
echo Running pdflatex...
pdflatex $TMP_TEX_FILE &> $WORK_DIR/pdflatex.log.txt
echo Running convert...
convert -density 300 $TMP_PDF_FILE -quality 90 $TMP_PNG_FILE &> $WORK_DIR/convert.log.txt

# Copy back resulting PNG

PNG_OUT_FILE=`echo $INPUT_BASENAME | sed 's/.tex/.png/'`
echo Copying result to $OUT_DIR/$PNG_OUT_FILE...
cp $TMP_PNG_FILE $OUT_DIR/$PNG_OUT_FILE
echo Done!
