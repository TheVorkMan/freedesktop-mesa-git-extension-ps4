kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: master
  ref: freedesktop-sdk-25.08beta.1-69-gc27ced8d2765babbfb820b6cf3ce73512e88868d
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
