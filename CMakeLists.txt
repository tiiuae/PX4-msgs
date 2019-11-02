cmake_minimum_required(VERSION 3.5)

project(px4_msgs)

list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(EnableC++XX)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra)
endif()

find_package(ament_cmake REQUIRED)
find_package(builtin_interfaces REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(rosidl_generator_dds_idl REQUIRED)

# find ROS distro
set(ROS_DISTRO)
if(DEFINED ENV{ROS2_DISTRO})
  set(ROS_DISTRO $ENV{ROS2_DISTRO})
else()
  set(ROS_DISTRO $ENV{ROS_DISTRO})
endif()

# ##############################################################################
# Generate ROS messages, ROS2 interfaces and IDL files #
# ##############################################################################

# get all msg files
set(MSGS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/msg")
file(GLOB PX4_MSGS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${MSGS_DIR}/*.msg")

file(GLOB ROS_MSG_DIR_LIST "${MSGS_DIR}/*.msg")

set(TUPLES_LIST)
foreach(file ${ROS_MSG_DIR_LIST})
  get_filename_component(DIR "${file}" DIRECTORY)
  get_filename_component(PARENT_DIR "${DIR}" DIRECTORY)
  get_filename_component(FILE_NAME ${file} NAME)
  list(APPEND TUPLES_LIST "${PARENT_DIR}:msg/${FILE_NAME}")
endforeach()

if(NOT "${PX4_MSGS}" STREQUAL "")
  # Generate introspection typesupport for C and C++ and IDL files
  rosidl_generate_interfaces(${PROJECT_NAME}
                             ${PX4_MSGS}
                             DEPENDENCIES
                             builtin_interfaces
                             ADD_LINTER_TESTS)

    # Generate Fast RTPS IDL files (previous to Dashing, so to make the IDL
    # compatible with the upstream PX4 IDL generator)
    rosidl_generate_dds_interfaces(${PROJECT_NAME}__fastrtps_idl
                                   IDL_TUPLES
                                   ${TUPLES_LIST}
                                   OUTPUT_SUBFOLDERS
                                   "dds_fastrtps")
    # rosidl_generator_dds_idl requires a target to generate the IDL files
    # as we don't have one, we create a dummy target to serve the purpose
    file(WRITE ${MSGS_DIR}/idl.cc "int main() { return 0; }")
    add_executable(idl_target ${MSGS_DIR}/idl.cc)
    add_dependencies(idl_target ${PROJECT_NAME}__fastrtps_idl)
else()
  message(FATAL_ERROR "No PX4 msgs found to generate interfaces to!")
endif()

ament_export_dependencies(rosidl_default_runtime)

ament_package()
