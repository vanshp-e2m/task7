# POST /wp/v2/posts — create a published post

## Request

```bash
curl -X POST -u admin:<ADMIN_APP_PASSWORD> -H Content-Type:\ application/json --data-binary @/tmp/tmp.skTnUquC5i/new-post.json http://task-7.local/wp-json/wp/v2/posts
```

## Response — HTTP 201

```json
{
  "id": 32,
  "date": "2026-09-22T05:58:54",
  "date_gmt": "2026-09-22T05:58:54",
  "guid": {
    "rendered": "http://task-7.local/posted-from-the-rest-api/",
    "raw": "http://task-7.local/posted-from-the-rest-api/"
  },
  "modified": "2026-09-22T05:58:54",
  "modified_gmt": "2026-09-22T05:58:54",
  "password": "",
  "slug": "posted-from-the-rest-api",
  "status": "publish",
  "type": "post",
  "link": "http://task-7.local/posted-from-the-rest-api/",
  "title": {
    "raw": "Posted from the REST API",
    "rendered": "Posted from the REST API"
  },
  "content": {
    "raw": "<p>This post was created with a single authenticated <code>POST /wp-json/wp/v2/posts</code> request using an Application Password. If you can read this in wp-admin, the write path works.</p>",
    "rendered": "<p>This post was created with a single authenticated <code>POST /wp-json/wp/v2/posts</code> request using an Application Password. If you can read this in wp-admin, the write path works.</p>\n",
    "protected": false,
    "block_version": 0
  },
  "excerpt": {
    "raw": "Created over HTTP, not in wp-admin.",
    "rendered": "<p>Created over HTTP, not in wp-admin.</p>\n",
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
  "permalink_template": "http://task-7.local/%postname%/",
  "generated_slug": "posted-from-the-rest-api",
  "class_list": [
    "post-32",
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
        "href": "http://task-7.local/wp-json/wp/v2/posts/32",
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
        "href": "http://task-7.local/wp-json/wp/v2/comments?post=32"
      }
    ],
    "version-history": [
      {
        "count": 0,
        "href": "http://task-7.local/wp-json/wp/v2/posts/32/revisions"
      }
    ],
    "wp:attachment": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media?parent=32"
      }
    ],
    "wp:term": [
      {
        "taxonomy": "category",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/categories?post=32"
      },
      {
        "taxonomy": "post_tag",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/tags?post=32"
      }
    ],
    "wp:action-publish": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-unfiltered-html": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-sticky": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-assign-author": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-create-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-assign-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-create-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
      }
    ],
    "wp:action-assign-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/posts/32"
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
```
