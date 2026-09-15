# Minimal ROS 2 (Superbuild)

[![CI](https://github.com/adeguet1/minimal_ros2/actions/workflows/ci.yml/badge.svg)](https://github.com/adeguet1/minimal_ros2/actions/workflows/ci.yml)

A lightweight, standalone, self-contained ROS 2 distribution designed for native compilation on **macOS**, **Windows**, and **Linux**.

This repository compiles only the essential client library and coordinate transform layers required to build C++ ROS 2 nodes, plugins, and embedded GUI applications (such as [3D Slicer](https://www.slicer.org/) loadable modules) without needing to install a 10+ GB full ROS 2 desktop distribution.

---

## Architecture & Features

```text
minimal_ros2/
├── CMakeLists.txt                 # Top-level Superbuild entry point
├── repos/
│   └── minimal_ros2.repos         # VCS YAML definition of repos and commit tags
├── cmake/
│   ├── External_python_env.cmake  # Python build environment setup
│   ├── External_cyclonedds.cmake  # CycloneDDS pure CMake build recipe
│   ├── External_fastrtps.cmake    # Fast-DDS build recipe
│   ├── External_rcutils.cmake     # C runtime and memory utilities
│   ├── External_rclcpp.cmake      # C++ client library
│   ├── External_minimal_ros2.cmake # Topological package compiler
│   └── minimal_ros2-config.cmake.in # find_package(minimal_ros2) config template
├── scripts/
│   ├── fetch_sources.py           # Cross-platform Python git cloner (no vcstool required)
│   └── setup_env.py               # Cross-platform environment generator (sh, bat, ps1)
└── README.md
```

* **DDS Middleware**: Eclipse CycloneDDS (default) or eProsima Fast-DDS.
* **Core C/C++ Client Library**: `rclcpp`, `rcl`, `rcutils`, `rcpputils`, `tracetools`.
* **Coordinate Transformations**: `tf2`, `tf2_ros`, `tf2_msgs`, `tf2_geometry_msgs`, `message_filters`.
* **Standard Interfaces**: `std_msgs`, `geometry_msgs`, `sensor_msgs`, `trajectory_msgs`, `shape_msgs`, `std_srvs`, `rcl_interfaces`.
* **Cross-Platform**: Works on macOS (Apple Silicon `arm64` and Intel `x86_64`), Windows (MSVC 2019/2022 x64), and Linux.

---

## Prerequisites

### macOS
1. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
2. **Homebrew Dependencies**:
   ```bash
   brew install cmake ninja libyaml spdlog console_bridge eigen asio pybind11
   ```
3. **Python (>= 3.10)**: Any modern Python 3 interpreter.

### Linux (Ubuntu 22.04 / 24.04)
1. **System Dependencies**:
   ```bash
   sudo apt-get update
   sudo apt-get install -y cmake ninja-build libyaml-dev libspdlog-dev \
     libeigen3-dev libconsole-bridge-dev libasio-dev pybind11-dev
   ```
2. **Python (>= 3.10)**: `python3` and `python3-venv`.

### Windows
1. **Visual Studio 2022** (with "Desktop development with C++").
2. **CMake (>= 3.20)** & **Git**.
3. **Python (>= 3.10)** installed and in `PATH`.
4. Enable **Windows Long Paths**:
   ```cmd
   git config --system core.longpaths true
   ```
5. **vcpkg Dependencies**:
   ```cmd
   vcpkg install libyaml spdlog eigen3 asio console-bridge pybind11 --triplet x64-windows
   ```

---

## Building minimal_ros2

### macOS / Linux
```bash
cmake -B build -S . -DCMAKE_BUILD_TYPE=Release
cmake --build build -j8
```

### Windows (Visual Studio)
```cmd
cmake -B build -S . -G "Visual Studio 17 2022" -A x64
cmake --build build --config Release
```

The Superbuild will automatically:
1. Fetch all required repositories using `scripts/fetch_sources.py`.
2. Prepare a local Python environment (`.venv`) with code generation packages (`empy`, `lark`, `catkin_pkg`, `colcon`).
3. Compile all packages in topological order into `install/`.
4. Generate shell scripts (`setup.sh`, `setup.bat`, `setup.ps1`).
5. Export `minimal_ros2-config.cmake` for downstream CMake projects.

---

## Using in Downstream CMake Projects (e.g. Slicer ROS 2 Module)

Downstream projects can directly consume `minimal_ros2` using modern CMake:

```cmake
find_package(minimal_ros2 REQUIRED)
find_package(rclcpp REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(geometry_msgs REQUIRED)

add_executable(my_node src/main.cpp)
target_link_libraries(my_node PRIVATE
  rclcpp::rclcpp
  tf2_ros::tf2_ros
  geometry_msgs::geometry_msgs__rosidl_typesupport_cpp
)
```

Configure your project with:
```bash
cmake -B build -S . -DCMAKE_PREFIX_PATH=/path/to/minimal_ros2/install
cmake --build build
```

---


## License
Apache 2.0 / BSD 3-Clause (aligned with upstream ROS 2 components).
