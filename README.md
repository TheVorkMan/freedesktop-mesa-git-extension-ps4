# mesa-git-extension

## Development
### Installing dependencies
If you want to test your changes locally, then you will need to first install [BuildStream](https://buildstream.build). The installation instructions can be found [here](https://buildstream.build/install.html). Note that we use the latest version of BuildStream, so ensure you use this version too (otherwise you may not hit our cache server, and have to build everything from scratch). At the time of writing, we use a pre-release snapshot of BuildStream 2.

> **Note**: Since the change to BuildStream 2 we don't require bst-external anymore.

You will also need to have ostree, make, and the usual assortment of development tools installed.

### Building

```shell
# Clone this git repository
git clone https://gitlab.com/freedesktop-sdk/mesa-git-extension.git
cd mesa-git-extension

# Checkout the branch of the version you want to build (23.08 in this example)
git checkout release/23.08

# Build Flatpak runtimes for x86_64 and i686 architectures
make export-repo ARCH=x86_64 REPO=repo
make export-repo ARCH=i686 REPO=repo
```

### Installing

```shell
# To install a local version, you must first uninstall any previously installed version
flatpak uninstall org.freedesktop.Platform.GL.mesa-git org.freedesktop.Platform.GL32.mesa-git

# Install for both the x86_64 and i686 architectures
flatpak install ./repo org.freedesktop.Platform.GL.mesa-git
flatpak install ./repo org.freedesktop.Platform.GL32.mesa-git
```

### Publishing
This extension is published only ever published Flathub beta
Token expected prefixes are `['org.freedesktop.Platform.GL', 'org.freedesktop.Platform.GL32']` and repos `['beta']`.

If token has expired, submit a ticket into https://github.com/flathub/flathub/ to renew.

## Usage
To use the mesa-git extension, you must set the environment variable `FLATPAK_GL_DRIVERS=mesa-git` before running a Flatpak app. See more details in the [Wiki page](https://gitlab.com/freedesktop-sdk/freedesktop-sdk/-/wikis/mesa-git).

```shell
FLATPAK_GL_DRIVERS=mesa-git flatpak run APP_ID
```

## Hacking
If you need to build this extension from some other commit or repo, feel free to locally edit elements/mesa.bst sources section
which looks something like
```
sources:
- kind: git_repo
  url: freedesktop:mesa/mesa.git
  track: main
  ref-format: git-describe
  ref: 23.3-branchpoint-567-g054188bff821f490b157dc0a4740d72793b97212
- kind: local
  path: files/mesa/appdata.template
```
ref can be replaced by git commit id manually. You can also use
[patch source](https://buildstream.gitlab.io/buildstream/sources/patch.html)
to apply local patches. Same file also allows you to arbitrarily modify Meson options for built Mesa.