# GET /wp/v2/settings — as Administrator (same request, succeeds)

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/wp/v2/settings\?_fields=title\,description\,posts_per_page
```

## Response — HTTP 200

```json
{
  "title": "task 7",
  "description": "",
  "posts_per_page": 10
}
```
