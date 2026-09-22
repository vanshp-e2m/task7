# POST /wp/v2/pages — page with three ACF layouts

## Request

```bash
curl -X POST -u admin:<ADMIN_APP_PASSWORD> -H Content-Type:\ application/json --data-binary @/tmp/tmp.skTnUquC5i/new-page.json http://task-7.local/wp-json/wp/v2/pages
```

## Response — HTTP 201

```json
{
  "id": 34,
  "date": "2026-09-22T05:58:57",
  "date_gmt": "2026-09-22T05:58:57",
  "guid": {
    "rendered": "http://task-7.local/built-by-the-rest-api/",
    "raw": "http://task-7.local/built-by-the-rest-api/"
  },
  "modified": "2026-09-22T05:58:57",
  "modified_gmt": "2026-09-22T05:58:57",
  "password": "",
  "slug": "built-by-the-rest-api",
  "status": "publish",
  "type": "page",
  "link": "http://task-7.local/built-by-the-rest-api/",
  "title": {
    "raw": "Built by the REST API",
    "rendered": "Built by the REST API"
  },
  "content": {
    "raw": "<p>Everything below this paragraph is ACF Flexible Content written in the same request.</p>",
    "rendered": "<p>Everything below this paragraph is ACF Flexible Content written in the same request.</p>\n",
    "protected": false,
    "block_version": 0
  },
  "excerpt": {
    "raw": "",
    "rendered": "<p>Everything below this paragraph is ACF Flexible Content written in the same request.</p>\n",
    "protected": false
  },
  "author": 1,
  "featured_media": 0,
  "parent": 0,
  "menu_order": 0,
  "comment_status": "closed",
  "ping_status": "closed",
  "template": "",
  "meta": {
    "_acf_changed": false,
    "footnotes": ""
  },
  "permalink_template": "http://task-7.local/%pagename%/",
  "generated_slug": "built-by-the-rest-api",
  "class_list": [
    "post-34",
    "page",
    "type-page",
    "status-publish",
    "hentry"
  ],
  "acf": {
    "page_sections": [
      {
        "acf_fc_layout": "hero",
        "heading": "Built entirely over HTTP",
        "subheading": "Three Flexible Content layouts, one authenticated POST, zero clicks in wp-admin.",
        "background_image": 33,
        "cta_label": "See the route code",
        "cta_url": "http://task-7.local/wp-json/e2m/v1/projects/count"
      },
      {
        "acf_fc_layout": "text_block",
        "heading": "Why this matters",
        "body": "<p>Once a page is addressable as structured JSON, anything can build it: a migration script, a CI job, a headless front end, or another service entirely. The editor keeps a real, editable page in wp-admin — the sections are ordinary ACF rows, not opaque markup.</p><p>That is the whole promise of Module 9: the CMS stops being the only way in.</p>",
        "alignment": "left"
      },
      {
        "acf_fc_layout": "media_text",
        "heading": "The image came from the media endpoint",
        "body": "This image was uploaded with POST /wp/v2/media in the previous request. The attachment ID it returned was dropped straight into this layout's image sub-field.",
        "image": 33,
        "image_position": "left"
      }
    ]
  },
  "_links": {
    "self": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/pages/34",
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
        "href": "http://task-7.local/wp-json/wp/v2/pages"
      }
    ],
    "about": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/types/page"
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
        "href": "http://task-7.local/wp-json/wp/v2/comments?post=34"
      }
    ],
    "version-history": [
      {
        "count": 0,
        "href": "http://task-7.local/wp-json/wp/v2/pages/34/revisions"
      }
    ],
    "wp:attachment": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media?parent=34"
      }
    ],
    "wp:action-publish": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/pages/34"
      }
    ],
    "wp:action-unfiltered-html": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/pages/34"
      }
    ],
    "wp:action-assign-author": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/pages/34"
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
