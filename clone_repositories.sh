#!/usr/bin/env bash
#
# clone_repositories.sh
# Clone minimal ROS 2 Lyrical repositories for rclcpp + tf2 + CycloneDDS
# without requiring vcstool.
#
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$SCRIPT_DIR/src}"

echo "==> Target directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

repos=(
  # Ament build & packaging
  "https://github.com/ament/ament_cmake.git ament/ament_cmake lyrical"
  "https://github.com/ament/ament_package.git ament/ament_package lyrical"
  "https://github.com/ament/ament_index.git ament/ament_index lyrical"
  "https://github.com/ros/ros_environment.git ros/ros_environment lyrical"
  "https://github.com/ros2/ament_cmake_ros.git ros2/ament_cmake_ros lyrical"

  # IDL parser, adapters, and typesupport
  "https://github.com/ros2/rosidl.git ros2/rosidl lyrical"
  "https://github.com/ros2/rosidl_core.git ros2/rosidl_core lyrical"
  "https://github.com/ros2/rosidl_defaults.git ros2/rosidl_defaults lyrical"
  "https://github.com/ros2/rosidl_typesupport.git ros2/rosidl_typesupport lyrical"
  "https://github.com/ros2/rosidl_dynamic_typesupport.git ros2/rosidl_dynamic_typesupport lyrical"
  "https://github.com/ros2/rosidl_python.git ros2/rosidl_python lyrical"
  "https://github.com/ros2/rosidl_runtime_py.git ros2/rosidl_runtime_py lyrical"

  # Utilities & core runtime
  "https://github.com/ros2/rcutils.git ros2/rcutils lyrical"
  "https://github.com/ros2/rcpputils.git ros2/rcpputils lyrical"
  "https://github.com/ros2/rpyutils.git ros2/rpyutils lyrical"
  "https://github.com/ros2/libyaml_vendor.git ros2/libyaml_vendor lyrical"
  "https://github.com/ros2/ros2_tracing.git ros2/ros2_tracing lyrical"
  "https://github.com/ros2/console_bridge_vendor.git ros2/console_bridge_vendor lyrical"
  "https://github.com/ros/class_loader.git ros/class_loader lyrical"

  # DDS Middleware (CycloneDDS)
  "https://github.com/eclipse-cyclonedds/cyclonedds.git eclipse-cyclonedds/cyclonedds releases/11.0.x"
  "https://github.com/ros2/rmw.git ros2/rmw lyrical"
  "https://github.com/ros2/rmw_dds_common.git ros2/rmw_dds_common lyrical"
  "https://github.com/ros2/rmw_implementation.git ros2/rmw_implementation lyrical"
  "https://github.com/ros2/rmw_cyclonedds.git ros2/rmw_cyclonedds lyrical"

  # Logging & Statistics
  "https://github.com/ros2/spdlog_vendor.git ros2/spdlog_vendor lyrical"
  "https://github.com/ros2/rcl_logging.git ros2/rcl_logging lyrical"
  "https://github.com/ros-tooling/libstatistics_collector.git ros-tooling/libstatistics_collector lyrical"

  # Core Client Library (RCL / RCLCPP)
  "https://github.com/ros2/rcl.git ros2/rcl lyrical"
  "https://github.com/ros2/rclcpp.git ros2/rclcpp lyrical"

  # Interfaces & standard messages
  "https://github.com/ros2/rcl_interfaces.git ros2/rcl_interfaces lyrical"
  "https://github.com/ros2/unique_identifier_msgs.git ros2/unique_identifier_msgs lyrical"
  "https://github.com/ros2/common_interfaces.git ros2/common_interfaces lyrical"

  # TF2 & message filters
  "https://github.com/ros2/eigen3_cmake_module.git ros2/eigen3_cmake_module lyrical"
  "https://github.com/ros2/message_filters.git ros2/message_filters lyrical"
  "https://github.com/ros2/geometry2.git ros2/geometry2 lyrical"
)

TOTAL=${#repos[@]}
COUNT=0

for entry in "${repos[@]}"; do
  COUNT=$((COUNT + 1))
  read -r url rel_path branch <<< "$entry"
  dest="$TARGET_DIR/$rel_path"

  if [ -d "$dest/.git" ]; then
    echo "[$COUNT/$TOTAL] Skipping (already exists): $rel_path"
  else
    echo "[$COUNT/$TOTAL] Cloning $rel_path ($branch)..."
    mkdir -p "$(dirname "$dest")"
    git clone --depth 1 -b "$branch" "$url" "$dest"
  fi
done

echo ""
echo "==> Successfully downloaded all $TOTAL repositories into $TARGET_DIR"
