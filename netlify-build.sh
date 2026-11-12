#!/usr/bin/env bash
# Installs the Flutter SDK (Netlify build images don't include it) and builds the web app.
# Uses the official release archive rather than `git clone`.
set -euo pipefail

FLUTTER_CHANNEL="${FLUTTER_CHANNEL:-stable}"
FLUTTER_VERSION="${FLUTTER_VERSION:-}"
FLUTTER_ROOT_DIR="${FLUTTER_ROOT_DIR:-$HOME/flutter-sdk}"
FLUTTER_DIR="$FLUTTER_ROOT_DIR/flutter"
BASE_URL="https://storage.googleapis.com/flutter_infra_release/releases"
RELEASE_JSON="$(mktemp)"

# Look up the release (latest on the channel, or the pinned FLUTTER_VERSION).
curl -fsSL "$BASE_URL/releases_linux.json" -o "$RELEASE_JSON"
RELEASE_INFO="$(node -e '
  const [file, ch, ver] = process.argv.slice(1);
  const j = JSON.parse(require("fs").readFileSync(file, "utf8"));
  const rel = ver
    ? j.releases.find(r => r.version === ver && r.channel === ch)
    : j.releases.find(r => r.hash === j.current_release[ch] && r.channel === ch);
  if (!rel) { console.error(`No Flutter release found (channel=${ch} version=${ver || "latest"})`); process.exit(1); }
  process.stdout.write(JSON.stringify(rel));
' "$RELEASE_JSON" "$FLUTTER_CHANNEL" "$FLUTTER_VERSION")"
rm -f "$RELEASE_JSON"

if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
  ARCHIVE="$(node -e 'process.stdout.write(JSON.parse(process.argv[1]).archive)' "$RELEASE_INFO")"
  echo "Downloading Flutter: $ARCHIVE"
  mkdir -p "$FLUTTER_ROOT_DIR"
  curl -fsSL "$BASE_URL/$ARCHIVE" | tar -xJ -C "$FLUTTER_ROOT_DIR"
fi

export PATH="$FLUTTER_DIR/bin:$PATH"

# First run bootstraps the tool and writes bin/cache/flutter.version.json.
flutter --version >/dev/null 2>&1 || true

# Flutter derives its version from git. If git metadata can't be read in this
# environment, the version ends up "0.0.0-unknown" and pub refuses packages that
# need a minimum Flutter version. Fill it in from the official release metadata.
VERSION_FILE="$FLUTTER_DIR/bin/cache/flutter.version.json"
node -e '
  const fs = require("fs");
  const [file, relJson] = process.argv.slice(1);
  const rel = JSON.parse(relJson);
  let v = {};
  try { v = JSON.parse(fs.readFileSync(file, "utf8")); } catch {}
  if (v.frameworkVersion && v.frameworkVersion !== "0.0.0-unknown" && v.repositoryUrl !== "unknown source") process.exit(0);
  Object.assign(v, {
    frameworkVersion: rel.version,
    flutterVersion: rel.version,
    channel: rel.channel,
    repositoryUrl: "https://github.com/flutter/flutter.git",
    frameworkRevision: rel.hash,
    frameworkCommitDate: rel.release_date,
  });
  v.engineRevision = v.engineRevision || rel.hash;
  v.dartSdkVersion = v.dartSdkVersion || rel.dart_sdk_version || "unknown";
  v.devToolsVersion = v.devToolsVersion || "unknown";
  fs.writeFileSync(file, JSON.stringify(v, null, 2));
  console.log(`Set Flutter version metadata to ${rel.version} (${rel.channel})`);
' "$VERSION_FILE" "$RELEASE_INFO"

flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version
flutter precache --web
flutter pub get
flutter build web --release
