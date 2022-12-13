FROM ghcr.io/tiiuae/fog-ros-baseimage:builder-ae21266

ARG BUILD_NUMBER=0

COPY . /main_ws/src/

# this:
# 1) builds the application
# 2) packages the application as .deb in /main_ws/

RUN /packaging/build.sh -b ${BUILD_NUMBER}

RUN mkdir -p /output_dir
RUN cp /main_ws/ros-*-px4-msgs_*_amd64.deb /output_dir/
