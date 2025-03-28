#!/bin/bash

hapi_version="v0.61.0"
build_dir="build"
consensus_node_dir="$build_dir/hiero-consensus-node"
protos_dir="$build_dir/protos"
merged_protos_dir="$build_dir/merged-protos"
docs_dir="$build_dir/docs"

echo "Step 1: Prepare directories"
mkdir -p $consensus_node_dir
rm -rf $consensus_node_dir/*
mkdir -p $protos_dir
rm -rf $protos_dir/*
mkdir -p $merged_protos_dir
rm -rf $merged_protos_dir/*
mkdir -p $docs_dir
rm -rf $docs_dir/*

echo "Step 2: Download and extract protobuf files"
echo "Downloading Hiero protobufs version $hapi_version..."
curl -sL "https://github.com/hiero-ledger/hiero-consensus-node/archive/refs/tags/${hapi_version}.tar.gz" | tar -xz -C $consensus_node_dir --strip-components=1
cp -a $consensus_node_dir/hapi/hedera-protobuf-java-api/src/main/proto/. $protos_dir


echo "Step 3: Merge all protobuf files in 1 folder"
cp -a $protos_dir/block/. $merged_protos_dir
cp -a $protos_dir/mirror/. $merged_protos_dir
cp -a $protos_dir/platform/. $merged_protos_dir
cp -a $protos_dir/sdk/. $merged_protos_dir
cp -a $protos_dir/services/. $merged_protos_dir
cp -a $protos_dir/streams/. $merged_protos_dir

echo "Step 4: Create Doc Files"
docker run --rm \
  -v $(pwd)/$docs_dir:/out \
  -v $(pwd)/$merged_protos_dir:/protos \
   -v $(pwd)/template:/template \
  pseudomuto/protoc-gen-doc --doc_opt=/template/template.mustache,doc.txt
