#!/bin/bash
# install_dependencies.sh: to install dependencies required for building
# https://docs.travis-ci.com/user/installing-dependencies/

sudo apt-get -qq update
sudo apt-get install -y libarchive-dev docbook2x
