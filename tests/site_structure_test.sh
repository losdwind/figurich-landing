#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PUBLIC_DIR="$ROOT_DIR/public"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

assert_file() {
  local path="$1"
  [[ -f "$path" ]] || fail "expected file to exist: $path"
}

assert_contains() {
  local path="$1"
  local needle="$2"
  grep -Fq -- "$needle" "$path" || fail "expected '$needle' in $path"
}

assert_not_contains() {
  local path="$1"
  local needle="$2"
  if grep -Fq -- "$needle" "$path"; then
    fail "did not expect '$needle' in $path"
  fi
}

assert_no_root_relative_internal_links() {
  local path="$1"
  if grep -Eq 'href="/($|[A-Za-z0-9_-])' "$path"; then
    fail "did not expect root-relative internal hrefs in $path"
  fi
}

assert_file "$PUBLIC_DIR/assets/site.css"
assert_file "$PUBLIC_DIR/assets/site.js"
assert_file "$PUBLIC_DIR/index.html"
assert_file "$PUBLIC_DIR/focus-kit/index.html"
assert_file "$PUBLIC_DIR/openclaw-health/index.html"
assert_file "$PUBLIC_DIR/content-creation-kit/index.html"
assert_file "$PUBLIC_DIR/personal-branding/index.html"
assert_file "$PUBLIC_DIR/vip-companion/index.html"

assert_no_root_relative_internal_links "$PUBLIC_DIR/index.html"
assert_no_root_relative_internal_links "$PUBLIC_DIR/focus-kit/index.html"
assert_no_root_relative_internal_links "$PUBLIC_DIR/openclaw-health/index.html"
assert_no_root_relative_internal_links "$PUBLIC_DIR/content-creation-kit/index.html"
assert_no_root_relative_internal_links "$PUBLIC_DIR/personal-branding/index.html"
assert_no_root_relative_internal_links "$PUBLIC_DIR/vip-companion/index.html"

assert_contains "$PUBLIC_DIR/index.html" "AI for personal wellbeing"
assert_contains "$PUBLIC_DIR/index.html" "OpenClaw / NanoClaw"
assert_contains "$PUBLIC_DIR/index.html" "预约沟通"
assert_contains "$PUBLIC_DIR/index.html" "AI for wellbeing, not for distraction and anxiety."
assert_contains "$PUBLIC_DIR/index.html" "AI 为个人健康，不为分心和焦虑。"
assert_contains "$PUBLIC_DIR/index.html" "我做这些产品，是因为现在很多 AI 工具其实在放大分心和焦虑。"
assert_contains "$PUBLIC_DIR/index.html" "5 个你现在就能用的工具包"
assert_contains "$PUBLIC_DIR/index.html" "class=\"poster-hero\""
assert_contains "$PUBLIC_DIR/index.html" "class=\"product-index\""
assert_contains "$PUBLIC_DIR/index.html" "href=\"assets/site.css\""
assert_contains "$PUBLIC_DIR/index.html" "src=\"assets/site.js\""
assert_contains "$PUBLIC_DIR/index.html" "src=\"logo.png\""
assert_not_contains "$PUBLIC_DIR/index.html" "LIVE_LOG"
assert_not_contains "$PUBLIC_DIR/index.html" "MISSION_OBJ"
assert_not_contains "$PUBLIC_DIR/index.html" "href=\"/assets/site.css\""
assert_not_contains "$PUBLIC_DIR/index.html" "原则一"
assert_not_contains "$PUBLIC_DIR/index.html" "一套更完整的个人健康系统，而不是单点工具。"
assert_not_contains "$PUBLIC_DIR/index.html" "下一步"
assert_not_contains "$PUBLIC_DIR/index.html" "用 AI 帮你把个人健康重新接回生活里。"
assert_not_contains "$PUBLIC_DIR/index.html" "我现在做了 5 个东西，你先看哪个对你有用。"
assert_not_contains "$PUBLIC_DIR/index.html" "做给个人健康用的 AI，不是做让人更分心、更焦虑的 AI。"
assert_not_contains "$PUBLIC_DIR/index.html" "看看这 5 个东西"
assert_not_contains "$PUBLIC_DIR/index.html" "先看这个"
assert_not_contains "$PUBLIC_DIR/index.html" "product-row-link"
assert_not_contains "$PUBLIC_DIR/index.html" "不用一次理解全部。只选一个现在最合适的入口。"
assert_not_contains "$PUBLIC_DIR/index.html" "home-feature"
assert_not_contains "$PUBLIC_DIR/index.html" "home-product-list"

assert_contains "$PUBLIC_DIR/openclaw-health/index.html" "home camera"
assert_contains "$PUBLIC_DIR/openclaw-health/index.html" "home speaker"
assert_contains "$PUBLIC_DIR/openclaw-health/index.html" "href=\"../assets/site.css\""
assert_contains "$PUBLIC_DIR/openclaw-health/index.html" "src=\"../assets/site.js\""
assert_contains "$PUBLIC_DIR/openclaw-health/index.html" "class=\"page-stream\""
assert_not_contains "$PUBLIC_DIR/openclaw-health/index.html" "detail-card"
assert_not_contains "$PUBLIC_DIR/openclaw-health/index.html" "page-side-panel"
assert_contains "$PUBLIC_DIR/focus-kit/index.html" "digital detox"
assert_contains "$PUBLIC_DIR/focus-kit/index.html" "class=\"page-stream\""
assert_not_contains "$PUBLIC_DIR/focus-kit/index.html" "detail-grid"
assert_contains "$PUBLIC_DIR/content-creation-kit/index.html" "GitHub"
assert_contains "$PUBLIC_DIR/content-creation-kit/index.html" "class=\"page-stream\""
assert_contains "$PUBLIC_DIR/personal-branding/index.html" "OPC"
assert_contains "$PUBLIC_DIR/personal-branding/index.html" "class=\"page-stream\""
assert_contains "$PUBLIC_DIR/vip-companion/index.html" "premium"
assert_contains "$PUBLIC_DIR/vip-companion/index.html" "class=\"page-stream\""

assert_contains "$PUBLIC_DIR/assets/site.css" "Jersey+20"
assert_contains "$PUBLIC_DIR/assets/site.css" "Space+Mono"
assert_contains "$PUBLIC_DIR/assets/site.css" "#543D71"
assert_contains "$PUBLIC_DIR/assets/site.css" ".poster-hero"
assert_contains "$PUBLIC_DIR/assets/site.css" ".product-index"
assert_contains "$PUBLIC_DIR/assets/site.css" ".page-stream"
assert_contains "$PUBLIC_DIR/assets/site.css" ".text-section"
assert_contains "$PUBLIC_DIR/assets/site.css" "scale(0.97)"
assert_contains "$PUBLIC_DIR/assets/site.css" "prefers-reduced-motion: reduce"
assert_not_contains "$PUBLIC_DIR/assets/site.css" "--panel-shadow"
assert_not_contains "$PUBLIC_DIR/assets/site.css" ".product-card.featured"

echo "PASS: static wellbeing site structure is present"
