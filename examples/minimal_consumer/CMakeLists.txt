cmake_minimum_required(VERSION 3.20)
project(minimal_consumer LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Find the minimal_ros2 underlay
find_package(minimal_ros2 REQUIRED)

# 2. Find individual ROS 2 libraries
find_package(rclcpp REQUIRED)
find_package(tf2_ros REQUIRED)
find_package(geometry_msgs REQUIRED)

# 3. Define the consumer executable
add_executable(minimal_consumer src/main.cpp)
target_link_libraries(minimal_consumer PRIVATE
  rclcpp::rclcpp
  tf2_ros::tf2_ros
  geometry_msgs::geometry_msgs__rosidl_typesupport_cpp
)
