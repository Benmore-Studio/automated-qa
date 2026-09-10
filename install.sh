#!/usr/bin/env bash
set -euo pipefail

version="0.10.2"
archive="automated-qa-v${version}-darwin-universal.tar.gz"
expected_sha256="ed1764d1894b22ca74edb8d246831a8d52270dce4ae5a2b3d94ed1f357d6ed88"
url="https://github.com/Benmore-Studio/automated-qa/releases/download/v${version}/${archive}"

fail() {
  echo "automated-qa install: $1" >&2
  exit 2
}

[ "$(uname -s)" = "Darwin" ] || fail "v${version} supports macOS only"
case "$(uname -m)" in
  arm64|x86_64) ;;
  *) fail "unsupported macOS architecture: $(uname -m)" ;;
esac

command -v node >/dev/null 2>&1 || fail "Node.js 18 or newer is required"
node_major="$(node -p 'Number(process.versions.node.split(".")[0])')"
[ "$node_major" -ge 18 ] || fail "Node.js 18 or newer is required"
command -v curl >/dev/null 2>&1 || fail "curl is required"
command -v shasum >/dev/null 2>&1 || fail "shasum is required"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/automated-qa-install.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

curl -fL "$url" -o "$tmp_dir/$archive"
actual_sha256="$(shasum -a 256 "$tmp_dir/$archive" | awk '{print $1}')"
[ "$actual_sha256" = "$expected_sha256" ] || fail "archive checksum mismatch"

tar -xzf "$tmp_dir/$archive" -C "$tmp_dir"
payload="$tmp_dir/automated-qa"
[ -x "$payload/bin/qa.mjs" ] || fail "archive does not contain the qa CLI"

install_root="${QA_INSTALL_ROOT:-$HOME/.local/share/automated-qa}"
install_dir="$install_root/$version"
bin_dir="${QA_BIN_DIR:-$HOME/.local/bin}"
mkdir -p "$install_root" "$bin_dir"

if [ ! -e "$install_dir" ]; then
  mv "$payload" "$install_dir"
fi

for name in qa automated-qa; do
  link="$bin_dir/$name"
  if [ -e "$link" ] || [ -L "$link" ]; then
    current="$(readlink "$link" 2>/dev/null || true)"
    case "$current" in
      "$install_root"/*/bin/qa.mjs) ;;
      *) fail "$link already exists and is not owned by this installer" ;;
    esac
  fi
  ln -sfn "$install_dir/bin/qa.mjs" "$link"
done

node "$install_dir/bin/qa.mjs" --version
echo "Installed qa and automated-qa in $bin_dir"
case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *) echo "Add $bin_dir to PATH to invoke qa by name." ;;
esac
