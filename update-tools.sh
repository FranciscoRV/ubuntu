#!/usr/bin/env bash
set -e

mkdir -p rootfs/usr/bin

echo "> Downloading dockerize..."
wget -O - https://github.com/jwilder/dockerize/releases/download/v0.4.0/dockerize-linux-amd64-v0.4.0.tar.gz | tar -C rootfs/usr/bin -xzvf -

echo "> Make dockerize executable..."
chmod +x rootfs/usr/bin/dockerize

echo "> Downloading wait-for-it..."
wget -O rootfs/usr/bin/wait-for-it https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh

echo "> Make wait-for-it executable..."
chmod +x rootfs/usr/bin/wait-for-it

echo "> Cloning su-exec..."
git clone https://github.com/ncopa/su-exec.git build/su-exec

pushd build/su-exec > /dev/null
  echo "> Building su-exec..."
  docker run -ti --rm -v $(pwd):/mnt -w /mnt owncloud/ubuntu:latest /bin/bash -c "apt-get update && apt-get install -y build-essential && make all"

  echo "> Copying su-exec..."
  cp su-exec ../../rootfs/usr/bin/
popd > /dev/null

echo "> Done!"
