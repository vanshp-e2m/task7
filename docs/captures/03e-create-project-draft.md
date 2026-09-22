# POST /wp/v2/projects — a draft project

## Request

```bash
curl -X POST -u admin:<ADMIN_APP_PASSWORD> -H Content-Type:\ application/json --data-binary @/tmp/tmp.skTnUquC5i/project-draft.json http://task-7.local/wp-json/wp/v2/projects
```

## Response — HTTP 201

```json
{
  "id": 31,
  "date": "2026-09-22T05:58:53",
  "date_gmt": "2026-09-22T05:58:53",
  "guid": {
    "rendered": "http://task-7.local/?post_type=project&p=31",
    "raw": "http://task-7.local/?post_type=project&p=31"
  },
  "modified": "2026-09-22T05:58:53",
  "modified_gmt": "2026-09-22T05:58:53",
  "password": "",
  "slug": "",
  "status": "draft",
  "type": "project",
  "link": "http://task-7.local/?post_type=project&p=31",
  "title": {
    "raw": "Project 4 — still a draft",
    "rendered": "Project 4 — still a draft"
  },
  "content": {
    "raw": "<p>Deliberately left as a draft so the count route can be asked for a non-default status.</p>",
    "rendered": "<p>Deliberately left as a draft so the count route can be asked for a non-default status.</p>\n",
    "protected": false,
    "block_version": 0
  },
  "excerpt": {
    "raw": "",
    "rendered": "<p>Deliberately left as a draft so the count route can be asked for a non-default status.</p>\n",
    "protected": false
  },
  "author": 1,
  "featured_media": 0,
  "template": "",
  "meta": {
    "_acf_changed": false,
    "footnotes": ""
  },
  "categories": [],
  "tags": [],
  "permalink_template": "http://task-7.local/projects/%pagename%/",
  "generated_slug": "project-4-still-a-draft",
  "class_list": [
    "post-31",
    "project",
    "type-project",
    "status-draft",
    "hentry"
  ],
  "acf": {
    "page_sections": null
  },
  "_links": {
    "self": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31",
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
        "href": "http://task-7.local/wp-json/wp/v2/projects"
      }
    ],
    "about": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/types/project"
      }
    ],
    "author": [
      {
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/users/1"
      }
    ],
    "version-history": [
      {
        "count": 0,
        "href": "http://task-7.local/wp-json/wp/v2/projects/31/revisions"
      }
    ],
    "wp:attachment": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media?parent=31"
      }
    ],
    "wp:term": [
      {
        "taxonomy": "category",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/categories?post=31"
      },
      {
        "taxonomy": "post_tag",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/tags?post=31"
      }
    ],
    "wp:action-publish": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
      }
    ],
    "wp:action-unfiltered-html": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
      }
    ],
    "wp:action-assign-author": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
      }
    ],
    "wp:action-create-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
      }
    ],
    "wp:action-assign-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
      }
    ],
    "wp:action-create-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
      }
    ],
    "wp:action-assign-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/31"
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
