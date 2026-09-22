# GET /wp/v2/settings — as Editor (manage_options required, must fail)

## Request

```bash
curl -u editor.jane:<EDITOR_APP_PASSWORD> http://task-7.local/wp-json/wp/v2/settings
```

## Response — HTTP 403

```json
{
  "code": "rest_forbidden",
  "message": "Sorry, you are not allowed to do that.",
  "data": {
    "status": 403
  }
}
```
