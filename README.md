# ASF-patches

```
git clone https://github.com/guihkx/ASF-patches.git --recurse-submodules
./ASF-patches/build.sh
```

```
ls ASF-patches/builds/
linux-arm64  linux-x64  source  win-x64
```

### Flatpak

- https://github.com/flatpak/flatpak-builder-tools/tree/master/node
- https://github.com/flatpak/flatpak-builder-tools/tree/master/dotnet

```
flatpak-node-generator npm -o node-sources-ASF-ui.json ArchiSteamFarm/ASF-ui/package-lock.json
flatpak-dotnet-generator.py --dotnet 10 --freedesktop 25.08 nuget-sources-ASF.json ArchiSteamFarm/ArchiSteamFarm/ArchiSteamFarm.csproj --dotnet-args -p:ASFVariant=generic -p:ContinuousIntegrationBuild=true -p:TargetLatestRuntimePatch=false -p:UseAppHost=false
```
