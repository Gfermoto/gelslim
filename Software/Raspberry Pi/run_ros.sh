#!/bin/bash

# Allow local connections from Docker containers to the X server
export DISPLAY=:0.0
xhost +local:docker

# Get the DISPLAY variable from the host environment
DISPLAY_VAR=${DISPLAY}

# Run the ROS Melodic container with correct display forwarding
docker run -it --privileged \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev/dri:/dev/dri \
    -v $(pwd):/sensor \
    --env="DISPLAY=$DISPLAY_VAR" \
    --env="QT_X11_NO_MITSHM=1" \
    -e USER=sensor \
    -e USER_UID=1000 \
    -e USER_GID=1000 \
    --net=host \
    --ipc=host \
    --name=ros1 \
    tiryoh/ros-melodic-desktop

# Update and source the ROS environment in bashrc
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
