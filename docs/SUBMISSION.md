# Module 9 — WordPress REST API Practical

**Site:** `http://task-7.local` (Local by Flywheel, WordPress 7.1.1, PHP 8.2.29)
**Plugin under test:** `e2m-rest-lab` (in this repository)
**ACF:** Advanced Custom Fields PRO 6.8.5
**Date run:** 22 September 2026
**Video walkthrough:**
[Part 1](https://www.loom.com/share/cadd9aabbdbb43b0bbfe136900cdb79c) ·
[Part 2](https://www.loom.com/share/01ac5df480344e258e5aac393724a478)

Every request below was executed against a live site. The full, unedited
request/response pair for each one is in [`docs/captures/`](captures/), named by
exercise. Application Passwords are redacted as `<ADMIN_APP_PASSWORD>` and
`<EDITOR_APP_PASSWORD>` everywhere; the real values live only in a gitignored
`.env`.

All of it is reproducible from a clean checkout with:

```bash
cp .env.example .env    # then fill in the two Application Passwords
bash scripts/run-all.sh
```

---

## Summary of results

| # | Exercise | Expected | Actual | Capture |
|---|----------|----------|--------|---------|
| 1 | Application Password created, stored in gitignored `.env` | — | Done, 2 passwords | — |
| 2 | `GET /wp/v2/posts`, then one post with `?_embed` | 200 | **200** | [02a](captures/02a-list-posts.md), [02b](captures/02b-single-post-embed.md) |
| 3 | `project` CPT route present in `/wp-json/` index | present | **present** | [03b](captures/03b-index-project-routes.md), [03c](captures/03c-projects-route-schema.md) |
| 4 | `POST /wp/v2/posts` | 201 | **201** | [04](captures/04-create-post.md) |
| 5 | `POST /wp/v2/pages` with 3 Flexible Content layouts | 201 | **201** | [05a](captures/05a-create-page-acf.md), [05b](captures/05b-read-page-acf.md) |
| 6 | `POST /wp/v2/media`, ID reused in an image sub-field | 201 | **201**, ID 33 | [06](captures/06-upload-media.md) |
| 7 | `e2m/v1/projects/count` authenticated | 200 | **200** | [07a](captures/07a-count-authenticated.md) |
| 7 | `e2m/v1/projects/count` **unauthenticated** | rejected | **401** | [07b](captures/07b-count-unauthenticated.md) |
| 8 | Editor attempts admin-only actions | rejected | **403 ×3** | [08b](captures/08b-editor-create-user.md), [08c](captures/08c-editor-read-settings.md), [08d](captures/08d-editor-list-plugins.md) |

---

## 1. Application Password

Created in wp-admin under **Users → Profile → Application Passwords → Add New**
(the equivalent WP-CLI command is `wp user application-password create admin "REST Lab CLI"`).

WordPress displays the generated password exactly once, in
`xxxx xxxx xxxx xxxx xxxx xxxx` form. The spaces are cosmetic — they can be
sent or stripped, WordPress ignores them.

It is stored in `.env`, which is listed in `.gitignore`:

```
WP_BASE_URL=http://task-7.local
WP_ADMIN_USER=admin
WP_ADMIN_APP_PASSWORD=<ADMIN_APP_PASSWORD>
WP_EDITOR_USER=editor.jane
WP_EDITOR_APP_PASSWORD=<EDITOR_APP_PASSWORD>
```

Authentication is HTTP Basic, which curl sends with `-u user:password`:

```bash
curl -u "admin:<ADMIN_APP_PASSWORD>" http://task-7.local/wp-json/wp/v2/users/me
```

Two points worth recording:

- Application Passwords are **per-application, individually revocable**
  credentials. Revoking one does not lock the user out of wp-admin, which is
  exactly why you never put the account's real login password in a script.
- WordPress refuses Application Passwords over plain HTTP on production
  environments. This works here only because Local sets the environment type to
  `local`. On a real site this must be HTTPS.

---

## 2. Read — `GET /wp/v2/posts` and `?_embed`

Listing posts is unauthenticated-readable, but the request was sent
authenticated anyway so that any draft-visibility differences would show up.

```bash
curl -u "admin:<ADMIN_APP_PASSWORD>" \
  "http://task-7.local/wp-json/wp/v2/posts?per_page=5"
```

### What `?_embed` actually adds

A plain `GET /wp/v2/posts/1` returns `author: 1`, `featured_media: 0`,
`categories: [1]` — **integer IDs**. Resolving them means one extra HTTP request
per relation, which is the classic N+1 problem.

Adding `?_embed` makes WordPress resolve every relation in `_links` that is
marked embeddable and return them inline under a new `_embedded` key:

| `_embedded` key | Contains | Replaces the request to |
|---|---|---|
| `author` | Full user object: `id, name, url, description, link, slug, avatar_urls` | `/wp/v2/users/1` |
| `replies` | Approved comments: `id, parent, author_name, date, content, link` | `/wp/v2/comments?post=1` |
| `wp:term` | Categories and tags: `id, link, name, slug, taxonomy` | `/wp/v2/categories`, `/wp/v2/tags` |
| `wp:featuredmedia` | The attachment object, incl. all generated sizes | `/wp/v2/media/<id>` |

`wp:featuredmedia` only appears when the post actually has a featured image;
`Hello world!` does not, so it is absent from this capture.

**The takeaway:** `_embed` turns four round trips into one. On a headless front
end rendering a post list, this is the difference between a fast page and a
waterfall of requests. The cost is payload size — embed only when you need the
related data.

See [`captures/02b-single-post-embed.md`](captures/02b-single-post-embed.md).

---

## 3. Explore — finding the `project` CPT in the index

`GET /wp-json/` returns the discovery document: every namespace and every route
the site exposes. Filtered to what this module registers (8 of 141 routes):

```
/e2m/v1                                         GET
/e2m/v1/projects/count                          GET
/wp/v2/projects                                 GET, POST
/wp/v2/projects/(?P<id>[\d]+)                   GET, POST, PUT, PATCH, DELETE
/wp/v2/projects/(?P<id>[\d]+)/autosaves         GET, POST
/wp/v2/projects/(?P<parent>[\d]+)/autosaves/... GET
/wp/v2/projects/(?P<parent>[\d]+)/revisions     GET
/wp/v2/projects/(?P<parent>[\d]+)/revisions/... GET, DELETE
```

The CPT **was** missing from the index initially, because this site started
with no plugin registering it at all. The registration that puts it there is in
[`includes/post-types.php`](../includes/post-types.php), and the three lines
that matter are:

```php
'show_in_rest' => true,
'rest_base'    => 'projects',
'rest_controller_class' => 'WP_REST_Posts_Controller',
```

Without `show_in_rest => true` the CPT still works perfectly in wp-admin and is
completely invisible to every REST client — no route, no index entry, no error
message. That silence is the trap this exercise is pointing at: if a CPT is
"missing from the API", check `show_in_rest` before you check anything else.

`rest_base` is what renames the route from `/wp/v2/project` (the post type name)
to `/wp/v2/projects`. Leaving it out is not an error, but it produces an
inconsistent API surface.

---

## 4. Write — `POST /wp/v2/posts`

```bash
curl -X POST -u "admin:<ADMIN_APP_PASSWORD>" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Posted from the REST API",
    "status": "publish",
    "content": "<p>This post was created with a single authenticated POST…</p>",
    "excerpt": "Created over HTTP, not in wp-admin."
  }' \
  http://task-7.local/wp-json/wp/v2/posts
```

**`HTTP 201 Created`**, post ID 32. Confirmed in wp-admin under **Posts → All
Posts**, published, author `admin`, fully editable.

Notes:

- `status` defaults to `draft`. You must pass `"publish"` explicitly, and the
  authenticated user needs the `publish_posts` capability to do so.
- `title` and `content` accept either a plain string or the object form
  `{"raw": "…"}`. The string form is what the API returns to you as `rendered`,
  so the two are not symmetrical — read `title.rendered`, write `title`.

---

## 5. Write ACF — three Flexible Content layouts in one POST

**This is the core exercise.**

### Enabling REST on the field group

The `page_sections` field group is registered in PHP in
[`includes/acf-field-groups.php`](../includes/acf-field-groups.php) so the
schema lives in version control. The setting that matters is:

```php
'show_in_rest' => 1,
```

That is the PHP equivalent of ticking **Show in REST API** on the field group's
settings screen in the ACF UI. Without it the `acf` key is neither returned by
`GET` nor accepted by `POST` — the request still returns `201`, but the fields
are silently dropped. Silent success on a write is the single most confusing
failure in this whole module.

### The field group

| Layout | Name | Sub-fields |
|---|---|---|
| Hero | `hero` | `heading` (text, required), `subheading` (textarea), `background_image` (image → ID), `cta_label` (text), `cta_url` (url) |
| Text Block | `text_block` | `heading` (text), `body` (wysiwyg), `alignment` (select: left/center) |
| Media and Text | `media_text` | `heading` (text), `body` (textarea), `image` (image → ID), `image_position` (select: left/right) |

Both image fields use `'return_format' => 'id'`. That keeps the payload
symmetrical — `GET` returns an attachment ID and `POST` accepts the same
attachment ID — which makes the media exercise in §6 a straight copy-paste.

### The request

```bash
curl -X POST -u "admin:<ADMIN_APP_PASSWORD>" \
  -H "Content-Type: application/json" \
  -d @page.json \
  http://task-7.local/wp-json/wp/v2/pages
```

```json
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
        "background_image": 33,
        "cta_label": "See the route code",
        "cta_url": "http://task-7.local/wp-json/e2m/v1/projects/count"
      },
      {
        "acf_fc_layout": "text_block",
        "heading": "Why this matters",
        "body": "<p>Once a page is addressable as structured JSON, anything can build it…</p>",
        "alignment": "left"
      },
      {
        "acf_fc_layout": "media_text",
        "heading": "The image came from the media endpoint",
        "body": "This image was uploaded with POST /wp/v2/media in the previous request…",
        "image": 33,
        "image_position": "left"
      }
    ]
  }
}
```

**`HTTP 201 Created`**, page ID 34, `link: http://task-7.local/built-by-the-rest-api/`.

### The critical detail: `acf_fc_layout`

Each row of a Flexible Content field is an object whose `acf_fc_layout` key
names the layout. It must match the layout's **`name`** in the field group
(`hero`, `text_block`, `media_text`) — not its label ("Hero", "Text Block",
"Media and Text"). Get it wrong and ACF discards the row without complaint, and
you still get a `201`.

The order of the array is the order of the sections on the page. Reordering is
just reordering the JSON.

### Verification

**Read back over REST** — [`captures/05b-read-page-acf.md`](captures/05b-read-page-acf.md)
returns all three rows with the values intact, including `background_image: 33`.

**Front end** — `GET http://task-7.local/built-by-the-rest-api/` returns `200`
and the HTML contains all three sections:

```
<h2 class="e2m-section__heading">Built entirely over HTTP</h2>
<h2 class="e2m-section__heading">Why this matters</h2>
<h2 class="e2m-section__heading">The image came from the media endpoint</h2>
```

Twenty Twenty-Five is a block theme, so there is no `page.php` to edit. The
renderer in [`includes/render-sections.php`](../includes/render-sections.php)
hooks `the_content` instead, which the core/post-content block runs — so the
same code works in block and classic themes. It carries a static recursion
guard because the WYSIWYG sub-field re-enters `the_content`.

**wp-admin** — the page edit screen shows a **Page Sections** meta box with
three collapsed rows labelled Hero, Text Block and Media and Text. They can be
expanded, edited, reordered by drag, and deleted like any hand-built page.
Confirmed programmatically:

```
GROUP: Page Sections (key=group_page_sections) show_in_rest=1
  FIELD: Page Sections (page_sections) type=flexible_content
         layouts=layout_hero,layout_text_block,layout_media_text
SAVED ROWS: 3
  row 0 = hero
  row 1 = text_block
  row 2 = media_text
```

These are ordinary ACF rows in `wp_postmeta`, not serialised blobs or opaque
markup. **That is the whole point** — the API wrote the page, and a human editor
who has never heard of the API can still maintain it.

---

## 6. Upload media

Media upload does **not** use JSON. The file is the raw request body, and the
filename travels in a `Content-Disposition` header:

```bash
curl -X POST -u "admin:<ADMIN_APP_PASSWORD>" \
  -H "Content-Disposition: attachment; filename=e2m-rest-lab-sample.png" \
  -H "Content-Type: image/png" \
  --data-binary "@scripts/sample-image.png" \
  http://task-7.local/wp-json/wp/v2/media
```

**`HTTP 201 Created`**, attachment ID **33**. WordPress generated the full size
set (`300x158`, `768x403`, `1024x538`, plus the 1200×630 original) and returned
them under `media_details.sizes`.

That ID 33 was then dropped straight into two image sub-fields in §5:
`hero.background_image` and `media_text.image`. On the front end it renders as
a responsive `<img>` with a full `srcset`, because it is a genuine attachment —
not a hotlinked URL:

```
e2m-rest-lab-sample-1024x538.png 1024w,
e2m-rest-lab-sample-300x158.png   300w,
e2m-rest-lab-sample-768x403.png   768w,
e2m-rest-lab-sample.png          1200w
```

Two gotchas worth recording:

- Omit `Content-Disposition` and the upload fails — WordPress has no filename
  to work with.
- `Content-Type` must be the real MIME type of the bytes. It is what WordPress
  checks against the allowed-upload list, not the file extension.

The sample image is generated by [`scripts/make-sample-image.php`](../scripts/make-sample-image.php)
so this is reproducible without sourcing a stock photo.

---

## 7. Custom route — `e2m/v1/projects/count`

Full source: [`includes/rest-routes.php`](../includes/rest-routes.php).

### Registration

```php
register_rest_route(
    'e2m/v1',
    '/projects/count',
    array(
        array(
            'methods'             => WP_REST_Server::READABLE,
            'callback'            => 'e2m_rest_lab_get_projects_count',

            // NEVER __return_true here. This callback is the only thing
            // standing between this data and the open internet.
            'permission_callback' => 'e2m_rest_lab_projects_count_permission',
            'args'                => array(
                'status' => array(
                    'description'       => 'Post status to count. Defaults to publish.',
                    'type'              => 'string',
                    'default'           => 'publish',
                    'enum'              => array( 'publish', 'draft', 'pending', 'private', 'future' ),
                    'sanitize_callback' => 'sanitize_key',
                    'validate_callback' => 'rest_validate_request_arg',
                ),
            ),
        ),
        'schema' => 'e2m_rest_lab_projects_count_schema',
    )
);
```

### The permission callback

```php
function e2m_rest_lab_projects_count_permission( WP_REST_Request $request ) {
    if ( ! is_user_logged_in() ) {
        return new WP_Error(
            'e2m_rest_not_authenticated',
            __( 'You must be authenticated to read the project count.', 'e2m-rest-lab' ),
            array( 'status' => 401 )
        );
    }

    if ( ! current_user_can( 'edit_posts' ) ) {
        return new WP_Error(
            'e2m_rest_forbidden',
            __( 'Your account does not have permission to read the project count.', 'e2m-rest-lab' ),
            array( 'status' => 403 )
        );
    }

    return true;
}
```

The two failures are reported separately on purpose, because they mean different
things to a client: **401** says "you did not authenticate", **403** says "we
know who you are and you still may not do this". Returning a bare `false` would
collapse both into a generic `rest_forbidden` and make the route harder to
integrate against.

### The handler

```php
$counts = wp_count_posts( 'project' );
$count  = isset( $counts->$status ) ? (int) $counts->$status : 0;
```

`wp_count_posts()` is one cached query. Running a `WP_Query` and counting the
returned posts would load every post object into memory to produce a single
integer.

### Results

| Request | Status | Body |
|---|---|---|
| Authenticated as `admin` | **200** | `{"post_type":"project","status":"publish","count":3,…}` |
| **No credentials** | **401** | `{"code":"e2m_rest_not_authenticated","message":"You must be authenticated to read the project count.","data":{"status":401}}` |
| `?status=draft` | **200** | `count: 1` |
| `?status=nonsense` | **400** | `{"code":"rest_invalid_param","message":"Invalid parameter(s): status"…}` |

**The unauthenticated request is rejected — confirmed, `HTTP 401`.**

### One thing that bit me, worth writing down

The `?status=nonsense` request initially returned **200** with `count: 0`, not
`400`. `register_rest_route()` does **not** add a `validate_callback` for you —
without that line the `enum` is documentation only and any string sails through
to the handler. Adding `'validate_callback' => 'rest_validate_request_arg'` is
what turns the declared schema into an enforced one. Both captures are in the
repo history.

---

## 8. Least privilege — what happened

A second user was created with the **Editor** role and given its own Application
Password:

```
editor.jane — role: editor
```

### What the Editor could do

`GET /wp-json/e2m/v1/projects/count` → **`HTTP 200`**

```json
{
  "post_type": "project",
  "status": "publish",
  "count": 3,
  "generated_at": "2026-09-22T05:59:01+00:00",
  "requested_by": "editor.jane"
}
```

This is correct and deliberate: the permission callback requires `edit_posts`,
and an Editor has it. Note `requested_by` reflects the authenticated identity —
the Application Password resolves to a real WordPress user with that user's full
capability set, not to some separate "API user".

### What the Editor could not do

| Request | Status | `code` | `message` |
|---|---|---|---|
| `POST /wp/v2/users` (create an administrator) | **403** | `rest_cannot_create_user` | Sorry, you are not allowed to create new users. |
| `GET /wp/v2/settings` | **403** | `rest_forbidden` | Sorry, you are not allowed to do that. |
| `GET /wp/v2/plugins` | **403** | `rest_cannot_view_plugins` | Sorry, you are not allowed to manage plugins for this site. |

The same `GET /wp/v2/settings` request as `admin` returns **`HTTP 200`** with
the site title and description — same route, same method, same credentials
mechanism, different capability.

### What this demonstrates

1. **Application Passwords do not grant privileges — they carry them.** The
   password authenticates *who you are*; the role decides *what you may do*.
   There is no way to make an Editor's Application Password do administrator
   things, which is exactly why integrations should be issued their own
   least-privileged user rather than handed the admin account.

2. **Core endpoints already enforce capabilities properly.** `create_users`,
   `manage_options` and `activate_plugins` were each checked and each refused,
   with a distinct error code per endpoint. Custom routes get none of this for
   free — that is what §7's `permission_callback` is for.

3. **The blast radius of a leak is bounded by the role.** If
   `editor.jane`'s password leaked, the attacker gets content editing — bad, but
   recoverable, and revocable from that one user's profile without touching
   anyone else's access. If the admin password leaked, they get the site.

---

## Why this matters for the rest of Module 9

Once a page is addressable as structured JSON, the CMS stops being the only way
in. The same `POST` that built this page can come from a migration script, a CI
job, a form handler, a headless front end, or another service entirely — and the
page it produces is still a real WordPress page that a human editor can open and
change.

The three things that make that safe rather than reckless are all in this
practical: an **Application Password** you can revoke without locking anyone out,
a **`permission_callback`** on every custom route, and a **least-privileged user**
for every integration.

---

## Artefacts created by this run

| Type | ID | Notes |
|---|---|---|
| Post | 32 | "Posted from the REST API" |
| Page | 34 | "Built by the REST API" — `/built-by-the-rest-api/` |
| Attachment | 33 | `e2m-rest-lab-sample.png`, 1200×630 |
| Projects | 28, 29, 30 | Published — counted by the custom route |
| Project | 31 | Draft — counted only via `?status=draft` |
| User | 2 | `editor.jane`, Editor role |

The IDs above are from the run recorded here. `scripts/run-all.sh` creates new
content each time it runs, so a later run produces different IDs — the statuses
and behaviour are what should be compared, not the numbers.
