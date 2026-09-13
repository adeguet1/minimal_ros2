# External_ros2_underlay.cmake
# Orchestrates the topological build of all ROS 2 packages into CMAKE_INSTALL_PREFIX

find_package(Python3 COMPONENTS Interpreter REQUIRED)

# Homebrew detection on macOS
set(EXTRA_CMAKE_ARGS "")
if(APPLE)
  if(EXISTS "/opt/homebrew")
    list(APPEND EXTRA_CMAKE_ARGS "-DCMAKE_PREFIX_PATH=/opt/homebrew")
  elseif(EXISTS "/usr/local")
    list(APPEND EXTRA_CMAKE_ARGS "-DCMAKE_PREFIX_PATH=/usr/local")
  endif()
endif()

# Packages ignored (test fixtures and optional plugins)
set(PACKAGES_TO_IGNORE
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
)

add_custom_target(ros2_underlay ALL
  COMMAND "${BUILD_COLCON_EXECUTABLE}" build
    --base-paths "${CMAKE_SOURCE_DIR}/src"
    --merge-install
    --install-base "${CMAKE_INSTALL_PREFIX}"
    --packages-ignore ${PACKAGES_TO_IGNORE}
    --cmake-args
      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
      -DPython3_EXECUTABLE=${BUILD_PYTHON_EXECUTABLE}
      -DBUILD_TESTING=OFF
      ${EXTRA_CMAKE_ARGS}
  WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
  DEPENDS python_build_env
  COMMENT "Compiling minimal ROS 2 packages into ${CMAKE_INSTALL_PREFIX}..."
)
