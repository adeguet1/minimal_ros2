#include <rclcpp/rclcpp.hpp>
#include <geometry_msgs/msg/transform_stamped.hpp>
#include <tf2_ros/transform_broadcaster.h>
#include <iostream>
#include <chrono>
#include <thread>

using namespace std::chrono_literals;

class MinimalConsumerNode : public rclcpp::Node
{
public:
  MinimalConsumerNode()
  : Node("minimal_consumer_node"), mReceived(false)
  {
    mPublisher = this->create_publisher<geometry_msgs::msg::TransformStamped>("example_tf", 10);

    mSubscription = this->create_subscription<geometry_msgs::msg::TransformStamped>(
      "example_tf", 10,
      [this](const geometry_msgs::msg::TransformStamped & msg) {
        RCLCPP_INFO(this->get_logger(), "Received TF: '%s' -> '%s'",
                    msg.header.frame_id.c_str(), msg.child_frame_id.c_str());
        mReceived = true;
      });

    mTfBroadcaster = std::make_unique<tf2_ros::TransformBroadcaster>(*this);
  }

  void publish_test_message()
  {
    geometry_msgs::msg::TransformStamped tf_msg;
    tf_msg.header.stamp = this->now();
    tf_msg.header.frame_id = "world";
    tf_msg.child_frame_id = "sensor_frame";
    tf_msg.transform.translation.x = 1.0;
    tf_msg.transform.translation.y = 2.0;
    tf_msg.transform.translation.z = 3.0;
    tf_msg.transform.rotation.w = 1.0;

    mTfBroadcaster->sendTransform(tf_msg);
    mPublisher->publish(tf_msg);
    RCLCPP_INFO(this->get_logger(), "Published test transform: 'world' -> 'sensor_frame'");
  }

  bool has_received() const { return mReceived; }

private:
  rclcpp::Publisher<geometry_msgs::msg::TransformStamped>::SharedPtr mPublisher;
  rclcpp::Subscription<geometry_msgs::msg::TransformStamped>::SharedPtr mSubscription;
  std::unique_ptr<tf2_ros::TransformBroadcaster> mTfBroadcaster;
  bool mReceived;
};

int main(int argc, char ** argv)
{
  std::cout << "==> Initializing minimal_consumer example..." << std::endl;
  rclcpp::init(argc, argv);

  auto node = std::make_shared<MinimalConsumerNode>();
  node->publish_test_message();

  // Spin for up to 2 seconds or until message received
  auto start = std::chrono::steady_clock::now();
  while (!node->has_received() && (std::chrono::steady_clock::now() - start < 2s)) {
    rclcpp::spin_some(node);
    std::this_thread::sleep_for(20ms);
  }

  bool success = node->has_received();
  if (success) {
    std::cout << "==> Verification SUCCESS: Transform published and received!" << std::endl;
  } else {
    std::cerr << "==> Verification WARNING: Loopback message timeout." << std::endl;
  }

  rclcpp::shutdown();
  std::cout << "==> Shutdown complete." << std::endl;
  return success ? 0 : 1;
}
