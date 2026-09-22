# Loom shot list — Task 5 end to end (5 minutes)

The brief: **show task 5 end to end — the POST going out, and the built page
appearing in wp-admin.** Everything else is supporting context. Do not spend
three minutes on the plugin code.

---

## Before you hit record

- [ ] **Close `.env`, and close any terminal tab where the Application Password
      is visible in scrollback.** This is the one thing you cannot fix in post.
      Run `clear` in the terminal you are about to use.
- [ ] Confirm the site is running: `curl -s -o /dev/null -w "%{http_code}" http://task-7.local/` → `200`
- [ ] Open these four tabs, in this order:
      1. Terminal, `cd` into the plugin directory, screen cleared
      2. `http://task-7.local/wp-admin/edit.php?post_type=page`
      3. `http://task-7.local/built-by-the-rest-api/`
      4. VS Code on `includes/rest-routes.php`
- [ ] Zoom the terminal font to ~16pt. JSON is unreadable at default size on
      Loom's compressed video.
- [ ] Have `bash scripts/demo-task5.sh --reset` typed but **not** run.

---

## 0:00 – 0:30 · What you are about to see

> "This is a stock WordPress site. There's one plugin I wrote, and ACF Pro.
> In the next four minutes I'm going to build a complete, editable page —
> hero, text block, image-and-text — without touching wp-admin once. Then
> I'll open wp-admin and show you it's a real page an editor can maintain."

Show tab 2 (**Pages**). Point out there is no "Built by the REST API" page yet.

---

## 0:30 – 1:15 · The field group (context, keep it quick)

Open `includes/acf-field-groups.php`. Scroll to the `layouts` array.

> "`page_sections` is an ACF Flexible Content field with three layouts — hero,
> text_block, media_text. It's registered in PHP so it lives in version
> control."

Then jump to the line that actually matters and **say it out loud**:

```php
'show_in_rest' => 1,
```

> "That's the whole exercise in one line. It's the same as ticking 'Show in
> REST API' on the field group screen. Without it, the POST still returns 201
> — and the fields are silently dropped. Silent success is the worst failure
> mode there is, so this is the first thing to check when ACF data doesn't
> save over the API."

---

## 1:15 – 2:30 · The POST going out ← **the core shot**

Switch to the terminal. Run:

```bash
bash scripts/demo-task5.sh --reset
```

Narrate as each step prints:

1. **Media upload** — "First a `POST /wp/v2/media`. The image is the raw
   request body, and the filename goes in a `Content-Disposition` header — this
   endpoint isn't JSON. It comes back `201` with an attachment ID."

2. **The request body** — scroll so the whole `acf.page_sections` array is on
   screen. Pause here for a beat; this is the money shot.

   > "Three objects in one array. Each one has an `acf_fc_layout` key naming
   > the layout — and that has to match the layout's **name**, not its label.
   > Get it wrong and ACF drops the row and still gives you a 201. Notice the
   > attachment ID from the previous request is dropped straight into two
   > image sub-fields."

3. **`HTTP 201`** — "One request. One page, fully built."

4. **The read-back** — "And reading it back, all three rows come out with the
   values intact. It round-trips."

---

## 2:30 – 3:15 · The page on the front end

Switch to tab 3, hard-refresh (`Ctrl+Shift+R`).

> "Hero with the background image, the text block, the image-and-text section.
> Twenty Twenty-Five is a block theme, so there's no `page.php` — the renderer
> hooks `the_content`, which the post-content block runs. Same code works in
> block and classic themes."

Scroll the full page once, slowly.

---

## 3:15 – 4:15 · The page in wp-admin ← **the second half of the brief**

Switch to tab 2, refresh. The page is now in the list.

Open it. Scroll to the **Page Sections** meta box.

> "Here's the part that matters. Three rows — Hero, Text Block, Media and Text."

**Do these three things on camera:**

1. Expand the Hero row. Show the heading text and the attached image.
2. Change the heading slightly, e.g. add " — edited by hand".
3. Drag a row to reorder it.

> "These are ordinary ACF rows in postmeta. Not serialised blocks, not opaque
> markup. The API built the page, and an editor who has never heard of the API
> can still maintain it. That's the whole point — this isn't a write-only
> pipeline."

Update, then refresh tab 3 to show the hand-edit on the front end.

---

## 4:15 – 5:00 · Why this matters for Module 9

Open `includes/rest-routes.php` (tab 4), show the permission callback.

> "Once a page is addressable as JSON, anything can build it — a migration
> script, a CI job, a form handler, a headless front end. Which is exactly why
> the security side isn't optional.
>
> Three things make that safe. An Application Password you can revoke without
> locking anyone out. A real `permission_callback` on every custom route —
> this one returns 401 if you didn't authenticate and 403 if you did but lack
> the capability. And a least-privileged user for every integration: I made an
> Editor, and it got 403 on creating users, reading settings, and listing
> plugins."

Optional closer if you have 15 seconds spare — run the two requests live:

```bash
# authenticated
curl -s -u "$WP_ADMIN_USER:$WP_ADMIN_APP_PASSWORD" \
  http://task-7.local/wp-json/e2m/v1/projects/count

# unauthenticated — rejected
curl -s http://task-7.local/wp-json/e2m/v1/projects/count
```

> "200 with the count. And with no credentials — 401. Rejected."

**Careful:** the first command expands the password into your scrollback. If
you would rather not risk it, show the captured files instead:
`docs/captures/07a-count-authenticated.md` and `07b-count-unauthenticated.md`,
which are already redacted.

---

## Re-recording

`bash scripts/demo-task5.sh --reset` deletes any previous "Built by the REST
API" pages before creating a new one, so you can take as many attempts as you
need without piling up duplicates.

---

## Things that will trip you up on camera

| Problem | Cause | Fix |
|---|---|---|
| Page renders but sections are missing | ACF Pro deactivated | Reactivate; Flexible Content is PRO-only |
| `201` but `acf` comes back empty | `show_in_rest` off, or `acf_fc_layout` misspelled | Check the layout **name**, not the label |
| Front end shows nothing | Rewrite rules stale | Visit Settings → Permalinks once |
| `401` on every request | Password has stale spaces, or site is not on `localhost` | Re-copy from `.env`; Application Passwords need HTTPS off-local |
