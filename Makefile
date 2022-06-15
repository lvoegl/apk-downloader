DOWNLOADS_DIR := downloads
DOWNLOADER_DIR := downloader
PATCHES_DIR := patches
DIST_DIR := dist
GPLAYAPI_REPO := https://gitlab.com/AuroraOSS/gplayapi.git

build:
ifeq (, $(shell which unzip))
	$(error "unzip" command is required for building)
endif

	$(MAKE) clean

	git clone $(GPLAYAPI_REPO) $(DOWNLOADER_DIR)
	git apply --directory=$(DOWNLOADER_DIR) $(PATCHES_DIR)/*.patch

	cd $(DOWNLOADER_DIR) && sh gradlew :assemble
	unzip -q $$(ls $(DOWNLOADER_DIR)/build/distributions/*.zip | head -1) -d $(DIST_DIR)
	mv $(DIST_DIR)/$$(ls $(DIST_DIR)/ | head -1)/* $(DIST_DIR)

clean:
	rm -rf $(DOWNLOADER_DIR)
	rm -rf $(DIST_DIR)

download:
	rm -rf $(DOWNLOADS_DIR)/$(app) $(DOWNLOADS_DIR)/$(app).zip
	sh $(DIST_DIR)/bin/gplayapi $(app) $(shell pwd)/downloads
	cd $(DOWNLOADS_DIR)/$(app) && zip -rm $(app).zip ./*
	mv $(DOWNLOADS_DIR)/$(app)/$(app).zip $(DOWNLOADS_DIR)
	rm -r $(DOWNLOADS_DIR)/$(app)
