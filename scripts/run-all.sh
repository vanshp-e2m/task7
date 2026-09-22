#!/usr/bin/env bash
#
# Module 9 practical runner.
#
# Executes every exercise in the assignment against a running WordPress site and
# writes each request/response pair to docs/captures/ so the results can be
# reviewed, diffed and committed.
#
# Usage:  bash scripts/run-all.sh
# Needs:  curl, node (for JSON pretty-printing), and a populated .env
#
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CAPTURE_DIR="$REPO_DIR/docs/captures"
TMP_DIR="$(mktemp -d)"

trap 'rm -rf "$TMP_DIR"' EXIT

# --- Environment -------------------------------------------------------------

if [[ ! -f "$REPO_DIR/.env" ]]; then
	echo "ERROR: .env not found. Copy .env.example to .env and fill it in." >&2
	exit 1
fi

set -a
# shellcheck disable=SC1091
. "$REPO_DIR/.env"
set +a

BASE="${WP_BASE_URL%/}"
ADMIN_AUTH="${WP_ADMIN_USER}:${WP_ADMIN_APP_PASSWORD}"
EDITOR_AUTH="${WP_EDITOR_USER}:${WP_EDITOR_APP_PASSWORD}"

mkdir -p "$CAPTURE_DIR"

# --- Helpers -----------------------------------------------------------------

# Pretty-print JSON from stdin, passing non-JSON through untouched.
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

# Read a top-level field out of a JSON file: json_field <file> <key>
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

# Replace the real credentials with placeholders before anything is written to
# a file that will be committed.
redact() {
	sed -e "s|${WP_ADMIN_APP_PASSWORD}|<ADMIN_APP_PASSWORD>|g" \
	    -e "s|${WP_EDITOR_APP_PASSWORD}|<EDITOR_APP_PASSWORD>|g"
}

# capture <slug> <title> <curl-arg>...
#
# Runs curl, records the redacted command, HTTP status and pretty response body
# into docs/captures/<slug>.md, and leaves the raw body in $TMP_DIR/<slug>.json
# so later steps can pull IDs out of it.
capture() {
	local slug="$1"; shift
	local title="$1"; shift

	local body_file="$TMP_DIR/$slug.json"
	local status

	status="$(curl -s -o "$body_file" -w '%{http_code}' "$@")"

	local rendered_cmd="curl"
	for arg in "$@"; do
		rendered_cmd+=" $(printf '%q' "$arg")"
	done

	{
		echo "# $title"
		echo
		echo '## Request'
		echo
		echo '```bash'
		printf '%s\n' "$rendered_cmd" | redact
		echo '```'
		echo
		echo "## Response — HTTP $status"
		echo
		echo '```json'
		jsonpp < "$body_file" | redact
		echo '```'
	} > "$CAPTURE_DIR/$slug.md"

	printf '  %-38s HTTP %s\n' "$slug" "$status"
	echo "$status" > "$TMP_DIR/$slug.status"
}

step() {
	echo
	echo "== $* =="
}

# --- 2. Read: list posts, then fetch one with _embed -------------------------

step "Exercise 2 — Read"

capture "02a-list-posts" "GET /wp/v2/posts — list posts" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/wp/v2/posts?per_page=5"

FIRST_POST_ID="$(node -e '
	const fs = require("fs");
	const posts = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
	process.stdout.write(Array.isArray(posts) && posts.length ? String(posts[0].id) : "1");
' "$TMP_DIR/02a-list-posts.json")"

capture "02b-single-post-embed" "GET /wp/v2/posts/$FIRST_POST_ID?_embed — embedded resources" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/wp/v2/posts/$FIRST_POST_ID?_embed"

# --- 3. Explore: the route index --------------------------------------------

step "Exercise 3 — Explore the /wp-json/ index"

capture "03a-index-namespaces" "GET /wp-json/ — namespaces only" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/?_fields=name,description,namespaces"

# The full index is thousands of lines, so record only the routes that matter
# to this module: the CPT collection and the custom namespace.
curl -s -u "$ADMIN_AUTH" "$BASE/wp-json/?_fields=routes" > "$TMP_DIR/index-routes.json"

{
	echo "# GET /wp-json/ — locating the project CPT route in the index"
	echo
	echo '## Request'
	echo
	echo '```bash'
	echo 'curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/'
	echo '```'
	echo
	echo '## Matching routes'
	echo
	echo 'The index lists every registered route. Filtered to the ones this module adds:'
	echo
	echo '```'
	node -e '
		const fs = require("fs");
		const index = JSON.parse(fs.readFileSync(process.argv[1], "utf8"));
		const routes = Object.keys(index.routes || {});
		const wanted = routes.filter(route => /project|e2m/i.test(route)).sort();
		wanted.forEach(route => {
			const methods = (index.routes[route].methods || []).join(", ");
			console.log(route.padEnd(48) + methods);
		});
		console.log("");
		console.log(`(${wanted.length} matching of ${routes.length} routes total)`);
	' "$TMP_DIR/index-routes.json"
	echo '```'
} > "$CAPTURE_DIR/03b-index-project-routes.md"

echo "  03b-index-project-routes               written"

capture "03c-projects-route-schema" "OPTIONS /wp/v2/projects — the CPT route schema" \
	-X OPTIONS -u "$ADMIN_AUTH" "$BASE/wp-json/wp/v2/projects"

# Seed a few projects so the count route has something real to report.
step "Seeding projects (so the count route returns a meaningful number)"

for n in 1 2 3; do
	cat > "$TMP_DIR/project-$n.json" <<JSON
{
  "title": "Project $n — REST seeded",
  "status": "publish",
  "content": "<p>Created over the REST API to give <code>e2m/v1/projects/count</code> something to count.</p>",
  "excerpt": "Seeded project number $n."
}
JSON

	capture "03d-create-project-$n" "POST /wp/v2/projects — seed project $n" \
		-X POST -u "$ADMIN_AUTH" \
		-H "Content-Type: application/json" \
		--data-binary "@$TMP_DIR/project-$n.json" \
		"$BASE/wp-json/wp/v2/projects"
done

# One draft project, to prove the ?status= argument on the custom route works.
cat > "$TMP_DIR/project-draft.json" <<'JSON'
{
  "title": "Project 4 — still a draft",
  "status": "draft",
  "content": "<p>Deliberately left as a draft so the count route can be asked for a non-default status.</p>"
}
JSON

capture "03e-create-project-draft" "POST /wp/v2/projects — a draft project" \
	-X POST -u "$ADMIN_AUTH" \
	-H "Content-Type: application/json" \
	--data-binary "@$TMP_DIR/project-draft.json" \
	"$BASE/wp-json/wp/v2/projects"

# --- 4. Write: create a post -------------------------------------------------

step "Exercise 4 — Write a post"

cat > "$TMP_DIR/new-post.json" <<'JSON'
{
  "title": "Posted from the REST API",
  "status": "publish",
  "content": "<p>This post was created with a single authenticated <code>POST /wp-json/wp/v2/posts</code> request using an Application Password. If you can read this in wp-admin, the write path works.</p>",
  "excerpt": "Created over HTTP, not in wp-admin."
}
JSON

capture "04-create-post" "POST /wp/v2/posts — create a published post" \
	-X POST -u "$ADMIN_AUTH" \
	-H "Content-Type: application/json" \
	--data-binary "@$TMP_DIR/new-post.json" \
	"$BASE/wp-json/wp/v2/posts"

NEW_POST_ID="$(json_field "$TMP_DIR/04-create-post.json" id)"

# --- 6. Upload media (done before the page, so the ID can be reused) ---------

step "Exercise 6 — Upload media"

capture "06-upload-media" "POST /wp/v2/media — upload a PNG" \
	-X POST -u "$ADMIN_AUTH" \
	-H "Content-Disposition: attachment; filename=e2m-rest-lab-sample.png" \
	-H "Content-Type: image/png" \
	--data-binary "@$REPO_DIR/scripts/sample-image.png" \
	"$BASE/wp-json/wp/v2/media"

MEDIA_ID="$(json_field "$TMP_DIR/06-upload-media.json" id)"

if [[ -z "$MEDIA_ID" ]]; then
	echo "WARNING: media upload did not return an ID; the ACF image sub-fields will be left empty." >&2
	MEDIA_ID=0
fi

echo "  attachment ID = $MEDIA_ID"

# --- 5. Write ACF: a page built from three Flexible Content layouts ----------

step "Exercise 5 — Write ACF Flexible Content (the core exercise)"

cat > "$TMP_DIR/new-page.json" <<JSON
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
        "body": "<p>Once a page is addressable as structured JSON, anything can build it: a migration script, a CI job, a headless front end, or another service entirely. The editor keeps a real, editable page in wp-admin — the sections are ordinary ACF rows, not opaque markup.</p><p>That is the whole promise of Module 9: the CMS stops being the only way in.</p>",
        "alignment": "left"
      },
      {
        "acf_fc_layout": "media_text",
        "heading": "The image came from the media endpoint",
        "body": "This image was uploaded with POST /wp/v2/media in the previous request. The attachment ID it returned was dropped straight into this layout's image sub-field.",
        "image": $MEDIA_ID,
        "image_position": "left"
      }
    ]
  }
}
JSON

capture "05a-create-page-acf" "POST /wp/v2/pages — page with three ACF layouts" \
	-X POST -u "$ADMIN_AUTH" \
	-H "Content-Type: application/json" \
	--data-binary "@$TMP_DIR/new-page.json" \
	"$BASE/wp-json/wp/v2/pages"

PAGE_ID="$(json_field "$TMP_DIR/05a-create-page-acf.json" id)"
PAGE_LINK="$(json_field "$TMP_DIR/05a-create-page-acf.json" link)"

echo "  page ID = $PAGE_ID"
echo "  page URL = $PAGE_LINK"

capture "05b-read-page-acf" "GET /wp/v2/pages/$PAGE_ID?_fields=id,link,acf — read the sections back" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/wp/v2/pages/$PAGE_ID?_fields=id,link,acf"

# --- 7. Custom route --------------------------------------------------------

step "Exercise 7 — Custom route and its permission callback"

capture "07a-count-authenticated" "GET /e2m/v1/projects/count — authenticated as administrator" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/e2m/v1/projects/count"

capture "07b-count-unauthenticated" "GET /e2m/v1/projects/count — no credentials (must be rejected)" \
	"$BASE/wp-json/e2m/v1/projects/count"

capture "07c-count-draft-status" "GET /e2m/v1/projects/count?status=draft — the status argument" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/e2m/v1/projects/count?status=draft"

capture "07d-count-bad-status" "GET /e2m/v1/projects/count?status=nonsense — argument validation" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/e2m/v1/projects/count?status=nonsense"

# --- 8. Least privilege -----------------------------------------------------

step "Exercise 8 — Least privilege (Editor role)"

capture "08a-editor-count" "GET /e2m/v1/projects/count — as Editor (has edit_posts, so allowed)" \
	-u "$EDITOR_AUTH" "$BASE/wp-json/e2m/v1/projects/count"

cat > "$TMP_DIR/new-user.json" <<'JSON'
{
  "username": "should.not.exist",
  "email": "should.not.exist@task-7.local",
  "password": "irrelevant-this-must-fail",
  "roles": ["administrator"]
}
JSON

capture "08b-editor-create-user" "POST /wp/v2/users — as Editor (admin-only, must fail)" \
	-X POST -u "$EDITOR_AUTH" \
	-H "Content-Type: application/json" \
	--data-binary "@$TMP_DIR/new-user.json" \
	"$BASE/wp-json/wp/v2/users"

capture "08c-editor-read-settings" "GET /wp/v2/settings — as Editor (manage_options required, must fail)" \
	-u "$EDITOR_AUTH" "$BASE/wp-json/wp/v2/settings"

capture "08d-editor-list-plugins" "GET /wp/v2/plugins — as Editor (activate_plugins required, must fail)" \
	-u "$EDITOR_AUTH" "$BASE/wp-json/wp/v2/plugins"

capture "08e-admin-read-settings" "GET /wp/v2/settings — as Administrator (same request, succeeds)" \
	-u "$ADMIN_AUTH" "$BASE/wp-json/wp/v2/settings?_fields=title,description,posts_per_page"

# --- Summary ----------------------------------------------------------------

step "Summary"

echo "Captures written to docs/captures/"
echo
printf '%-14s %s\n' "new post"  "${NEW_POST_ID:-?}"
printf '%-14s %s\n' "page"      "${PAGE_ID:-?} — ${PAGE_LINK:-?}"
printf '%-14s %s\n' "attachment" "${MEDIA_ID:-?}"
