# GET /e2m/v1/projects/count?status=draft — the status argument

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/e2m/v1/projects/count\?status=draft
```

## Response — HTTP 200

```json
{
  "post_type": "project",
  "status": "draft",
  "count": 1,
  "generated_at": "2026-09-22T05:59:00+00:00",
  "requested_by": "admin"
}
```
