# External_orocos_kdl.cmake
# Builds Orocos KDL from source and installs it into CMAKE_INSTALL_PREFIX

include(ExternalProject)

message(STATUS "[minimal_ros2] Layer: orocos_kdl (Orocos Kinematics and Dynamics Library)")

set(EXTRA_OROCOS_ARGS "")
if(APPLE)
  if(EXISTS "/opt/homebrew")
    list(APPEND EXTRA_OROCOS_ARGS "-DCMAKE_PREFIX_PATH=/opt/homebrew")
  elseif(EXISTS "/usr/local")
    list(APPEND EXTRA_OROCOS_ARGS "-DCMAKE_PREFIX_PATH=/usr/local")
  endif()
endif()

if(DEFINED CMAKE_TOOLCHAIN_FILE)
  list(APPEND EXTRA_OROCOS_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
endif()

if(DEFINED CMAKE_C_COMPILER)
  list(APPEND EXTRA_OROCOS_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
endif()

if(DEFINED CMAKE_CXX_COMPILER)
  list(APPEND EXTRA_OROCOS_ARGS "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
endif()

set(OROCOS_KDL_SRC "${CMAKE_SOURCE_DIR}/src/orocos/orocos_kinematics_dynamics/orocos_kdl")

if(EXISTS "${OROCOS_KDL_SRC}/CMakeLists.txt")
  set(OROCOS_KDL_SOURCE_ARGS SOURCE_DIR "${OROCOS_KDL_SRC}")
else()
  set(OROCOS_KDL_SOURCE_ARGS
    GIT_REPOSITORY https://github.com/orocos/orocos_kinematics_dynamics.git
    GIT_TAG 1.5.4
    SOURCE_SUBDIR orocos_kdl
  )
endif()

include(ProcessorCount)
ProcessorCount(NCORES)
if(NCORES EQUAL 0)
  set(NCORES 4)
endif()

ExternalProject_Add(orocos_kdl
  ${OROCOS_KDL_SOURCE_ARGS}
  PREFIX "${CMAKE_BINARY_DIR}/orocos_kdl-prefix"
  BINARY_DIR "${CMAKE_BINARY_DIR}/orocos_kdl-build"
  INSTALL_DIR "${CMAKE_INSTALL_PREFIX}"
  BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --parallel ${NCORES}
  CMAKE_ARGS
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DCMAKE_CXX_STANDARD=17
    -DCMAKE_CXX_STANDARD_REQUIRED=ON
    -DENABLE_TESTS=OFF
    ${EXTRA_OROCOS_ARGS}
)
