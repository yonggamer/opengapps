#!/bin/bash

# Function to check if a string is a valid number
is_number() {
    local num=$1
    [[ $num =~ ^[0-9]+$ ]]
}

# Example version string (replace this with the actual version check in your script)
version="0debian"

# Correct the version check
if is_number "$version"; then
    echo "Version is a valid number"
else
    echo "Version is not a valid number"
    version="0"  # Set a default or fallback version
fi

# Check API level and skip unsupported variants
API_LEVEL=19
SUPPORTED_API_LEVEL=21

# List of variants to build
variants=("stock" "full" "mini" "micro" "nano" "pico" "aroma" "super")

# Function to generate Open GApps package
generate_gapps_package() {
    local variant=$1
    echo "Generating Open GApps $variant package for arm with API level $API_LEVEL..."
    
    # Ensure the build directory exists
    mkdir -p "/home/runner/work/opengapps/opengapps/build/arm/$API_LEVEL/$variant"

    # Simulate file generation (replace this with the actual generation command)
    if ! touch "/home/runner/work/opengapps/opengapps/build/arm/$API_LEVEL/$variant/google.xml"; then
        echo "ERROR: No fallback available. Failed to build file etc/preferred-apps/google.xml"
        exit 1
    fi
}

for variant in "${variants[@]}"; do
    # Skip building the "super" variant for unsupported API levels
    if [[ "$variant" == "super" && "$API_LEVEL" -lt $SUPPORTED_API_LEVEL ]]; then
        echo "ERROR! Variant $variant cannot be built on API level $API_LEVEL"
        continue
    fi

    generate_gapps_package "$variant"
done
