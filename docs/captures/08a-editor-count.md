# GET /e2m/v1/projects/count — as Editor (has edit_posts, so allowed)

## Request

```bash
curl -u editor.jane:<EDITOR_APP_PASSWORD> http://task-7.local/wp-json/e2m/v1/projects/count
```

## Response — HTTP 200

```json
{
  "post_type": "project",
  "status": "publish",
  "count": 3,
  "generated_at": "2026-09-22T05:59:01+00:00",
  "requested_by": "editor.jane"
}
```
