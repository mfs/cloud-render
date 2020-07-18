#!/usr/bin/bash

set -x

mkdir ouput

wget -q https://mirror.clarkson.edu/blender/release/Blender2.83/blender-2.83.2-linux64.tar.xz

tar xf blender-2.83.2-linux64.tar.xz

sudo yum -y install libX11 libXi libXxf86vm libXfixes libXrender libglvnd-glx
