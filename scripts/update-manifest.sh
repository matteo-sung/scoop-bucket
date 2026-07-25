#!/usr/bin/env bash
# Regenerate bucket/lockvet.json for a given release tag.
# Usage: scripts/update-manifest.sh v0.1.18
set -euo pipefail

TAG="${1:?usage: update-manifest.sh <tag, e.g. v0.1.18>}"
VERSION="${TAG#v}"
REPO="matteo-sung/lockvet"
BASE="https://github.com/${REPO}/releases/download/${TAG}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
curl -fsSL "${BASE}/checksums.txt" -o "$tmp"

sha() { awk -v f="lockvet_${TAG}_windows_$1.zip" '$2==f{print $1}' "$tmp"; }

AMD64="$(sha amd64)"
ARM64="$(sha arm64)"
for v in AMD64 ARM64; do
  [ -n "${!v}" ] || { echo "missing checksum for windows_$v" >&2; exit 1; }
done

cat > "${ROOT}/bucket/lockvet.json" <<EOF
{
    "version": "${VERSION}",
    "description": "Explain any lockfile change: bumps, vulnerabilities (OSV.dev), release ages, deprecations, license changes - across 20+ lockfile formats and SBOMs",
    "homepage": "https://github.com/${REPO}",
    "license": "MIT",
    "architecture": {
        "64bit": {
            "url": "${BASE}/lockvet_${TAG}_windows_amd64.zip",
            "hash": "${AMD64}",
            "extract_dir": "lockvet_${TAG}_windows_amd64"
        },
        "arm64": {
            "url": "${BASE}/lockvet_${TAG}_windows_arm64.zip",
            "hash": "${ARM64}",
            "extract_dir": "lockvet_${TAG}_windows_arm64"
        }
    },
    "bin": "lockvet.exe",
    "checkver": {
        "github": "https://github.com/${REPO}"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://github.com/${REPO}/releases/download/v\$version/lockvet_v\$version_windows_amd64.zip",
                "extract_dir": "lockvet_v\$version_windows_amd64"
            },
            "arm64": {
                "url": "https://github.com/${REPO}/releases/download/v\$version/lockvet_v\$version_windows_arm64.zip",
                "extract_dir": "lockvet_v\$version_windows_arm64"
            }
        },
        "hash": {
            "url": "https://github.com/${REPO}/releases/download/v\$version/checksums.txt"
        }
    }
}
EOF

echo "Manifest updated to ${TAG}."
