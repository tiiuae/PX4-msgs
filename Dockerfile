FROM ros:humble-ros-base as builder

ARG GIT_RUN_NUMBER
ARG GIT_COMMIT_HASH
ARG GIT_VERSION_STRING

RUN echo $GIT_RUN_NUMBER
RUN echo $GIT_COMMIT_HASH
RUN echo $GIT_VERSION_STRING
ARG BUILD_NUMBER=0
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    curl \
    python3-bloom \
    dh-make \
    libboost-dev

COPY . /main_ws/src/

# this:
# 1) builds the application
# 2) packages the application as .deb in /main_ws/
WORKDIR /main_ws/src
RUN /main_ws/src/package.sh -b $GIT_RUN_NUMBER -g $GIT_COMMIT_HASH -v $GIT_VERSION_STRING

RUN mkdir -p /output_dir && cp /main_ws/*.deb /output_dir/

FROM alpine:edge
COPY --from=builder /output_dir/*.deb /artifacts/
CMD ["sh"]
