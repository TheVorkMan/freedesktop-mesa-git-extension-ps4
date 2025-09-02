kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: freedesktop-sdk-25.08*
  ref: freedesktop-sdk-25.08.0-0-g04d50e865e92fcc115136b0bc882c17a3d36a1dd
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
