#!/usr/bin/env bash
set -e

platform_url="https://github.com/pioarduino/platform-espressif32/releases/download/stable/platform-espressif32.zip"

# Install PlatformIO
python3 -m pip install --quiet platformio

# Install custom ESP32 platform
python3 -m platformio platform install "$platform_url"

# Build PlayWAVFromPROGMEM example using PlatformIO
build_dir=$(mktemp -d)
mkdir -p "$build_dir/src"
cp examples/PlayWAVFromPROGMEM/PlayWAVFromPROGMEM.ino "$build_dir/src/main.cpp"
cp examples/PlayWAVFromPROGMEM/*.h "$build_dir/src/"
cat <<PIOEOF > "$build_dir/platformio.ini"
[env:esp32dev]
platform = $platform_url
board = esp32dev
framework = arduino
build_flags = -DAUDIO_USE_IDF5_DRIVER
lib_extra_dirs = $PWD
PIOEOF
python3 -m platformio run -d "$build_dir"
