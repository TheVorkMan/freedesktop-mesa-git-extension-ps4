kind: meson
description: libdrm

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst

depends:
- freedesktop-sdk.bst:public-stacks/runtime-minimal.bst
- freedesktop-sdk.bst:components/xorg-lib-pciaccess.bst
- freedesktop-sdk.bst:components/libdrm.bst

(@):
- freedesktop-sdk.bst:elements/extensions/mesa/config.yml

variables:
  meson-local: >-
    -Detnaviv=enabled
    -Dtegra=enabled
    -Dcairo-tests=disabled
    -Dvalgrind=disabled
    -Dman-pages=disabled
    -Dudev=false

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libdrm_*.so'

sources:
- kind: git_repo
  url: freedesktop:mesa/drm.git
  track: libdrm-*
  ref: libdrm-2.4.128-0-g679c4749740eb84dd9f07933291dddf19bdcfcda
