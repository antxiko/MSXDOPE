#!/bin/env bash

echo "Compiling code..."
sjasm main.as

echo "Running emulator..."
openmsx -script ../scripts/openmsx/boot.tcl -machine C-BIOS_MSX1 -carta dope.rom

echo "Cleaning temp files..."
rm -rf *.sym *.lst *.rom

cd ..
echo "Good bye!"
