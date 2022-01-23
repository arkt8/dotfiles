#!/bin/bash

fileinput="$(basename "$@")";
fileoutput="${fileinput%.*}";
gs \
   -o "$fileoutput"-cmyk.pdf \
   -dOverrideICC \
   -dEncodeColorImages=false \
   -sDEVICE=pdfwrite \
   -sProcessColorModel=DeviceCMYK \
   -sColorConversionStrategy=CMYK \
   -sColorConversionStrategyForImages=CMYK \
   "$fileinput"; 



echo $fileoutput
