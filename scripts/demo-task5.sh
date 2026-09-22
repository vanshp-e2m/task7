#!/usr/bin/env bash
#
# Task 5, on camera.
#
# Uploads an image, then builds a complete page from three ACF Flexible Content
# layouts in a single authenticated POST, and prints the result in a form that
# is readable on a screen recording.
#
# Usage:
#   bash scripts/demo-task5.sh            # create a new page
#   bash scripts/demo-task5.sh --reset    # delete previous demo pages first
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
AUTH="${WP_ADMIN_USER}:${WP_ADMIN_APP_PASSWORD}"

# ANSI colours, so the important lines stand out on video.
BOLD=$'\033[1m'; DIM=$'\033[2m'; GREEN=$'\033[32m'; CYAN=$'\033[36m'; RESET=$'\033[0m'

banner() {
	echo
	echo "${BOLD}${CYAN}=== $* ===${RESET}"
	echo
}

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

json_field() {
	node -e '
		const fs = require("fs");
		try {
			const data = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
			const value = data[process.argv[2]];
			process.stdout.write(value === undefined || value === null ? "" : String(value));
		} catch (err) { process.stdout.write(""); }
	' "$1" "$2"
}

# --- Optional reset, so the demo can be re-recorded cleanly ------------------

if [[ "${1:-}" == "--reset" ]]; then
	banner "Removing previous demo pages"

	curl -s -u "$AUTH" "$BASE/wp-json/wp/v2/pages?search=Built%20by%20the%20REST%20API&per_page=20" \
		> "$TMP_DIR/existing.json"

	node -e '
		const fs = require("fs");
		const pages = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
		if (Array.isArray(pages)) {
			pages.forEach(page => console.log(page.id));
		}
	' "$TMP_DIR/existing.json" | while read -r id; do
		[[ -z "$id" ]] && continue
		curl -s -o /dev/null -X DELETE -u "$AUTH" "$BASE/wp-json/wp/v2/pages/$id?force=true"
		echo "  deleted page $id"
	done
fi

# --- Step 1: upload the image ------------------------------------------------

banner "1. Upload the image — POST /wp-json/wp/v2/media"

echo "${DIM}curl -X POST -u \"admin:<APP_PASSWORD>\" \\
  -H \"Content-Disposition: attachment; filename=e2m-rest-lab-sample.png\" \\
  -H \"Content-Type: image/png\" \\
  --data-binary @scripts/sample-image.png \\
  $BASE/wp-json/wp/v2/media${RESET}"
echo

MEDIA_STATUS="$(curl -s -o "$TMP_DIR/media.json" -w '%{http_code}' \
	-X POST -u "$AUTH" \
	-H "Content-Disposition: attachment; filename=e2m-rest-lab-sample.png" \
	-H "Content-Type: image/png" \
	--data-binary "@$REPO_DIR/scripts/sample-image.png" \
	"$BASE/wp-json/wp/v2/media")"

MEDIA_ID="$(json_field "$TMP_DIR/media.json" id)"

echo "${GREEN}HTTP $MEDIA_STATUS${RESET}   attachment ID = ${BOLD}$MEDIA_ID${RESET}"

# --- Step 2: build the page --------------------------------------------------

banner "2. Build the page — POST /wp-json/wp/v2/pages"

cat > "$TMP_DIR/page.json" <<JSON
{
  "title": "Built by the REST API",
  "status": "publish",
  "content": "<p>Everything below this paragraph is ACF Flexible Content written in the same request.</p>",
  "acf": {
    "page_sections": [
      {
        "acf_fc_layout": "hero",
        "heading": "Built entirely over HTTP",
        "subheading": "Three Flexible Content layouts, one authenticated POST, zero clicks in wp-admin.",
        "background_image": $MEDIA_ID,
        "cta_label": "See the route code",
        "cta_url": "$BASE/wp-json/e2m/v1/projects/count"
      },
      {
        "acf_fc_layout": "text_block",
        "heading": "Why this matters",
        "body": "<p>Once a page is addressable as structured JSON, anything can build it: a migration script, a CI job, a headless front end, or another service entirely. The editor keeps a real, editable page in wp-admin.</p>",
        "alignment": "left"
      },
      {
        "acf_fc_layout": "media_text",
        "heading": "The image came from the media endpoint",
        "body": "This image was uploaded in the previous request. The attachment ID it returned was dropped straight into this layout's image sub-field.",
        "image": $MEDIA_ID,
        "image_position": "left"
      }
    ]
  }
}
JSON

echo "${BOLD}Request body:${RESET}"
cat "$TMP_DIR/page.json"
echo

PAGE_STATUS="$(curl -s -o "$TMP_DIR/page-response.json" -w '%{http_code}' \
	-X POST -u "$AUTH" \
	-H "Content-Type: application/json" \
	--data-binary "@$TMP_DIR/page.json" \
	"$BASE/wp-json/wp/v2/pages")"

PAGE_ID="$(json_field "$TMP_DIR/page-response.json" id)"
PAGE_LINK="$(json_field "$TMP_DIR/page-response.json" link)"

echo "${GREEN}HTTP $PAGE_STATUS${RESET}   page ID = ${BOLD}$PAGE_ID${RESET}"

# --- Step 3: read the sections back -----------------------------------------

banner "3. Read the sections back — GET /wp-json/wp/v2/pages/$PAGE_ID?_fields=acf"

curl -s -u "$AUTH" "$BASE/wp-json/wp/v2/pages/$PAGE_ID?_fields=acf" | jsonpp

# --- Where to look next ------------------------------------------------------

banner "Now open these"

echo "  Front end : ${BOLD}$PAGE_LINK${RESET}"
echo "  wp-admin  : ${BOLD}$BASE/wp-admin/post.php?post=$PAGE_ID&action=edit${RESET}"
echo
