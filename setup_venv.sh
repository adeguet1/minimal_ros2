#!/usr/bin/env bash
#
# setup_venv.sh
# Creates a Python virtual environment with all build dependencies
# needed to compile minimal_ros2.
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="$SCRIPT_DIR/.venv"

# Find suitable Python interpreter
PYTHON_CMD="$1"
if [ -z "$PYTHON_CMD" ]; then
  # Check for Slicer embedded Python first
  if [ -x "$SCRIPT_DIR/../slicer/build/python-install/bin/python3" ]; then
    PYTHON_CMD="$SCRIPT_DIR/../slicer/build/python-install/bin/python3"
    echo "==> Using Slicer Python: $PYTHON_CMD"
  elif [ -x "$HOME/devel/slicer/build/python-install/bin/python3" ]; then
    PYTHON_CMD="$HOME/devel/slicer/build/python-install/bin/python3"
    echo "==> Using Slicer Python: $PYTHON_CMD"
  elif command -v python3.12 >/dev/null 2>&1; then
    PYTHON_CMD="$(command -v python3.12)"
    echo "==> Using system python3.12: $PYTHON_CMD"
  else
    PYTHON_CMD="$(command -v python3)"
    echo "==> Using default python3: $PYTHON_CMD"
  fi
fi

echo "==> Python version: $($PYTHON_CMD --version)"

# Create virtualenv if not already created
if [ ! -d "$VENV_DIR" ]; then
  echo "==> Creating virtual environment in $VENV_DIR..."
  "$PYTHON_CMD" -m venv "$VENV_DIR"
else
  echo "==> Virtual environment already exists in $VENV_DIR"
fi

echo "==> Installing build dependencies via pip..."
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install \
  colcon-common-extensions \
  "empy<4" \
  lark \
  catkin_pkg \
  pyyaml \
  numpy \
  pybind11 \
  setuptools

echo ""
echo "==> Virtual environment ready in $VENV_DIR"
echo "    Activate with: source $VENV_DIR/bin/activate"
