#!/usr/bin/env bash
set -euo pipefail

script_path="${BASH_SOURCE[0]}"
while [ -L "$script_path" ]; do
  script_dir="$(cd "$(dirname "$script_path")" && pwd -P)"
  target="$(readlink "$script_path")"
  case "$target" in
    /*) script_path="$target" ;;
    *) script_path="$script_dir/$target" ;;
  esac
done
script_dir="$(cd "$(dirname "$script_path")" && pwd -P)"
skill_root="$script_dir"

if command -v brew >/dev/null 2>&1; then
  brew_root="$(brew --prefix qa 2>/dev/null || true)"
  if [ -f "$brew_root/libexec/SKILL.md" ]; then
    skill_root="$brew_root/libexec"
  fi
fi

[ -f "$skill_root/SKILL.md" ] || {
  echo "frontend-verify skill not found beside the installer" >&2
  exit 2
}

linked=0
for agent_root in "$HOME/.claude" "$HOME/.agents" "$HOME/.codex" "$HOME/.cursor"; do
  [ -d "$agent_root" ] || continue
  skills="$agent_root/skills"
  link="$skills/frontend-verify"
  mkdir -p "$skills"
  if [ -e "$link" ] || [ -L "$link" ]; then
    current="$(readlink "$link" 2>/dev/null || true)"
    [ "$current" = "$skill_root" ] && continue
    echo "Preserved existing $link; move it aside to install this skill." >&2
    continue
  fi
  ln -s "$skill_root" "$link"
  echo "Linked $link"
  linked=$((linked + 1))
done

[ "$linked" -gt 0 ] || echo "No new agent skill links were needed."
