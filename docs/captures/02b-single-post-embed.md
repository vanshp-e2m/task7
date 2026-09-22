# GET /wp/v2/posts/1?_embed — embedded resources

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/wp/v2/posts/1\?_embed
```

## Response — HTTP 200

```json
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
  },
  "_embedded": {
    "author": [
      {
        "id": 1,
        "name": "admin",
        "url": "http://task-7.local",
        "description": "",
        "link": "http://task-7.local/author/admin/",
        "slug": "admin",
        "avatar_urls": {
          "24": "https://secure.gravatar.com/avatar/33e54dec0cd79fc4b5e911c15f836c46ec8d0e452ecd3ca5f707bce0a3540a3b?s=24&d=mm&r=g",
          "48": "https://secure.gravatar.com/avatar/33e54dec0cd79fc4b5e911c15f836c46ec8d0e452ecd3ca5f707bce0a3540a3b?s=48&d=mm&r=g",
          "96": "https://secure.gravatar.com/avatar/33e54dec0cd79fc4b5e911c15f836c46ec8d0e452ecd3ca5f707bce0a3540a3b?s=96&d=mm&r=g"
        },
        "acf": [],
        "_links": {
          "self": [
            {
              "href": "http://task-7.local/wp-json/wp/v2/users/1",
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
              "href": "http://task-7.local/wp-json/wp/v2/users"
            }
          ]
        }
      }
    ],
    "replies": [
      [
        {
          "id": 1,
          "parent": 0,
          "author": 0,
          "author_name": "A WordPress Commenter",
          "author_url": "https://wordpress.org/",
          "date": "2026-09-22T05:37:55",
          "content": {
            "rendered": "<p>Hi, this is a comment.<br />\nTo get started with moderating, editing, and deleting comments, please visit the Comments screen in the dashboard.<br />\nCommenter avatars come from <a href=\"https://gravatar.com/\">Gravatar</a>.</p>\n"
          },
          "link": "http://task-7.local/hello-world/#comment-1",
          "type": "comment",
          "author_avatar_urls": {
            "24": "https://secure.gravatar.com/avatar/8e1606e6fba450a9362af43874c1b2dfad34c782e33d0a51e1b46c18a2a567dd?s=24&d=mm&r=g",
            "48": "https://secure.gravatar.com/avatar/8e1606e6fba450a9362af43874c1b2dfad34c782e33d0a51e1b46c18a2a567dd?s=48&d=mm&r=g",
            "96": "https://secure.gravatar.com/avatar/8e1606e6fba450a9362af43874c1b2dfad34c782e33d0a51e1b46c18a2a567dd?s=96&d=mm&r=g"
          },
          "acf": [],
          "_links": {
            "self": [
              {
                "href": "http://task-7.local/wp-json/wp/v2/comments/1",
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
                "href": "http://task-7.local/wp-json/wp/v2/comments"
              }
            ],
            "up": [
              {
                "embeddable": true,
                "post_type": "post",
                "href": "http://task-7.local/wp-json/wp/v2/posts/1"
              }
            ]
          }
        }
      ]
    ],
    "wp:term": [
      [
        {
          "id": 1,
          "link": "http://task-7.local/category/uncategorized/",
          "name": "Uncategorized",
          "slug": "uncategorized",
          "taxonomy": "category",
          "acf": [],
          "_links": {
            "self": [
              {
                "href": "http://task-7.local/wp-json/wp/v2/categories/1",
                "targetHints": {
                  "allow": [
                    "GET",
                    "POST",
                    "PUT",
                    "PATCH"
                  ]
                }
              }
            ],
            "collection": [
              {
                "href": "http://task-7.local/wp-json/wp/v2/categories"
              }
            ],
            "about": [
              {
                "href": "http://task-7.local/wp-json/wp/v2/taxonomies/category"
              }
            ],
            "wp:post_type": [
              {
                "href": "http://task-7.local/wp-json/wp/v2/posts?categories=1"
              },
              {
                "href": "http://task-7.local/wp-json/wp/v2/projects?categories=1"
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
      ],
      []
    ]
  }
}
```
