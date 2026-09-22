# E2M REST Lab

Module 9 practical: building and securing a complete WordPress page over the
REST API.

This is a working WordPress plugin. It registers a `project` custom post type
exposed to REST, an ACF Flexible Content field group (`page_sections`) that can
be **written** over REST, a theme-independent front-end renderer for those
sections, and a custom `e2m/v1/projects/count` route behind a real permission
callback.

**The write-up with every request and response is in
[`docs/SUBMISSION.md`](docs/SUBMISSION.md).**

---

## What it demonstrates

| Exercise | Where |
|---|---|
| Application Password auth | [`.env.example`](.env.example), [`docs/SUBMISSION.md`](docs/SUBMISSION.md#1-application-password) |
| Reading with `?_embed` | [`docs/captures/02b-single-post-embed.md`](docs/captures/02b-single-post-embed.md) |
| CPT exposed in the `/wp-json/` index | [`includes/post-types.php`](includes/post-types.php) |
| Writing posts over REST | [`docs/captures/04-create-post.md`](docs/captures/04-create-post.md) |
| **Writing ACF Flexible Content over REST** | [`includes/acf-field-groups.php`](includes/acf-field-groups.php) |
| Rendering those sections on the front end | [`includes/render-sections.php`](includes/render-sections.php) |
| Media upload + reusing the attachment ID | [`docs/captures/06-upload-media.md`](docs/captures/06-upload-media.md) |
| Custom route with a real `permission_callback` | [`includes/rest-routes.php`](includes/rest-routes.php) |
| Least privilege (Editor vs Administrator) | [`docs/SUBMISSION.md`](docs/SUBMISSION.md#8-least-privilege--what-happened) |

---

## Requirements

- WordPress 6.4+, PHP 8.0+
- **Advanced Custom Fields PRO** — Flexible Content is a PRO-only field type,
  so the free ACF / Secure Custom Fields build will not work for the `acf`
  write exercise.
- `curl` and `node` on the machine running the scripts (node is used only to
  pretty-print JSON).

---

## Setup

1. Copy this directory into `wp-content/plugins/`.
2. Activate **Advanced Custom Fields PRO**, then **E2M REST Lab**.
3. Visit **Settings → Permalinks** once (or run `wp rewrite flush`) so the
   `project` archive resolves.
4. Create an Application Password: **Users → Profile → Application Passwords →
   Add New**. WordPress shows it once.
5. Copy the environment file and fill it in:

   ```bash
   cp .env.example .env
   ```

   `.env` is gitignored. Do not commit it, and do not show it on screen in a
   recording.

## Running the practical

```bash
bash scripts/run-all.sh
```

Every request is executed in order and each request/response pair is written to
`docs/captures/<exercise>.md` with credentials redacted. The script prints a
status line per request, so a regression shows up immediately:

```
== Exercise 7 — Custom route and its permission callback ==
  07a-count-authenticated                HTTP 200
  07b-count-unauthenticated              HTTP 401
  07c-count-draft-status                 HTTP 200
  07d-count-bad-status                   HTTP 400
```

To regenerate the sample image used by the media exercise:

```bash
php scripts/make-sample-image.php
```

---

## The custom route

```
GET /wp-json/e2m/v1/projects/count[?status=publish|draft|pending|private|future]
```

| Caller | Response |
|---|---|
| Not authenticated | `401 e2m_rest_not_authenticated` |
| Authenticated without `edit_posts` | `403 e2m_rest_forbidden` |
| Authenticated with `edit_posts` | `200` + `{ post_type, status, count, generated_at, requested_by }` |
| `?status=` outside the enum | `400 rest_invalid_param` |

The permission callback returns a `WP_Error` with a distinct status for each
failure rather than a bare `false`, so a client can tell "you did not
authenticate" apart from "you may not do this".

---

## Layout reference

The `page_sections` Flexible Content field accepts these layouts. The
`acf_fc_layout` value must match the layout **name**, not its label.

### `hero`

```json
{
  "acf_fc_layout": "hero",
  "heading": "string (required)",
  "subheading": "string",
  "background_image": 33,
  "cta_label": "string",
  "cta_url": "https://…"
}
```

### `text_block`

```json
{
  "acf_fc_layout": "text_block",
  "heading": "string",
  "body": "<p>HTML</p>",
  "alignment": "left | center"
}
```

### `media_text`

```json
{
  "acf_fc_layout": "media_text",
  "heading": "string",
  "body": "string",
  "image": 33,
  "image_position": "left | right"
}
```

Both image fields use `'return_format' => 'id'`, so `GET` returns an attachment
ID and `POST` accepts the same attachment ID.

---

## Repository layout

```
e2m-rest-lab.php              Plugin bootstrap, activation hooks
includes/
  post-types.php              `project` CPT, exposed to REST
  acf-field-groups.php        `page_sections` Flexible Content, show_in_rest
  rest-routes.php             e2m/v1/projects/count + permission callback
  render-sections.php         Front-end renderer (hooks the_content)
assets/sections.css           Minimal, theme-agnostic section styles
scripts/
  run-all.sh                  Runs every exercise, writes docs/captures/
  demo-task5.sh               Task 5 alone, formatted for screen recording
  make-sample-image.php       Generates the PNG for the media exercise
docs/
  SUBMISSION.md               The write-up
  loom-script.md              Shot list for the 5-minute walkthrough
  captures/                   Request/response pairs, credentials redacted
```

---

## Security notes

- `.env` is gitignored and contains the only copies of the Application
  Passwords. Everything committed uses `<ADMIN_APP_PASSWORD>` /
  `<EDITOR_APP_PASSWORD>` placeholders.
- This runs over plain HTTP only because Local reports the environment type as
  `local`. WordPress refuses Application Passwords over HTTP anywhere else, and
  it is right to.
- `editor.jane` exists to prove that an integration credential should carry the
  least privilege that does the job. See
  [`docs/SUBMISSION.md`](docs/SUBMISSION.md#8-least-privilege--what-happened).
