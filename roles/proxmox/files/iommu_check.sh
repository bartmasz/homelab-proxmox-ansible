#!/bin/bash

# Check if the script is run with root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Path to the IOMMU groups directory
IOMMU_GROUPS="/sys/kernel/iommu_groups"

# Check if the IOMMU groups directory exists
if [ ! -d "$IOMMU_GROUPS" ]; then
    echo "IOMMU groups directory does not exist. Are IOMMU features enabled in your BIOS and kernel?" >&2
    exit 1
fi

echo "Listing IOMMU groups and devices:"

# Iterate through each IOMMU group
for iommu_group in $(find $IOMMU_GROUPS -maxdepth 1 -mindepth 1 -type d | sort -V); do
    echo "IOMMU Group $(basename "$iommu_group"):"
    for device in $(ls -1 "$iommu_group"/devices/); do
        # Extracting the vendor and device ID
        vendor=$(cat "/sys/bus/pci/devices/$device/vendor")
        device_id=$(cat "/sys/bus/pci/devices/$device/device")
        # Trying to get a more descriptive device name using lspci (if available)
        if hash lspci 2>/dev/null; then
            device_name=$(lspci -s ${device} -nn)
        else
            device_name="Device $device ($vendor $device_id)"
        fi
        echo -e " - $device_name"
    done
done
