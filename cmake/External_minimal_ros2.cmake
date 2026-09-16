# External_minimal_ros2.cmake
# Orchestrates the topological build of all minimal ROS 2 packages into CMAKE_INSTALL_PREFIX

find_package(Python3 COMPONENTS Interpreter REQUIRED)

set(MINIMAL_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")
if(APPLE)
  if(EXISTS "/opt/homebrew")
    list(APPEND MINIMAL_PREFIX_PATH "/opt/homebrew")
  elseif(EXISTS "/usr/local")
    list(APPEND MINIMAL_PREFIX_PATH "/usr/local")
  endif()
endif()

if(WIN32)
  list(APPEND MINIMAL_PREFIX_PATH "${MINIMAL_ROS2_VENV_DIR}/Lib/site-packages/pybind11")
else()
  list(APPEND MINIMAL_PREFIX_PATH
    "${MINIMAL_ROS2_VENV_DIR}/lib/python${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}/site-packages/pybind11"
  )
endif()

file(GLOB _PYBIND11_PREFIXES
  "${MINIMAL_ROS2_VENV_DIR}/lib/python*/site-packages/pybind11"
  "${MINIMAL_ROS2_VENV_DIR}/Lib/site-packages/pybind11"
)
foreach(_p ${_PYBIND11_PREFIXES})
  list(APPEND MINIMAL_PREFIX_PATH "${_p}")
endforeach()
list(REMOVE_DUPLICATES MINIMAL_PREFIX_PATH)

string(REPLACE ";" "\\;" MINIMAL_PREFIX_ESCAPED "${MINIMAL_PREFIX_PATH}")
set(EXTRA_CMAKE_ARGS "-DCMAKE_PREFIX_PATH=${MINIMAL_PREFIX_ESCAPED}")
if(CMAKE_TOOLCHAIN_FILE)
  list(APPEND EXTRA_CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
endif()

set(COLCON_ENV_CMD ${CMAKE_COMMAND} -E env "PATH=${BUILD_VENV_BIN_DIR}:$ENV{PATH}")
if(WIN32)
  if(DEFINED ENV{VisualStudioVersion})
    set(_vs_ver "$ENV{VisualStudioVersion}")
  elseif(CMAKE_GENERATOR MATCHES "Visual Studio 18")
    set(_vs_ver "18.0")
  elseif(CMAKE_GENERATOR MATCHES "Visual Studio 17")
    set(_vs_ver "17.0")
  elseif(CMAKE_GENERATOR MATCHES "Visual Studio 16")
    set(_vs_ver "16.0")
  elseif(MSVC_VERSION GREATER_EQUAL 1940)
    set(_vs_ver "18.0")
  elseif(MSVC_VERSION GREATER_EQUAL 1930)
    set(_vs_ver "17.0")
  elseif(MSVC_VERSION GREATER_EQUAL 1920)
    set(_vs_ver "16.0")
  else()
    set(_vs_ver "18.0")
  endif()
  list(APPEND COLCON_ENV_CMD "VisualStudioVersion=${_vs_ver}")
endif()

# Packages ignored (test fixtures and optional plugins)
set(PACKAGES_TO_IGNORE
  orocos_kdl
  python_orocos_kdl
  tf2_bullet
  tf2_kdl
  tf2_eigen_kdl
  rosidl_buffer_backend_registry
  test_msgs
  test_rmw_implementation
  test_tf2
  rosidl_typesupport_tests
  rosidl_typesupport_introspection_tests
  rosidl_generator_tests
  test_tracetools
  test_tracetools_launch
  test_ros2trace
  examples_tf2_py
  lttngpy
  # Ignore non-interface rosbag2 packages
  lz4_cmake_module
  mcap_vendor
  ros2bag
  rosbag2
  rosbag2_compression
  rosbag2_compression_zstd
  rosbag2_cpp
  rosbag2_examples_cpp
  rosbag2_examples_py
  rosbag2_performance_benchmarking
  rosbag2_performance_benchmarking_msgs
  rosbag2_py
  rosbag2_storage
  rosbag2_storage_default_plugins
  rosbag2_storage_mcap
  rosbag2_storage_sqlite3
  rosbag2_test_common
  rosbag2_test_msgdefs
  rosbag2_tests
  rosbag2_transport
  zstd_cmake_module
)

include(ProcessorCount)
ProcessorCount(NCORES)
if(NCORES EQUAL 0)
  set(NCORES 4)
endif()

add_custom_target(minimal_ros2_packages ALL
  COMMAND ${COLCON_ENV_CMD} "${BUILD_COLCON_EXECUTABLE}" build
    --base-paths "${CMAKE_SOURCE_DIR}/src"
    --merge-install
    --install-base "${CMAKE_INSTALL_PREFIX}"
    --parallel-workers ${NCORES}
    --packages-ignore ${PACKAGES_TO_IGNORE}
    --cmake-args
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      -DPython3_EXECUTABLE=${BUILD_PYTHON_EXECUTABLE}
      -DBUILD_TESTING=OFF
      ${EXTRA_CMAKE_ARGS}
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  DEPENDS python_build_env orocos_kdl
  VERBATIM
  COMMENT "Compiling minimal ROS 2 packages into ${CMAKE_INSTALL_PREFIX}..."
)
