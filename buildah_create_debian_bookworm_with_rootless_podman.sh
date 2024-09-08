#!/usr/bin/bash
# Name: buildah_create_debian_bookworm_with_rootless_podman.sh
# Description:
# Build an OCI compliant container image serving rootless podman on
# Debian 12 (Bookworm)
#
# CAUTION: This is highly experimental and might breack your system!
#          Use at your own risk!
#
# Author: Joerg Kastning
# License: GPLv3-or-later

# set -x
set -euo pipefail

if ! buildah -v &> /dev/null
then
  echo "The command buildah could not be found"
  exit 1
fi

# Name to target container image
tctri=debian_bookworm_podman

# Get a base image
ctr=$(buildah from docker://docker.io/library/debian:bookworm)

buildah run -- $ctr apt -y update
buildah run -- $ctr apt -y upgrade
buildah run -- $ctr apt -y install podman fuse-overlayfs libvshadow-utils libcap2-bin ca-certificates
#buildah run -- $ctr apt -y clean
#buildah run -- $ctr rm -rf /var/lib/apt/lists/*

buildah run -- $ctr useradd podman
buildah run -- $ctr sh -c "echo podman:1:999 > /etc/subuid"
buildah run -- $ctr sh -c "echo podman:1001:64535 >> /etc/subuid"
buildah run -- $ctr sh -c "echo podman:1:999 > /etc/subgid"
buildah run -- $ctr sh -c "echo podman:1001:64535 >> /etc/subgid"
buildah run -- $ctr setcap cap_setuid+epi /usr/bin/newuidmap
buildah run -- $ctr setcap cap_setgid+epi /usr/bin/newgidmap
 
buildah config -v /var/lib/containers $ctr
buildah config -v /home/podman/.local/share/containers $ctr
buildah run -- $ctr chown -R podman:podman /home/podman
buildah run -- $ctr sh -c "mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock"
buildah config --env _CONTAINERS_USERNS_CONFIGURED="" $ctr
buildah run -- $ctr apt -y reinstall uidmap
 
# Commit to an image
buildah commit --rm $ctr $tctri
# Alternative: Use this and add GPG fingerprint for image signing
# buildah commit --sign-by <fingerprint> --rm $ctr $tctri

# Tag the image just created
buildah tag $tctri $tctri:$(date --iso)
