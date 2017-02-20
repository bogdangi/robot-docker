# Docker image for the Robot Framework
[![Build Status](https://travis-ci.org/bogdangi/robot-docker.svg?branch=master)](https://travis-ci.org/bogdangi/robot-docker)

## Overview

Information on the Robot Framework can be found here [Robot Framework](http://robotframework.org)


## Run Robot inside Docker

Mount with robot tests and pass the ROBOT_TESTS env var

```sh
docker run --rm \
        --privileged \
        -e HOSTS="192.168.0.123 example.local" \
        -e ROBOT_TESTS=/robot_tests/sample.robot \
        -e OUTPUT_DIR=/output \
        -v /dev/shm:/dev/shm \
        -v ${PWD}/output/:/output/ \
        -v ${PWD}/:/robot_tests/ \
        -it bogdangi/robot-docker:latest
```
