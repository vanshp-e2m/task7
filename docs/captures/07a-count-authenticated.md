# GET /e2m/v1/projects/count — authenticated as administrator

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/e2m/v1/projects/count
```

## Response — HTTP 200

```json
{
  "post_type": "project",
  "status": "publish",
  "count": 3,
  "generated_at": "2026-09-22T05:58:59+00:00",
  "requested_by": "admin"
}
```
