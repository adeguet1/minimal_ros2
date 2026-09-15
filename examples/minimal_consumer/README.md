# Minimal Consumer Example

A standalone C++ CMake project demonstrating how to consume minimal_ros2.

## Features
- Discovers minimal_ros2 using `find_package(minimal_ros2 REQUIRED)`.
- Uses `rclcpp`, `geometry_msgs`, and `tf2_ros`.
- Publishes and receives a `geometry_msgs::msg::PointStamped`.

## Building

```bash
cmake -B build -S . -DCMAKE_PREFIX_PATH=/path/to/minimal_ros2/install
cmake --build build
```
