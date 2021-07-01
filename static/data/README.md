# Embedded Assets Data Directory

This directory is populated with static assets for serving via HTTP as part of
the build process.

If the binary is compiled without populating this directory with additional
assets (such as by building `influxd` directly, rather than using the
`Makefile`), this directory will be empty other than this `README.md`. This
directory is still required to be present & not totally empty even in the case
of building the binary without assets; otherwise there will be a compile error
due to the way that the `go:embed` directive works with empty and/or missing
paths.

When building the binary with assets via the `Makefile`, the following
directories and files will be present here:
- `build/`: This directory contains the static UI assets, downloaded from the
  `influxdata/ui` repository.
- `swagger.json`: This file represents the API specification for the `influxd`
  HTTP server. It is downloaded from the `influxdata/openapi` repository, and
  can be accessed via the `api/v2/swagger.json` route, and is also used when
  accessing the `/docs` endpoint.