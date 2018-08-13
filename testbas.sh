#!/bin/env bash

echo "Running emulator..."
openmsx -script scripts/openmsx/boot.tcl -machine Panasonic_FS-A1GT -diska basic/

echo "Good bye!"
