#!/bin/bash

hapi_version="v0.57.3"
protos_dir="protos-2"

# Step 1: Prepare directories
echo "Setting up directories..."
mkdir -p $protos_dir
rm -rf $protos_dir/*

# Step 2: Download and extract protobuf files
echo "Downloading Hiero protobufs version $hapi_version..."
curl -sL "https://github.com/hashgraph/hedera-protobufs/archive/refs/tags/${hapi_version}.tar.gz" | tar -xz -C $protos_dir --strip-components=1
# Keep 'platform', 'services', and 'mirror', remove everything else
find "$protos_dir" -mindepth 1 -maxdepth 1 ! -name platform ! -name services ! -name mirror -exec rm -r {} +

# Step3: Merge all protobuf files in 1 folder
cp -a $protos_dir/mirror/. $protos_dir/services/
cp -a $protos_dir/platform/. $protos_dir/services/