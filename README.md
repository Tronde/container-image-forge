# container-image-forge
This is a place where [OCI](https://de.wikipedia.org/wiki/Open_Container_Initiative) container images are forged for fun and learning opportunities.

In this repository you will find the Bash scripts that I use to build OCI compatible container images. The scripts contain the `buildah` commands that I use to create and customize the resulting images.

If you stumbled upon this repository by accident and would like to learn more on the topic, or just want to know why I use `buildah` instead of `podman build` or the Docker CLI, see the following links for starters:

  * [https://podman.io/](https://podman.io/)
  * [https://buildah.io/](https://buildah.io/)
  * [Buildah and Podman Relationship](https://podman.io/blogs/2018/10/31/podman-buildah-relationship.html)

To me `buildah` seems to be the right tool to use when you are going to create container images. And as I need some customized images for work and weekend project the time seems due to learn how to use it.

In case you spot any issues in my scripts or see something that could be improved, please let me know using the issue tracker of this repo or send a Pull Request.
