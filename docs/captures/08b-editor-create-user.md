# POST /wp/v2/users — as Editor (admin-only, must fail)

## Request

```bash
curl -X POST -u editor.jane:<EDITOR_APP_PASSWORD> -H Content-Type:\ application/json --data-binary @/tmp/tmp.skTnUquC5i/new-user.json http://task-7.local/wp-json/wp/v2/users
```

## Response — HTTP 403

```json
{
  "code": "rest_cannot_create_user",
  "message": "Sorry, you are not allowed to create new users.",
  "data": {
    "status": 403
  }
}
```
