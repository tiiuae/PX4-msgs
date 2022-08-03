#!/bin/bash

set -euxo pipefail

output_dir=$1
git_commit_hash=${2:-$(git rev-parse --short HEAD)}
build_number=${GITHUB_RUN_NUMBER:=0}

docker build \
    --build-arg BUILD_NUMBER=${build_number} \
    -t "ghcr.io/tiiuae/tii-px4-msgs:sha-${git_commit_hash}" .

container_id=$(docker create ghcr.io/tiiuae/tii-px4-msgs:sha-${git_commit_hash})
docker cp ${container_id}:/output_dir/. ${output_dir}
docker rm -v ${container_id}

exit 0
