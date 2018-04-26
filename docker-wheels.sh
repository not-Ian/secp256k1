#!/bin/bash

# This script should be run inside docker containers.

# By some cheating, we re-use it to actually execute the container and itself.
running_in_docker() {
  (awk -F/ '$2 == "docker"' /proc/self/cgroup | read non_empty_input)
}
if ! running_in_docker ; then
    docker pull quay.io/pypa/manylinux1_x86_64
    docker pull quay.io/pypa/manylinux1_i686
    docker run -v`pwd`:/io -w /io quay.io/pypa/manylinux1_x86_64 /io/docker-wheels.sh
    docker run -v`pwd`:/io -w /io quay.io/pypa/manylinux1_i686 linux32 /io/docker-wheels.sh
    exit
fi

set -e -x

# Install a system package required by our library
#yum install -y atlas-devel

## Compile wheels
for PYBIN in /opt/python/*/bin; do
##    "${PYBIN}/pip" install -r /io/dev-requirements.txt
    "${PYBIN}/pip" install cffi
#    "${PYBIN}/python" clean build_clib build_ext
    "${PYBIN}/pip" wheel /io/ -w wheelhouse/
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/secp*.whl; do
    auditwheel repair "$whl" -w /io/dist/
done

# Install packages and test
#for PYBIN in /opt/python/*/bin/; do
#    "${PYBIN}/pip" install python-manylinux-demo --no-index -f /io/wheelhouse
#    (cd "$HOME"; "${PYBIN}/nosetests" pymanylinuxdemo)
#done
