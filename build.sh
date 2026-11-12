#!/usr/bin/env bash
# Netlify build script: installs the Flutter SDK (not preinstalled on Netlify)
# from the official release archive and builds the web release into build/web.
set -euo pipefail

# Set FLUTTER_VERSION (e.g. "3.35.0") to pin a release; defaults to latest stable.
FLUTTER_VERSION="${FLUTTER_VERSION:-}"
FLUTTER_ROOT_DIR="${FLUTTER_ROOT_DIR:-$HOME/flutter-sdk}"
FLUTTER_HOME="$FLUTTER_ROOT_DIR/flutter"
RELEASE_INFO="$FLUTTER_ROOT_DIR/release.json"
RELEASES_BASE="https://storage.googleapis.com/flutter_infra_release/releases"

if [ ! -x "$FLUTTER_HOME/bin/flutter" ] || [ ! -f "$RELEASE_INFO" ]; then
  mkdir -p "$FLUTTER_ROOT_DIR"
  curl -fsSL "$RELEASES_BASE/releases_linux.json" | FLUTTER_VERSION="$FLUTTER_VERSION" node -e '
    let s = "";
    process.stdin.on("data", d => (s += d)).on("end", () => {
      const data = JSON.parse(s);
      const want = process.env.FLUTTER_VERSION;
      const rel = want
        ? data.releases.find(r => r.version === want)
        : data.releases.find(r => r.hash === data.current_release.stable);
      if (!rel) { console.error("Flutter release not found: " + (want || "stable")); process.exit(1); }
      console.error("Using Flutter " + rel.version);
      process.stdout.write(JSON.stringify(rel));
    });
  ' > "$RELEASE_INFO"
  ARCHIVE_PATH="$(node -p 'require(process.argv[1]).archive' "$RELEASE_INFO")"
  rm -rf "$FLUTTER_HOME"
  echo "Downloading $RELEASES_BASE/$ARCHIVE_PATH"
  curl -fsSL "$RELEASES_BASE/$ARCHIVE_PATH" | tar -xJ -C "$FLUTTER_ROOT_DIR"
fi

export PATH="$FLUTTER_HOME/bin:$PATH"

# First invocation builds the Flutter tool (this also clears its version cache).
flutter --version >/dev/null 2>&1 || true

# Write Flutter's version cache from the official release metadata so the SDK
# version is known without relying on git (which may be restricted in some
# build environments). Without it, Flutter can report 0.0.0-unknown and fail
# to resolve packages that require a minimum Flutter version.
node -e '
  const fs = require("fs");
  const path = require("path");
  const [releaseFile, root] = process.argv.slice(1);
  const rel = JSON.parse(fs.readFileSync(releaseFile, "utf8"));
  const read = (p) => { try { return fs.readFileSync(path.join(root, p), "utf8").trim(); } catch { return null; } };
  let devTools = "unknown";
  try {
    devTools = JSON.parse(read("bin/cache/dart-sdk/bin/resources/devtools/version.json")).version || devTools;
  } catch {}
  const engine = read("bin/cache/engine.stamp") || read("bin/internal/engine.version") || "unknown";
  const dart = String(rel.dart_sdk_version || "unknown").split(" ")[0];
  const info = {
    frameworkVersion: rel.version,
    channel: rel.channel || "stable",
    repositoryUrl: "https://github.com/flutter/flutter.git",
    frameworkRevision: rel.hash,
    frameworkCommitDate: rel.release_date,
    engineRevision: engine,
    dartSdkVersion: dart,
    devToolsVersion: devTools,
    flutterVersion: rel.version,
  };
  fs.mkdirSync(path.join(root, "bin", "cache"), { recursive: true });
  fs.writeFileSync(path.join(root, "bin", "cache", "flutter.version.json"), JSON.stringify(info, null, 2));
' "$RELEASE_INFO" "$FLUTTER_HOME"

flutter config --no-analytics >/dev/null 2>&1 || true
flutter --version
flutter precache --web
flutter pub get
flutter build web --release
