# GET /wp-json/ — namespaces only

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/\?_fields=name\,description\,namespaces
```

## Response — HTTP 200

```json
{
  "name": "task 7",
  "description": "",
  "namespaces": [
    "oembed/1.0",
    "e2m/v1",
    "wp/v2",
    "wp-site-health/v1",
    "wp-block-editor/v1",
    "wp-abilities/v1"
  ]
}
```
