#!/usr/bin/env bash
#
# Task 8, on camera: least privilege.
#
# Runs the same request as the Editor and as the Administrator, back to back,
# so the contrast between 200 and 403 is visible in one continuous scroll
# instead of scattered across separate terminal sessions.
#
# Usage: bash scripts/demo-task8.sh
#
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

set -a
# shellcheck disable=SC1091
. "$REPO_DIR/.env"
set +a

BASE="${WP_BASE_URL%/}"
EDITOR_AUTH="${WP_EDITOR_USER}:${WP_EDITOR_APP_PASSWORD}"
ADMIN_AUTH="${WP_ADMIN_USER}:${WP_ADMIN_APP_PASSWORD}"

BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'; RED=$'\033[31m'; CYAN=$'\033[36m'; RESET=$'\033[0m'

jsonpp() {
	node -e '
		let raw = "";
		process.stdin.on("data", chunk => raw += chunk);
		process.stdin.on("end", () => {
			try { console.log(JSON.stringify(JSON.parse(raw), null, 2)); }
			catch (err) { console.log(raw); }
		});
	'
}

# run <label> <auth-user-display> <expect> <curl-arg>...
# The password itself is never printed — only the account name is shown.
run() {
	local label="$1"; local who="$2"; local expect="$3"; shift 3

	echo
	echo "${BOLD}${CYAN}>> $label   (as $who)${RESET}"

	local status
	status="$(curl -s -o "$TMP_DIR/body.json" -w '%{http_code}' "$@")"

	local color="$GREEN"
	[[ "$status" != "$expect" ]] && color="$RED"

	echo "${color}${BOLD}HTTP $status${RESET}  ${DIM}(expected $expect)${RESET}"
	jsonpp < "$TMP_DIR/body.json" | sed 's/^/  /'
}

echo "${BOLD}Least privilege — editor.jane (Editor) vs admin (Administrator)${RESET}"
echo "${DIM}Same requests, same site, different role.${RESET}"

run "GET  /e2m/v1/projects/count    — a route Editors are meant to use" \
	"editor.jane" "200" \
	-u "$EDITOR_AUTH" "$BASE/wp-json/e2m/v1/projects/count"

run "POST /wp/v2/users              — create an administrator" \
	"editor.jane" "403" \
	-X POST -u "$EDITOR_AUTH" \
	-H "Content-Type: application/json" \
	-d '{"username":"should.not.exist","email":"should.not.exist@task-7.local","password":"irrelevant","roles":["administrator"]}' \
	"$BASE/wp-json/wp/v2/users"

run "GET  /wp/v2/settings           — site settings" \
	"editor.jane" "403" \
	-u "$EDITOR_AUTH" "$BASE/wp-json/wp/v2/settings"

run "GET  /wp/v2/plugins            — installed plugins" \
	"editor.jane" "403" \
	-u "$EDITOR_AUTH" "$BASE/wp-json/wp/v2/plugins"

echo
echo "${BOLD}${CYAN}---- same request, as Administrator ----${RESET}"

run "GET  /wp/v2/settings           — the same request that just failed" \
	"admin" "200" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/wp/v2/settings?_fields=title,description,posts_per_page"

echo
echo "${BOLD}Summary: the Application Password authenticates who you are.${RESET}"
echo "The role decides what you may do — the credential does not override it."
