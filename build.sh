#!/usr/bin/env bash

set -eu

selfdir=$(dirname "$(readlink -f "$0")")

cd "$selfdir"
git submodule sync --recursive
git submodule update --init --recursive
git submodule foreach --recursive git reset --hard
cd 'ArchiSteamFarm'
git am --abort || true
# apply our patches one by one
for patch_file in "$selfdir/patches/"*.patch
do
    git am --reject "$patch_file"
    # self-update this patch
    git format-patch -1 -N -k --zero-commit -o "$selfdir/patches/"
done
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
    dotnet publish ArchiSteamFarm -c 'Release' -f 'net6.0' -o "$selfdir/builds/$arch" ${runtime:+ -r "$arch" "-p:ASFVariant=$arch" '-p:PublishTrimmed=true' '-p:PublishSingleFile=true' '-p:PublishReadyToRun=true' '-p:EnableCompressionInSingleFile=true' '--self-contained'}
done
