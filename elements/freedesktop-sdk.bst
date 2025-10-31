kind: junction

sources:
- kind: git_repo
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: freedesktop-sdk-25.08*
  ref: freedesktop-sdk-25.08.3-0-g4a527662788a742074839b162326761eca00e3a4
- kind: patch
  path: patches/freedesktop-sdk/patch-config-to-point-to-mesa-git.patch

config:
  options:
    bootstrap_build_arch: "%{bootstrap_arch}"
    target_arch: "%{target_arch}"

  overrides:
    extensions/mesa/libdrm.bst: libdrm.bst
