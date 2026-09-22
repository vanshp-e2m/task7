# GET /wp/v2/plugins — as Editor (activate_plugins required, must fail)

## Request

```bash
curl -u editor.jane:<EDITOR_APP_PASSWORD> http://task-7.local/wp-json/wp/v2/plugins
```

## Response — HTTP 403

```json
{
  "code": "rest_cannot_view_plugins",
  "message": "Sorry, you are not allowed to manage plugins for this site.",
  "data": {
    "status": 403
  }
}
```
