#!/usr/bin/env bash
set -euo pipefail

version="0.11.0"
archive="automated-qa-v${version}-multi-platform.tar.gz"
expected_sha256="3a5bf1705172855d8dbc6de66c238e78f4a726965997a952dac60db298c249a1"
url="https://github.com/Benmore-Studio/automated-qa/releases/download/v${version}/${archive}"

fail() {
  echo "automated-qa install: $1" >&2
  exit 2
}

case "$(uname -s)" in
  Darwin|Linux) ;;
  *) fail "unsupported operating system: $(uname -s)" ;;
esac
case "$(uname -m)" in
  arm64|aarch64|x86_64) ;;
  *) fail "unsupported architecture: $(uname -m)" ;;
esac

command -v node >/dev/null 2>&1 || fail "Node.js 18 or newer is required"
node_major="$(node -p 'Number(process.versions.node.split(".")[0])')"
[ "$node_major" -ge 18 ] || fail "Node.js 18 or newer is required"
command -v curl >/dev/null 2>&1 || fail "curl is required"

tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/automated-qa-install.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

curl -fL "$url" -o "$tmp_dir/$archive"
if command -v shasum >/dev/null 2>&1; then
  actual_sha256="$(shasum -a 256 "$tmp_dir/$archive" | awk '{print $1}')"
elif command -v sha256sum >/dev/null 2>&1; then
  actual_sha256="$(sha256sum "$tmp_dir/$archive" | awk '{print $1}')"
else
  fail "shasum or sha256sum is required"
fi
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
skill_link="$bin_dir/qa-install-skill"
if [ -e "$skill_link" ] || [ -L "$skill_link" ]; then
  current="$(readlink "$skill_link" 2>/dev/null || true)"
  case "$current" in
    "$install_root"/*/install-skill.sh) ;;
    *) fail "$skill_link already exists and is not owned by this installer" ;;
  esac
fi
ln -sfn "$install_dir/install-skill.sh" "$skill_link"

node "$install_dir/bin/qa.mjs" --version
"$install_dir/install-skill.sh"
echo "Installed qa, automated-qa, and qa-install-skill in $bin_dir"
case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *) echo "Add $bin_dir to PATH to invoke qa by name." ;;
esac
