#!/bin/bash

set -euxo pipefail

output_dir=$1

git_commit_hash=${2:-$(git rev-parse HEAD)}

git_version_string=${3:-$(git log --date=format:%Y%m%d --pretty=~git%cd.%h -n 1)}

build_number=${GITHUB_RUN_NUMBER:=0}

ros_distro=${ROS_DISTRO:=humble}

iname=${PACKAGE_NAME:=px4-msgs}

iversion=${PACKAGE_VERSION:=latest}

target_platforms=${PLATFORMS:=linux/amd64,linux/arm64}

docker build \
  --build-arg UID=$(id -u) \
  --build-arg GID=$(id -g) \
  --build-arg ROS_DISTRO=${ros_distro} \
  --build-arg PACKAGE_NAME=${iname} \
  --build-arg GIT_RUN_NUMBER=${build_number} \
  --build-arg GIT_COMMIT_HASH=${git_commit_hash} \
  --build-arg GIT_VERSION_STRING=${git_version_string} \
  --build-arg TARGET_ARCHITECTURE=amd64 \
  --platform=${target_platforms} \
  --progress=plain \
  --output=type=registry \
  --pull \
  -f Dockerfile -t "localhost:5000/${iname}-build:${iversion}" .

mkdir -p ${output_dir}

IFS=',' read -ra platforms <<< "$target_platforms"
for platform in "${platforms[@]}"; do
  docker create -ti --name ${iname}-build-temp-${platform//\//-} localhost:5000/${iname}-build:latest bash
  docker cp ${iname}-build-temp-${platform//\//-}:/output_dir/. ${output_dir}
  docker rm -f ${iname}-build-temp-${platform//\//-}
done


echo "Build completed successfully. Extracted deb package name $(ls ${output_dir}/*.deb)"

exit 0
