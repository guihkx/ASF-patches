#!/usr/bin/env bash

set -eu

selfdir=$(dirname "$(readlink -f "$0")")
npatches=$(find "$selfdir/patches" -type f -name '*.patch' | wc -l)

cd "$selfdir"
git submodule update --init --recursive
cd 'ArchiSteamFarm'
#git checkout patches || git checkout -b patches
git checkout origin/main
git am --abort || true
git reset --hard origin/main
# apply our patches
git am --reject "$selfdir/patches/"*.patch
# self-update our patches
git format-patch -$npatches -o "$selfdir/patches"
# build ASF-ui
cd 'ASF-ui'
test -d 'dist' && rm -rf 'dist'
npm ci
npm run-script deploy
# build ASF
cd "$selfdir/ArchiSteamFarm"
for arch in 'source' 'linux-x64' 'win-x64' 'linux-arm64'
do
    [[ $arch != 'source' ]] && runtime=1 || unset runtime
    rm -rf "$selfdir/builds/$arch"
    dotnet publish ArchiSteamFarm -c 'Release' -f 'net5.0' -o "$selfdir/builds/$arch" ${runtime:+ -r "$arch" "-p:ASFVariant=$arch" '-p:PublishTrimmed=true' '-p:PublishSingleFile=true'}
done
git reset --hard origin/main
