#!/bin/bash

# Exit immediatelly if a command exits with a non-zero status
set -e

# Executes a command when DEBUG signal is emitted in this script - should be after every line
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG

# Executes a command when ERR signal is emmitted in this script
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

distro=`lsb_release -r | awk '{ print $2 }'`
[ "$distro" = "18.04" ] && ROS_DISTRO="melodic"
[ "$distro" = "20.04" ] && ROS_DISTRO="noetic"

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

## | --------- change to the directory of this script --------- |

cd "$MY_PATH"

# Setup catkin workspace
bash $MY_PATH/../ros_packages/uav_ros_stack/installation/workspace_setup.sh

# Build catkin workspace
ROOT_DIR=`dirname $MY_PATH`
cd ~/uav_ws/src
ln -s $ROOT_DIR
source /opt/ros/$ROS_DISTRO/setup.bash
catkin build

# Setup Gazebo
bash $MY_PATH/gazebo/setup_gazebo.sh $HOME/uav_ws/build
