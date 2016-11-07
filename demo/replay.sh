#!/bin/bash

today=$(date +%s)
last=$(tail -n 1 data-model.raw | cut -f 3 -d ' ')

cat data-model.raw | sed 's/demo/model/' | \
  awk "{print \$1, \$2, \$3-${last}+${today} }" | \
  nc graphite.dev 2003
