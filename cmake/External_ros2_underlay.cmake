# External_ros2_underlay.cmake
# Orchestrates the topological build of all ROS 2 packages into CMAKE_INSTALL_PREFIX

find_package(Python3 COMPONENTS Interpreter REQUIRED)

set(UNDERLAY_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")
if(APPLE)
  if(EXISTS "/opt/homebrew")
    list(APPEND UNDERLAY_PREFIX_PATH "/opt/homebrew")
  elseif(EXISTS "/usr/local")
    list(APPEND UNDERLAY_PREFIX_PATH "/usr/local")
  endif()
endif()

file(GLOB _PYBIND11_PREFIXES
  "${MINIMAL_ROS2_VENV_DIR}/lib/python*/site-packages/pybind11"
  "${MINIMAL_ROS2_VENV_DIR}/Lib/site-packages/pybind11"
)
foreach(_p ${_PYBIND11_PREFIXES})
  list(APPEND UNDERLAY_PREFIX_PATH "${_p}")
endforeach()

string(REPLACE ";" "\\;" UNDERLAY_PREFIX_ESCAPED "${UNDERLAY_PREFIX_PATH}")
set(EXTRA_CMAKE_ARGS "-DCMAKE_PREFIX_PATH=${UNDERLAY_PREFIX_ESCAPED}")

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
)

include(ProcessorCount)
ProcessorCount(NCORES)
if(NCORES EQUAL 0)
  set(NCORES 4)
endif()

add_custom_target(ros2_underlay ALL
  COMMAND "${BUILD_COLCON_EXECUTABLE}" build
    --base-paths "${CMAKE_SOURCE_DIR}/src"
    --merge-install
    --install-base "${CMAKE_INSTALL_PREFIX}"
    --parallel-workers ${NCORES}
    --packages-ignore ${PACKAGES_TO_IGNORE}
    --cmake-args
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      -DPython3_EXECUTABLE=${BUILD_PYTHON_EXECUTABLE}
      -DBUILD_TESTING=OFF
      -DCMAKE_BUILD_PARALLEL_LEVEL=${NCORES}
      ${EXTRA_CMAKE_ARGS}
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  DEPENDS python_build_env orocos_kdl
  VERBATIM
  COMMENT "Compiling minimal ROS 2 packages into ${CMAKE_INSTALL_PREFIX}..."
)
