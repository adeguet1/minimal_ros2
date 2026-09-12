# Minimal ROS 2 Underlay

A lightweight, standalone, self-contained ROS 2 underlay designed for native compilation on **macOS** (Apple Silicon `arm64` and Intel `x86_64`) and **Linux**.

This repository provides only the core client library and coordinate transform layers required to build C++ ROS 2 nodes, plugins, and embedded GUI applications (such as [3D Slicer](https://www.slicer.org/) loadable modules, [cisst/saw](https://github.com/jhu-cisst/cisst), or [dVRK](https://github.com/jhu-dvrk/sawIntuitiveResearchKit)) without needing to install a massive 10+ GB full ROS 2 desktop distribution.

---

## Included Components

* **DDS Middleware**: [Eclipse CycloneDDS](https://github.com/eclipse-cyclonedds/cyclonedds) + `rmw_cyclonedds_cpp` (pure C/C++, fast, no Java/JVM dependencies).
* **Core C/C++ Client Library**: `rclcpp`, `rcl`, `rcutils`, `rcpputils`, `tracetools`.
* **Coordinate Transformations**: `tf2`, `tf2_ros`, `tf2_msgs`, `tf2_geometry_msgs`, `message_filters`.
* **Standard Interfaces**: `std_msgs`, `geometry_msgs`, `sensor_msgs`, `trajectory_msgs`, `shape_msgs`, `std_srvs`, `rcl_interfaces`.
* **IDL & Code Generators**: `rosidl` compiler suite with C, C++, and Python typesupport generation.

---

## Prerequisites

### macOS (Apple Silicon & Intel)
1. **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
2. **Homebrew Dependencies**:
   ```bash
   brew install cmake ninja libyaml spdlog console_bridge orocos-kdl
   ```
3. **Python (>= 3.10)**:
   Any modern Python 3 interpreter (e.g. `brew install python@3.12` or 3D Slicer's bundled Python).

---

## Quickstart

### 1. Set Up Python Build Environment
Run the setup script to create a local virtual environment (`.venv`) with the required build tools (`colcon`, `empy`, `lark`, `catkin_pkg`, `pyyaml`, `numpy`):

```bash
./setup_venv.sh
```
*(Optional: Pass a custom Python interpreter, e.g. `./setup_venv.sh /path/to/slicer/build/python-install/bin/python3`).*

### 2. Clone Repositories
Download the minimal set of repositories (defaulting to ROS 2 `lyrical` branch) without requiring `vcstool`:

```bash
./clone_repositories.sh
```

*(Alternatively, if you have `vcstool` installed: `vcs import src < ros2_lyrical_minimal.repos`).*

### 3. Build the Underlay
Build the entire underlay into a clean, unified install prefix (`install/`):

```bash
./build.sh
```

The build uses parallel compilation via Ninja/CMake and completes in approximately 3 to 5 minutes on Apple Silicon.

---

## Using with CMake Projects

Once compiled, you can build any downstream CMake project against this underlay simply by adding its `install` directory to `CMAKE_PREFIX_PATH`:

```bash
cmake -B build -S <your_project> \
  -DCMAKE_PREFIX_PATH=/path/to/minimal_ros2/install
cmake --build build
```

Inside your `CMakeLists.txt`, use standard modern CMake targets:

```cmake
find_package(rclcpp REQUIRED)
find_package(tf2 REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(geometry_msgs REQUIRED)

add_executable(my_node src/main.cpp)
target_link_libraries(my_node PRIVATE
  rclcpp::rclcpp
  tf2::tf2
  tf2_ros::tf2_ros
  geometry_msgs::geometry_msgs__rosidl_typesupport_cpp
)
```

---

## License
Apache 2.0 / BSD 3-Clause (aligned with upstream ROS 2 components).
