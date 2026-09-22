# GET /wp-json/ — locating the project CPT route in the index

## Request

```bash
curl -u admin:<ADMIN_APP_PASSWORD> http://task-7.local/wp-json/
```

## Matching routes

The index lists every registered route. Filtered to the ones this module adds:

```
/e2m/v1                                         GET
/e2m/v1/projects/count                          GET
/wp/v2/projects                                 GET, POST
/wp/v2/projects/(?P<id>[\d]+)                   GET, POST, PUT, PATCH, DELETE
/wp/v2/projects/(?P<id>[\d]+)/autosaves         GET, POST
/wp/v2/projects/(?P<parent>[\d]+)/autosaves/(?P<id>[\d]+)GET
/wp/v2/projects/(?P<parent>[\d]+)/revisions     GET
/wp/v2/projects/(?P<parent>[\d]+)/revisions/(?P<id>[\d]+)GET, DELETE

(8 matching of 141 routes total)
```
