# Minimal Consumer Example

A standalone C++ CMake project demonstrating how to consume the `minimal_ros2` underlay.

## Features
- Discovers the underlay using `find_package(minimal_ros2 REQUIRED)`.
- Uses `rclcpp`, `tf2_ros`, and `geometry_msgs`.
- Publishes and receives a `geometry_msgs::msg::TransformStamped` using `tf2_ros::TransformBroadcaster`.

## Building

```bash
# Point CMAKE_PREFIX_PATH to the minimal_ros2 install directory
cmake -B build -S . -DCMAKE_PREFIX_PATH=/path/to/minimal_ros2/install
cmake --build build

# Run the example
./build/minimal_consumer
```

On Windows (Visual Studio):
```cmd
cmake -B build -S . -G "Visual Studio 17 2022" -A x64 -DCMAKE_PREFIX_PATH=C:\path\to\minimal_ros2\install
cmake --build build --config Release
.\build\Release\minimal_consumer.exe
```
