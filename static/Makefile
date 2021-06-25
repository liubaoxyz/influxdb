# List any directories that have their own Makefile here
SUBDIRS =

# Default target
all: $(SUBDIRS) data/build data/swagger.json

# Recurse into subdirs for same make goal
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)

# Clean all targets recursively
clean: $(SUBDIRS)
	rm data/swagger.json
	rm -r data/build

# Target for the built UI assets directory.
data/build:
	../scripts/fetch-ui-assets.sh

# Target for the swagger.json from the openapi repo
data/swagger.json:
	OPENAPI_SHA=c87a08f832e79bc338a37509028641cda9e1875b ../scripts/fetch-swagger.sh

GO_RUN := env GO111MODULE=on go run

.PHONY: all clean $(SUBDIRS)
