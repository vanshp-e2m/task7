# GET /wp/v2/posts — list posts

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/wp/v2/posts\?per_page=5
```

## Response — HTTP 200

```json
[
  {
    "id": 1,
    "date": "2026-09-22T05:37:55",
    "date_gmt": "2026-09-22T05:37:55",
    "guid": {
      "rendered": "http://task-7.local/?p=1"
    },
    "modified": "2026-09-22T05:37:55",
    "modified_gmt": "2026-09-22T05:37:55",
    "slug": "hello-world",
    "status": "publish",
    "type": "post",
    "link": "http://task-7.local/hello-world/",
    "title": {
      "rendered": "Hello world!"
    },
    "content": {
      "rendered": "\n<p class=\"wp-block-paragraph\">Welcome to WordPress. This is your first post. Edit or delete it, then start writing!</p>\n",
      "protected": false
    },
    "excerpt": {
      "rendered": "<p>Welcome to WordPress. This is your first post. Edit or delete it, then start writing!</p>\n",
      "protected": false
    },
    "author": 1,
    "featured_media": 0,
    "comment_status": "open",
    "ping_status": "open",
    "sticky": false,
    "template": "",
    "format": "standard",
    "meta": {
      "_acf_changed": false,
      "footnotes": ""
    },
    "categories": [
      1
    ],
    "tags": [],
    "class_list": [
      "post-1",
      "post",
      "type-post",
      "status-publish",
      "format-standard",
      "hentry",
      "category-uncategorized"
    ],
    "acf": [],
    "_links": {
      "self": [
        {
          "href": "http://task-7.local/wp-json/wp/v2/posts/1",
          "targetHints": {
            "allow": [
              "GET",
              "POST",
              "PUT",
              "PATCH",
              "DELETE"
            ]
          }
        }
      ],
      "collection": [
        {
          "href": "http://task-7.local/wp-json/wp/v2/posts"
        }
      ],
      "about": [
        {
          "href": "http://task-7.local/wp-json/wp/v2/types/post"
        }
      ],
      "author": [
        {
          "embeddable": true,
          "href": "http://task-7.local/wp-json/wp/v2/users/1"
        }
      ],
      "replies": [
        {
          "embeddable": true,
          "href": "http://task-7.local/wp-json/wp/v2/comments?post=1"
        }
      ],
      "version-history": [
        {
          "count": 0,
          "href": "http://task-7.local/wp-json/wp/v2/posts/1/revisions"
        }
      ],
      "wp:attachment": [
        {
          "href": "http://task-7.local/wp-json/wp/v2/media?parent=1"
        }
      ],
      "wp:term": [
        {
          "taxonomy": "category",
          "embeddable": true,
          "href": "http://task-7.local/wp-json/wp/v2/categories?post=1"
        },
        {
          "taxonomy": "post_tag",
          "embeddable": true,
          "href": "http://task-7.local/wp-json/wp/v2/tags?post=1"
        }
      ],
      "curies": [
        {
          "name": "wp",
          "href": "https://api.w.org/{rel}",
          "templated": true
        }
      ]
    }
  }
]
```
