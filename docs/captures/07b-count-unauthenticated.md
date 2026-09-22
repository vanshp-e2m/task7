# GET /e2m/v1/projects/count — no credentials (must be rejected)

## Request

```bash
curl http://task-7.local/wp-json/e2m/v1/projects/count
```

## Response — HTTP 401

```json
{
  "code": "e2m_rest_not_authenticated",
  "message": "You must be authenticated to read the project count.",
  "data": {
    "status": 401
  }
}
```
