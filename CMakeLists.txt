cmake_minimum_required(VERSION 3.20)

project(minimal_ros2
  VERSION 1.0.0
  LANGUAGES C CXX
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

# Default build type to Release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build" FORCE)
endif()

# Find Python 3 Interpreter first
find_package(Python3 COMPONENTS Interpreter REQUIRED)

# Options
option(FETCH_SOURCES "Fetch repositories defined in repos/minimal_ros2.repos" ON)
option(BUILD_TESTING "Build ROS 2 test fixtures" OFF)
set(ROS2_DDS "cyclonedds" CACHE STRING "DDS middleware implementation (cyclonedds or fastdds)")

# Default install prefix to ${CMAKE_CURRENT_SOURCE_DIR}/install if not specified
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT OR NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/install" CACHE PATH "Install path prefix" FORCE)
endif()

message(STATUS "==========================================================")
message(STATUS " minimal_ros2 Superbuild")
message(STATUS " Build type:     ${CMAKE_BUILD_TYPE}")
message(STATUS " Install prefix: ${CMAKE_INSTALL_PREFIX}")
message(STATUS " DDS Middleware: ${ROS2_DDS}")
message(STATUS " Base Python:    ${Python3_EXECUTABLE} (${Python3_VERSION})")
message(STATUS "==========================================================")

# 1. Fetch sources if requested
if(FETCH_SOURCES AND NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/src/ros2/rclcpp/package.xml")
  message(STATUS "[minimal_ros2] Fetching source repositories using ${Python3_EXECUTABLE}...")
  execute_process(
    COMMAND "${Python3_EXECUTABLE}" "${CMAKE_CURRENT_SOURCE_DIR}/scripts/fetch_sources.py"
      --repos-file "${CMAKE_CURRENT_SOURCE_DIR}/repos/minimal_ros2.repos"
      --src-dir "${CMAKE_CURRENT_SOURCE_DIR}/src"
    RESULT_VARIABLE _fetch_res
    ECHO_OUTPUT_VARIABLE
    ECHO_ERROR_VARIABLE
  )
  if(NOT _fetch_res EQUAL 0)
    message(FATAL_ERROR "Failed to fetch repositories (exit code ${_fetch_res}). Check network and git configuration.")
  endif()
endif()

# 2. Setup Python build environment (colcon, empy, lark, etc.)
include(External_python_env)

# 3. Modular layers
include(External_rcutils)
include(External_rclcpp)

if(ROS2_DDS STREQUAL "cyclonedds")
  include(External_cyclonedds)
elseif(ROS2_DDS STREQUAL "fastdds")
  include(External_fastrtps)
endif()

include(External_orocos_kdl)

# 4. Compile underlay packages
include(External_ros2_underlay)

# 5. Generate environment files (setup.sh, setup.bat, setup.ps1, SlicerLauncherSettings.ini)
add_custom_target(generate_env ALL
  COMMAND "${Python3_EXECUTABLE}" "${CMAKE_CURRENT_SOURCE_DIR}/scripts/setup_env.py"
    --install-dir "${CMAKE_INSTALL_PREFIX}"
  DEPENDS ros2_underlay
  COMMENT "Generating environment scripts and Slicer launcher config..."
)

# 6. Export CMake Package Config (find_package(minimal_ros2 REQUIRED))
include(CMakePackageConfigHelpers)

configure_package_config_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/minimal_ros2-config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config.cmake"
  INSTALL_DESTINATION "lib/cmake/minimal_ros2"
  PATH_VARS CMAKE_INSTALL_PREFIX
)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config-version.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config-version.cmake"
  DESTINATION "lib/cmake/minimal_ros2"
)

# Also install into share/minimal_ros2/cmake for standard ROS2 prefix convention
install(
  FILES
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config-version.cmake"
  DESTINATION "share/minimal_ros2/cmake"
)

add_custom_target(minimal_ros2_config ALL
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config.cmake"
    "${CMAKE_INSTALL_PREFIX}/lib/cmake/minimal_ros2/minimal_ros2-config.cmake"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config-version.cmake"
    "${CMAKE_INSTALL_PREFIX}/lib/cmake/minimal_ros2/minimal_ros2-config-version.cmake"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config.cmake"
    "${CMAKE_INSTALL_PREFIX}/share/minimal_ros2/cmake/minimal_ros2-config.cmake"
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
    "${CMAKE_CURRENT_BINARY_DIR}/minimal_ros2-config-version.cmake"
    "${CMAKE_INSTALL_PREFIX}/share/minimal_ros2/cmake/minimal_ros2-config-version.cmake"
  DEPENDS ros2_underlay
  COMMENT "Exporting minimal_ros2 CMake package configuration..."
)
