#!/bin/bash

# Setup script environment
set -e
cd "$(dirname "$0")"

DOC_BUILD_PATH="$(pwd)/.build/docs"
DOC_OUT_PATH="$(pwd)/docs"

# Build documentation archive
xcodebuild docbuild -scheme ASN1Parser -destination "platform=macOS" -derivedDataPath "${DOC_BUILD_PATH}"

# Make sure docc2html submodule is available
git submodule init && git submodule update
rm -rf $DOC_OUT_PATH

# Export documentation archive.
cd docc2html
swift run docc2html "${DOC_BUILD_PATH}/Build/Products/Debug/ASN1Parser.doccarchive/" "${DOC_OUT_PATH}"
cd -
