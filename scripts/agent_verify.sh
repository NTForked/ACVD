#!/usr/bin/env bash
# ACVD Agent Verification Script
# Verifies build system compilation and executes basic test remeshing tasks.

set -e

echo "=== 1. Checking Environment and Dependencies ==="
if ! command -v cmake &> /dev/null; then
    echo "ERROR: cmake could not be found."
    exit 1
fi

echo "CMake version: $(cmake --version | head -n 1)"

echo "=== 2. Configuring Out-of-Source Build ==="
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release

echo "=== 3. Compiling ACVD Libraries and Executables ==="
cmake --build . -j$(nproc)

echo "=== 4. Verifying Executable Artifacts ==="
BIN_DIR="./bin"
if [ ! -d "$BIN_DIR" ]; then
    BIN_DIR="."
fi

REQUIRED_EXECS=("ACVD" "ACVDQ" "ACVDP" "ACVDQP" "AnisotropicRemeshingQ")
for exec in "${REQUIRED_EXECS[@]}"; do
    if [ -f "$BIN_DIR/$exec" ]; then
        echo "[OK] Found executable: $BIN_DIR/$exec"
    else
        echo "[ERROR] Missing required executable: $exec"
        exit 1
    fi
done

echo "=== 5. Running Verification Test Remeshing ==="
TEST_MODEL="stanford-bunny.obj"
if [ ! -f "$TEST_MODEL" ]; then
    echo "Downloading standard bunny test model..."
    wget -q --show-progress https://github.com/alecjacobson/common-3d-test-models/raw/master/data/stanford-bunny.obj -O "$TEST_MODEL" || true
fi

if [ -f "$TEST_MODEL" ]; then
    echo "Running isotropic remeshing test (ACVD)..."
    "$BIN_DIR/ACVD" "$TEST_MODEL" 1000 0 -o bunny_remesh_1000.ply
    
    echo "Running quadric feature-preserving test (ACVDQ)..."
    "$BIN_DIR/ACVDQ" "$TEST_MODEL" 1000 0 -o bunny_quadric_1000.ply

    echo "[SUCCESS] Verification remeshing tests completed successfully!"
else
    echo "[WARNING] Test model could not be downloaded, skipping remeshing execution test."
fi

echo "=== ACVD Verification Complete ==="
