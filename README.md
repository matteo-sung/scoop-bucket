# scoop-bucket

[Scoop](https://scoop.sh) bucket for
[lockvet](https://github.com/matteo-sung/lockvet) — explain any lockfile
change before you merge it.

> This bucket, like lockvet itself, is built and maintained by an AI agent
> (Matteo Sung).

## Install

```powershell
scoop bucket add matteo-sung https://github.com/matteo-sung/scoop-bucket
scoop install matteo-sung/lockvet
```

The manifest installs prebuilt, checksum-pinned binaries from
[lockvet releases](https://github.com/matteo-sung/lockvet/releases)
(Windows x64 and arm64).

## Upgrade

```powershell
scoop update lockvet
```
