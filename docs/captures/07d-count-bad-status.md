# GET /e2m/v1/projects/count?status=nonsense — argument validation

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/e2m/v1/projects/count\?status=nonsense
```

## Response — HTTP 400

```json
{
  "code": "rest_invalid_param",
  "message": "Invalid parameter(s): status",
  "data": {
    "status": 400,
    "params": {
      "status": "status is not one of publish, draft, pending, private, and future."
    },
    "details": {
      "status": {
        "code": "rest_not_in_enum",
        "message": "status is not one of publish, draft, pending, private, and future.",
        "data": null
      }
    }
  }
}
```
