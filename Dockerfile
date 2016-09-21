FROM ubuntu:16.04

MAINTAINER "Bogdan Girman" <bogdan.girman@gmail.com>

LABEL name="Docker image for the Robot Framework http://robotframework.org/"
LABEL usage="docker run -e ROBOT_TESTS=/path/to/tests/ --rm -v $(pwd)/path/to/tests/:/path/to/tests/ -ti robot-docker"


# Install Python Pip and the Robot framework
RUN apt-get update -y

RUN apt-get install -y  \
       fonts-liberation \
       gconf-service \
       libappindicator1 \
       libasound2 \
       libcurl3 \
       libgconf-2-4 \
       libindicator7 \
       libnspr4 \
       libnss3 \
       libpango1.0-0 \
       libxss1 \
       python-pip \
       python-pyasn1 \
       python-pyasn1-modules \
       unzip \
       wget \
       xdg-utils \
       xvfb \
       && \
    pip install --upgrade pip


# RUN pip install requirements.txt
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt


RUN wget http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_52.0.2743.116-1_amd64.deb
RUN dpkg -i google-chrome*.deb


RUN apt-get install -y  xvfb


RUN wget -N http://chromedriver.storage.googleapis.com/2.24/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN chmod +x chromedriver
RUN mv -f chromedriver /usr/local/share/chromedriver
RUN ln -sf /usr/local/share/chromedriver /usr/local/bin/chromedriver
RUN ln -sf /usr/local/share/chromedriver /usr/bin/chromedriver



ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh


CMD ["run.sh"]
