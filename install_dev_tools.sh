#!/bin/bash

# Ubuntu

export DEBIAN_FRONTEND=noninteractive

apt-get update
INSTALL_DEPS="ca-certificates curl"

for dep in $INSTALL_DEPS; do
    if dpkg -l | grep -q "$dep" >/dev/null 2>&1; then
        echo "$dep is already installed"
    else
        echo "Installing $dep"
        apt-get install -y $dep
    fi
done

#DOCKER
if dpkg -l | grep -q "docker" >/dev/null 2>&1; then
    echo "Docker is already installed"
else
    echo "Installing Docker"
    #official docker guide: https://docs.docker.com/engine/install/ubuntu/
    # Add Docker's official GPG key:
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update

    # Install Docker Engine, containerd, and Docker Compose
    DOCKER_PACKGAGES="docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin"

    for package in $DOCKER_PACKGAGES; do
        if dpkg -l | grep -q "$package" >/dev/null 2>&1; then
            echo "$package is already installed"
        else
            echo "Installing $package"
            apt-get install -y $package
        fi
    done

fi

#PYTHON
PYTHON_PACKAGES="python3 python3-pip"

for i in $PYTHON_PACKAGES; do 
    if dpkg -l | grep -q "$i" >/dev/null 2>&1; then
        echo "$i is already installed"
    else
        echo "Installing $i"
        apt-get install -y $i
    fi
done

#DJANGO
if dpkg -l | grep -q "python3-django" >/dev/null 2>&1; then
    echo "Django is already installed"
else
    echo "Installing Django"
    apt-get install -y python3-django
fi