#!/bin/bash

set -euxo pipefail

output_dir=$1
build_number=${GITHUB_RUN_NUMBER:=0}

docker build \
    --build-arg BUILD_NUMBER=${build_number} \
    --output type=docker \
    -t "tii-px4-msgs:px4-msgs" .

container_id=$(docker create tii-px4-msgs:px4-msgs)
docker cp ${container_id}:/output_dir/. ${output_dir}
docker rm -v ${container_id}

exit 0
