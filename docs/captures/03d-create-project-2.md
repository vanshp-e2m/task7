# POST /wp/v2/projects — seed project 2

## Request

```bash
curl -X POST -u admin:<ADMIN_APP_PASSWORD> -H Content-Type:\ application/json --data-binary @/tmp/tmp.skTnUquC5i/project-2.json http://task-7.local/wp-json/wp/v2/projects
```

## Response — HTTP 201

```json
{
  "id": 29,
  "date": "2026-09-22T05:58:52",
  "date_gmt": "2026-09-22T05:58:52",
  "guid": {
    "rendered": "http://task-7.local/projects/project-2-rest-seeded/",
    "raw": "http://task-7.local/projects/project-2-rest-seeded/"
  },
  "modified": "2026-09-22T05:58:52",
  "modified_gmt": "2026-09-22T05:58:52",
  "password": "",
  "slug": "project-2-rest-seeded",
  "status": "publish",
  "type": "project",
  "link": "http://task-7.local/projects/project-2-rest-seeded/",
  "title": {
    "raw": "Project 2 — REST seeded",
    "rendered": "Project 2 — REST seeded"
  },
  "content": {
    "raw": "<p>Created over the REST API to give <code>e2m/v1/projects/count</code> something to count.</p>",
    "rendered": "<p>Created over the REST API to give <code>e2m/v1/projects/count</code> something to count.</p>\n",
    "protected": false,
    "block_version": 0
  },
  "excerpt": {
    "raw": "Seeded project number 2.",
    "rendered": "<p>Seeded project number 2.</p>\n",
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
  "generated_slug": "project-2-rest-seeded",
  "class_list": [
    "post-29",
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
        "href": "http://task-7.local/wp-json/wp/v2/projects/29",
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
        "href": "http://task-7.local/wp-json/wp/v2/projects/29/revisions"
      }
    ],
    "wp:attachment": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media?parent=29"
      }
    ],
    "wp:term": [
      {
        "taxonomy": "category",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/categories?post=29"
      },
      {
        "taxonomy": "post_tag",
        "embeddable": true,
        "href": "http://task-7.local/wp-json/wp/v2/tags?post=29"
      }
    ],
    "wp:action-publish": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
      }
    ],
    "wp:action-unfiltered-html": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
      }
    ],
    "wp:action-assign-author": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
      }
    ],
    "wp:action-create-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
      }
    ],
    "wp:action-assign-categories": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
      }
    ],
    "wp:action-create-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
      }
    ],
    "wp:action-assign-tags": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/projects/29"
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
