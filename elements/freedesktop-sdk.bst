kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: master
  ref: 24.08-branchpoint-2086-g0d153f02040f1aa4b1d36be6cd005d67f7f91ace
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
