
images are build time constructs, where containers are run time constructs. 
we can build an image from a container.

docker run is the cli command to start a container. once built the docker and the image are bound. to delete an image, we need to stop and delete all containers that use it.

images should only contain application code dependencies, and minimal operating system to run it.
there is also no OS kernel, containers uses the host the run on

pulling images
running docker images shows us what images we have on our local repo
if we would like to pull an image we can use
docker pull redis ---- for example
now it will exists on our local repo

this pulling made two assumptions, pulling the latest, and pull from docker hub
we can override both
if we already have a local copy of a required layer, docker will use that instead of re downloading from hub, some images share common layers. 

image registries
we store images in centralized places called registries. Most of the popular applications and operating systems have official repositories on Docker Hub

![[Pasted image 20260911154030.png]]

$ docker pull <repository>:<tag> - > $ docker pull redis:latest -> 
$ docker pull alpine
//Pulls the image tagged as 'latest' from the official 'alpine'

To pull an image from a different registry, you just add the registry’s DNS
name before the repository name

docker images to view images, and docker rmi to remove images

docker scout for viewing vulnerabilitys

Images – The commands
docker pull is the command to download images from remote
registries. It defaults to Docker Hub but works with other registries. The
following command will pull the image tagged as latest from the
alpine repository on Docker Hub: docker pull
alpine:latest .
docker images lists all the images in your Docker host’s local
repository (image cache). You can add the --digests flag to see the
SHA256 hashes.
docker inspect gives you a wealth of image-related metadata in a
nicely formatted view.
docker manifest inspect lets you inspect the manifest list of
images stored in registries. The following command will show the
manifest list for the regctl image on GitHub Container Registry
(GHCR): docker manifest inspect
ghcr.io/regclient/regctl .
docker buildx is a Docker CLI plugin that works with Docker’s
latest build engine features. You saw how to use the imagetools
sub-command to query manifest-related data from images.docker scout is a Docker CLI plugin that integrates with the
Docker Scout backend to perform image vulnerability scanning. It scans
images, provides reports on vulnerabilities, and even suggests
remediation actions.
docker rmi is the command to delete images. It deletes all layer
data stored in the local filesystem, and you cannot delete images that are
in use by containers.