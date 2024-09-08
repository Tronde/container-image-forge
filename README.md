# container-image-forge
This is a place where [OCI](https://de.wikipedia.org/wiki/Open_Container_Initiative) container images are forged for fun and learning opportunities.

In this repository you will find the Bash scripts that I use to build OCI compatible container images. The scripts contain the `buildah` commands that I use to create and customize the resulting images.

If you stumbled upon this repository by accident and would like to learn more on the topic, or just want to know why I use `buildah` instead of `podman build` or the Docker CLI, see the following links for starters:

  * [https://podman.io/](https://podman.io/)
  * [https://buildah.io/](https://buildah.io/)
  * [Buildah and Podman Relationship](https://podman.io/blogs/2018/10/31/podman-buildah-relationship.html)

To me `buildah` seems to be the right tool to use when you are going to create container images. And as I need some customized images for work and weekend project the time seems due to learn how to use it.

In case you spot any issues in my scripts or see something that could be improved, please let me know using the issue tracker of this repo or send a Pull Request.

## Container build scripts within this repository

The script `buildah_create_debian_bookworm_with_rootless_podman.sh`:

  * Uses `docker.io/library/debian:bookworm` as a base image
  * Creates an image including a rootless podman installation
    * With name `debian_bookworm_podman`
    * With tags `latest`and `$(date --iso)` (e.g. `debian_bookworm_podman:2024-09-08`)

The resulting image can be run in a rootless podman command with the following command:

```
]$ podman run --rm --user podman --security-opt label=disable --device /dev/fuse --cap-add=setuid,setgid,sys_admin,chown localhost/debian_bookworm_podman:latest podman info
host:
…
security:
    apparmorEnabled: false
    capabilities: CAP_CHOWN,CAP_DAC_OVERRIDE,CAP_FOWNER,CAP_FSETID,CAP_KILL,CAP_NET_BIND_SERVICE,CAP_SETFCAP,CAP_SETGID,CAP_SETPCAP,CAP_SETUID,CAP_SYS_CHROOT
    rootless: true
    seccompEnabled: true
    seccompProfilePath: /usr/share/containers/seccomp.json
    selinuxEnabled: false
…
```
