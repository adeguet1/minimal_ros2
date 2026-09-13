#!/usr/bin/env bash
#
# build.sh
# Builds the minimal ROS 2 underlay into a merged install layout.
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"
INSTALL_DIR="$SCRIPT_DIR/install"

# Activate virtualenv if available
if [ -f "$VENV_DIR/bin/activate" ]; then
  echo "==> Activating virtual environment: $VENV_DIR"
  source "$VENV_DIR/bin/activate"
fi

if ! command -v colcon >/dev/null 2>&1; then
  echo "ERROR: 'colcon' not found in PATH."
  echo "Please run ./setup_venv.sh or build via CMake Superbuild (cmake -B build -S .)."
  exit 1
fi

cd "$SCRIPT_DIR"

# Detect pybind11 cmake directory from Python environment
PYBIND11_CMAKE_DIR="$(python3 -c "import pybind11; print(pybind11.get_cmake_dir())" 2>/dev/null || true)"
PYBIND11_FLAG=""
if [ -n "$PYBIND11_CMAKE_DIR" ]; then
  PYBIND11_FLAG="-Dpybind11_DIR=$PYBIND11_CMAKE_DIR"
fi

# Ensure Homebrew path is known to CMake on macOS
CMAKE_PREFIX_FLAGS=""
if [ -d "/opt/homebrew" ]; then
  CMAKE_PREFIX_FLAGS="-DCMAKE_PREFIX_PATH=/opt/homebrew"
elif [ -d "/usr/local" ]; then
  CMAKE_PREFIX_FLAGS="-DCMAKE_PREFIX_PATH=/usr/local"
fi

# Ignore packages:
# - tf2_bullet, tf2_kdl, tf2_eigen_kdl: require extra third-party math libraries (Bullet, Orocos KDL)
# - rosidl_buffer_backend_registry: requires pluginlib (not part of minimal underlay)
# - test_* packages: internal ROS 2 test fixtures
IGNORE_PACKAGES=(
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

echo "==> Starting build of minimal ROS 2..."
colcon build \
  --base-paths "$SCRIPT_DIR/src" \
  --merge-install \
  --install-base "$INSTALL_DIR" \
  --packages-ignore "${IGNORE_PACKAGES[@]}" \
  --cmake-args \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CXX_COMPILER=/usr/bin/c++ \
    -DCMAKE_C_COMPILER=/usr/bin/cc \
    -DPython3_EXECUTABLE="$(which python3)" \
    -DBUILD_TESTING=OFF \
    $PYBIND11_FLAG \
    $CMAKE_PREFIX_FLAGS \
    "$@"

# Generate environment and Slicer launcher configurations
if [ -f "$SCRIPT_DIR/scripts/setup_env.py" ]; then
  echo "==> Generating environment configurations..."
  python3 "$SCRIPT_DIR/scripts/setup_env.py" --install-dir "$INSTALL_DIR"
fi

echo ""
echo "==> Build complete!"
echo "==> Install directory: $INSTALL_DIR"
echo "    Source into your shell with: source $INSTALL_DIR/setup.sh"
