@echo off

rem clean build_clib build_ext

del secp256k1.egg-info
py -3.4 setup.py bdist_wheel
py -3.4-32 setup.py bdist_wheel
py -3.5 setup.py bdist_wheel
py -3.5-32 setup.py bdist_wheel
py -3.6 setup.py bdist_wheel
py -3.6-32 setup.py bdist_wheel
