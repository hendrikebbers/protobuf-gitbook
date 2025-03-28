#!/bin/bash

hapi_version="v0.61.0"
build_dir="build"
consensus_node_dir="$build_dir/hiero-consensus-node"
protos_dir="$build_dir/protos"
docs_dir="$build_dir/docs"

echo "Step 1: Prepare directories"
mkdir -p $consensus_node_dir
rm -rf $consensus_node_dir/*
mkdir -p $protos_dir
rm -rf $protos_dir/*
mkdir -p $docs_dir
rm -rf $docs_dir/*

echo "Step 2: Download and extract protobuf files"
echo "Downloading Hiero protobufs version $hapi_version..."
curl -sL "https://github.com/hiero-ledger/hiero-consensus-node/archive/refs/tags/${hapi_version}.tar.gz" | tar -xz -C $consensus_node_dir --strip-components=1
cp -a $consensus_node_dir/hapi/hedera-protobuf-java-api/src/main/proto/. $protos_dir


echo "Step 3: Create Doc Files"
# Loop through each directory
for DIR in "${protos_dir[@]}"; do
  echo "Searching in $DIR..."
  
  # Find all .proto files in the directory
  find "$DIR" -name "*.proto" | while read -r PROTO_FILE; do
    echo "Processing $PROTO_FILE"
    
    # Create a safe file name for the doc output
    DOC_NAME=$(basename "$PROTO_FILE" .proto).md

    # Generate markdown docs using protoc-gen-doc
    echo "START for ${PROTO_FILE#build/}"
    docker run --rm \
  -v $(pwd)/$docs_dir:/out \
  -v $(pwd)/$protos_dir:/protos \
   -v $(pwd)/template:/template \
  pseudomuto/protoc-gen-doc --doc_opt=markdown,"$DOC_NAME" "${PROTO_FILE#build/}"
  echo "END for ${PROTO_FILE#build/}"
  done
done
