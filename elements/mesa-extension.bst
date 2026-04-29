kind: flatpak_image

build-depends:
- mesa.bst
- mesa-metainfo.bst

(@):
- freedesktop-sdk.bst:elements/extensions/mesa/config.yml

config:
  include:
  - runtime
  exclude:
  - debug
  - devel
  directory: "%{prefix}"
  metadata:
    Runtime:
      name: org.freedesktop.Platform.GL.mesa-git-ps4
      runtime: org.freedesktop.Platform/%{flatpak_arch}/%{branch}
      sdk: org.freedesktop.Sdk/%{flatpak_arch}/%{branch}
