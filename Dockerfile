FROM osrf/ros:kinetic-desktop-full

# Install dependencies
RUN apt-get -qq -y update && apt-get -qq -y install apt-utils curl
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add - \
    && apt-get update
RUN apt-get -qq -y install swi-prolog swi-prolog-java libjson-java \
    libjson-glib-dev python-yaml python-catkin-pkg python-rospkg \
    emacs ros-kinetic-rosjava ros-kinetic-rosbridge-suite \
    mongodb-clients ros-kinetic-rosauth mencoder lame libavcodec-extra \
    openjdk-8-jdk texlive-latex-base imagemagick \
    && apt-get -qq -y autoremove \
    && apt-get -qq -y clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

# ROS environment setup
RUN cp /opt/ros/kinetic/setup.sh /etc/profile.d/ros_kinetic.sh

# Create user 'ros'
RUN useradd -m -d /home/ros -p ros ros \
    && adduser ros sudo \
    && chsh -s /bin/bash ros
ENV HOME /home/ros
WORKDIR /home/ros

# Switch to the new user 'ros'
USER ros
RUN mkdir /home/ros/src \
    && chown -R ros:ros /home/ros \
    && rosdep update

RUN echo "source /opt/ros/kinetic/setup.bash" >> /home/ros/.bashrc && \
    echo "source /home/ros/.bashrc" >> /home/ros/.bash_profile

# Initialize the catkin workspace
USER ros
WORKDIR /home/ros/src
RUN /usr/bin/python /opt/ros/kinetic/bin/catkin_init_workspace

WORKDIR /home/ros
