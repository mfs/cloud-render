#!/usr/bin/bash

set -e

BLEND_VER=2.90.0

mkdir ouput

wget -q https://mirror.clarkson.edu/blender/release/Blender${BLEND_VER%.*}/blender-$BLEND_VER-linux64.tar.xz

tar xf blender-$BLEND_VER-linux64.tar.xz

sudo yum -y install libX11 libXi libXxf86vm libXfixes libXrender libglvnd-glx
