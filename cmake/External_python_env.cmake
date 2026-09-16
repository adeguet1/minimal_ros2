# External_python_env.cmake
# Prepares the Python build environment for ROS 2 code generation

find_package(Python3 COMPONENTS Interpreter REQUIRED)
message(STATUS "[minimal_ros2] Base Python: ${Python3_EXECUTABLE} (version ${Python3_VERSION})")

set(MINIMAL_ROS2_VENV_DIR "${CMAKE_SOURCE_DIR}/.venv" CACHE PATH "Path to Python virtual environment")

if(WIN32)
  set(VENV_PYTHON "${MINIMAL_ROS2_VENV_DIR}/Scripts/python.exe")
  set(VENV_COLCON "${MINIMAL_ROS2_VENV_DIR}/Scripts/colcon.exe")
  set(VENV_BIN_DIR "${MINIMAL_ROS2_VENV_DIR}/Scripts")
else()
  set(VENV_PYTHON "${MINIMAL_ROS2_VENV_DIR}/bin/python3")
  set(VENV_COLCON "${MINIMAL_ROS2_VENV_DIR}/bin/colcon")
  set(VENV_BIN_DIR "${MINIMAL_ROS2_VENV_DIR}/bin")
endif()

if(EXISTS "${VENV_COLCON}")
  add_custom_target(python_build_env
    COMMENT "Python build environment already present in ${MINIMAL_ROS2_VENV_DIR}"
  )
else()
  add_custom_target(python_build_env
    COMMAND "${Python3_EXECUTABLE}" -m venv "${MINIMAL_ROS2_VENV_DIR}"
    COMMAND "${VENV_PYTHON}" -m pip install --upgrade pip
    COMMAND "${VENV_PYTHON}" -m pip install colcon-common-extensions "empy==3.3.4" lark catkin_pkg pyyaml numpy pybind11 setuptools vcstool
    WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}"
    VERBATIM
    COMMENT "Creating Python build environment in ${MINIMAL_ROS2_VENV_DIR}..."
  )
endif()

set(BUILD_PYTHON_EXECUTABLE "${VENV_PYTHON}" CACHE FILEPATH "Python executable for code generation" FORCE)
set(BUILD_COLCON_EXECUTABLE "${VENV_COLCON}" CACHE FILEPATH "Colcon executable for minimal_ros2 build" FORCE)
set(BUILD_VENV_BIN_DIR "${VENV_BIN_DIR}" CACHE PATH "Directory containing virtual environment executables" FORCE)
