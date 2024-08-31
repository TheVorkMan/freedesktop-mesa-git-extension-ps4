SHELL=/bin/bash
ARCH?=$(shell uname -m | sed "s/^i.86$$/i686/" | sed "s/^ppc/powerpc/")
BOOTSTRAP_ARCH?=$(shell uname -m | sed "s/^i.86$$/i686/")
REPO?=repo
ARCH_OPTS=-o target_arch $(ARCH) -o bootstrap_arch ${BOOTSTRAP_ARCH}
BST=bst $(ARCH_OPTS)
CHECKOUT_ROOT=runtimes
GIT_DESCRIBE := $(shell git rev-parse HEAD)

build: elements
	$(BST) build flatpak-repo.bst

clean-repo:
	rm -rf $(REPO)

export-repo: build
	mkdir -p $(CHECKOUT_ROOT)
	$(BST) artifact checkout flatpak-repo.bst --directory $(CHECKOUT_ROOT)/flatpak-repo.bst
	test -e $(REPO) || ostree init --repo=$(REPO) --mode=archive
	flatpak build-commit-from --src-repo=$(CHECKOUT_ROOT)/flatpak-repo.bst --subject $(GIT_DESCRIBE) $(REPO)
	rm -rf $(CHECKOUT_ROOT)/flatpak-repo.bst

.PHONY: build clean-repo export
