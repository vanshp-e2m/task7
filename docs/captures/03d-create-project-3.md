# POST /wp/v2/projects — seed project 3

## Request

```bash
curl -X POST -u admin:<ADMIN_APP_PASSWORD> -H Content-Type:\ application/json --data-binary @/tmp/tmp.skTnUquC5i/project-3.json http://task-7.local/wp-json/wp/v2/projects
```

## Response — HTTP 201

```json
{
  "id": 30,
  "date": "2026-09-22T05:58:53",
  "date_gmt": "2026-09-22T05:58:53",
  "guid": {
    "rendered": "http://task-7.local/projects/project-3-rest-seeded/",
    "raw": "http://task-7.local/projects/project-3-rest-seeded/"
  },
  "modified": "2026-09-22T05:58:53",
  "modified_gmt": "2026-09-22T05:58:53",
  "password": "",
  "slug": "project-3-rest-seeded",
  "status": "publish",
  "type": "project",
  "link": "http://task-7.local/projects/project-3-rest-seeded/",
  "title": {
    "raw": "Project 3 — REST seeded",
    "rendered": "Project 3 — REST seeded"
  },
  "content": {
    "raw": "<p>Created over the REST API to give <code>e2m/v1/projects/count</code> something to count.</p>",
    "rendered": "<p>Created over the REST API to give <code>e2m/v1/projects/count</code> something to count.</p>\n",
    "protected": false,
    "block_version": 0
  },
  "excerpt": {
    "raw": "Seeded project number 3.",
    "rendered": "<p>Seeded project number 3.</p>\n",
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
  "generated_slug": "project-3-rest-seeded",
  "class_list": [
    "post-30",
    "project",
    "type-project",
    "status-publish",
    "hentry"
  ],
  "acf": {
    "page_sections": null
  },
  "_links": {
    "self": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30",
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
        "href": "http://task-7.local/wp-json/wp/v2/projects/30/revisions"
      }
    ],
    "wp:attachment": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media?parent=30"
      }
    ],
    "wp:term": [
      {
        "taxonomy": "category",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/categories?post=30"
      },
      {
        "taxonomy": "post_tag",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/tags?post=30"
      }
    ],
    "wp:action-publish": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
      }
    ],
    "wp:action-unfiltered-html": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
      }
    ],
    "wp:action-assign-author": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
      }
    ],
    "wp:action-create-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
      }
    ],
    "wp:action-assign-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
      }
    ],
    "wp:action-create-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
      }
    ],
    "wp:action-assign-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/30"
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
