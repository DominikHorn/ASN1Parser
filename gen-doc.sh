#!/bin/bash

# Config
SYMBOL_GRAPHS_DIR=.build/symbol-graphs
set -e

# 0. Cleanup remnants from previous script
swift package clean

# 1. Generate symbol graph
## 1.1 gen files
mkdir -p ${SYMBOL_GRAPHS_DIR} && \
  swift build --target ASN1Parser \
  -Xswiftc -emit-symbol-graph \
  -Xswiftc -emit-symbol-graph-dir -Xswiftc ${SYMBOL_GRAPHS_DIR}

## 1.2 rm files that don't belong to this project
find .build/symbol-graphs/* | grep -v ASN1Parser | xargs rm

# 2. Export as HTML
DOCC=$(xcrun --find docc)
DOCC_HTML_DIR="$(dirname "${DOCC}")/../share/docc/render"
$DOCC convert Sources/ASN1Parser/ASN1Parser.docc \
  --fallback-display-name ASN1Parser \
  --fallback-bundle-identifier de.dhorn.ASN1Parser \
  --fallback-bundle-version 0.0.1 \
  --additional-symbol-graph-dir ${SYMBOL_GRAPHS_DIR}

# 3. Move html to gh pages location
rm -rf docs
cp -r Sources/ASN1Parser/ASN1Parser.docc/.docc-build docs
