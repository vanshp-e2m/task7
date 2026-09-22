# POST /wp/v2/media — upload a PNG

## Request

```bash
curl -X POST -u admin:<ADMIN_APP_PASSWORD> -H Content-Disposition:\ attachment\;\ filename=e2m-rest-lab-sample.png -H Content-Type:\ image/png --data-binary @/c/Users/Vansh\ Patel/Local\ Sites/task-7/app/public/wp-content/plugins/e2m-rest-lab/scripts/sample-image.png http://task-7.local/wp-json/wp/v2/media
```

## Response — HTTP 201

```json
{
  "id": 33,
  "date": "2026-09-22T05:58:55",
  "date_gmt": "2026-09-22T05:58:55",
  "guid": {
    "rendered": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample.png",
    "raw": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample.png"
  },
  "modified": "2026-09-22T05:58:55",
  "modified_gmt": "2026-09-22T05:58:55",
  "slug": "e2m-rest-lab-sample",
  "status": "inherit",
  "type": "attachment",
  "link": "http://task-7.local/e2m-rest-lab-sample/",
  "title": {
    "raw": "e2m-rest-lab-sample",
    "rendered": "e2m-rest-lab-sample"
  },
  "author": 1,
  "featured_media": 0,
  "comment_status": "open",
  "ping_status": "closed",
  "template": "",
  "meta": {
    "_acf_changed": false
  },
  "permalink_template": "http://task-7.local/?attachment_id=33",
  "generated_slug": "e2m-rest-lab-sample",
  "class_list": [
    "post-33",
    "attachment",
    "type-attachment",
    "status-inherit",
    "hentry"
  ],
  "acf": [],
  "description": {
    "raw": "",
    "rendered": "<p class=\"attachment\"><a href='http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample.png'><img loading=\"lazy\" decoding=\"async\" width=\"300\" height=\"158\" src=\"http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-300x158.png\" class=\"attachment-medium size-medium\" alt=\"\" srcset=\"http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-300x158.png 300w, http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-1024x538.png 1024w, http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-768x403.png 768w, http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample.png 1200w\" sizes=\"auto, (max-width: 300px) 100vw, 300px\" /></a></p>\n"
  },
  "caption": {
    "raw": "",
    "rendered": ""
  },
  "alt_text": "",
  "media_type": "image",
  "mime_type": "image/png",
  "media_details": {
    "width": 1200,
    "height": 630,
    "file": "2026/09/e2m-rest-lab-sample.png",
    "filesize": 22238,
    "sizes": {
      "medium": {
        "file": "e2m-rest-lab-sample-300x158.png",
        "width": 300,
        "height": 158,
        "filesize": 4023,
        "mime_type": "image/png",
        "source_url": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-300x158.png"
      },
      "large": {
        "file": "e2m-rest-lab-sample-1024x538.png",
        "width": 1024,
        "height": 538,
        "filesize": 84898,
        "mime_type": "image/png",
        "source_url": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-1024x538.png"
      },
      "thumbnail": {
        "file": "e2m-rest-lab-sample-150x150.png",
        "width": 150,
        "height": 150,
        "filesize": 5028,
        "mime_type": "image/png",
        "source_url": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-150x150.png"
      },
      "medium_large": {
        "file": "e2m-rest-lab-sample-768x403.png",
        "width": 768,
        "height": 403,
        "filesize": 46543,
        "mime_type": "image/png",
        "source_url": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample-768x403.png"
      },
      "full": {
        "file": "e2m-rest-lab-sample.png",
        "width": 1200,
        "height": 630,
        "mime_type": "image/png",
        "source_url": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample.png"
      }
    },
    "image_meta": {
      "aperture": "0",
      "credit": "",
      "camera": "",
      "caption": "",
      "created_timestamp": "0",
      "copyright": "",
      "focal_length": "0",
      "iso": "0",
      "shutter_speed": "0",
      "title": "",
      "orientation": "0",
      "keywords": [],
      "alt": ""
    }
  },
  "post": null,
  "source_url": "http://task-7.local/wp-content/uploads/2026/09/e2m-rest-lab-sample.png",
  "missing_image_sizes": [],
  "filename": "e2m-rest-lab-sample.png",
  "filesize": 22238,
  "exif_orientation": 1,
  "image_output_format": null,
  "image_save_progressive": false,
  "image_quality": {
    "default": 82,
    "sizes": []
  },
  "_links": {
    "self": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media/33",
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
        "href": "http://task-7.local/wp-json/wp/v2/media"
      }
    ],
    "about": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/types/attachment"
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
        "href": "http://task-7.local/wp-json/wp/v2/comments?post=33"
      }
    ],
    "wp:action-unfiltered-html": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media/33"
      }
    ],
    "wp:action-assign-author": [
      {
        "href": "http://task-7.local/wp-json/wp/v2/media/33"
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
