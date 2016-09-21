Docker image for the Robot Framework
===============

.. contents::
   :local:

Overview
------------

Information on the Robot Framework can be found here:

`Robot Framework <http://robotframework.org>`_

Run Robot inside Docker
------------

To build a Robot Docker image::

    docker build -t robot-docker .

To run tests, mount a directory and pass the ROBOT_TESTS env var::

    docker run --rm \
        --privileged \
        -e HOSTS="192.168.0.123 example.local" \
        -e ROBOT_TESTS=/robot_tests/sample.robot \
        -e OUTPUT_DIR=/output \
        -v /dev/shm:/dev/shm \
        -v ${PWD}/output/:/output/ \
        -v ${PWD}/:/robot_tests/ -it bogdangi/robot-docker:latest
