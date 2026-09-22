# GET /wp/v2/pages/34?_fields=id,link,acf — read the sections back

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/wp/v2/pages/34\?_fields=id\,link\,acf
```

## Response — HTTP 200

```json
{
  "id": 34,
  "link": "http://task-7.local/built-by-the-rest-api/",
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
  }
}
```
