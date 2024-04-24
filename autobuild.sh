#!/bin/bash

# Clean APT cache
echo "Cleaning APT cache..."
apt-get clean

# Remove temporary files and directories
echo "Removing temporary files..."
rm -rf /tmp/*
rm -rf /var/tmp/*

# Clear user cache
echo "Clearing user cache..."
rm -rf /home/guest/.cache/*

# Remove system logs
echo "Removing system logs..."
find /var/log -type f -delete

# Clear bash history
echo "Clearing bash history..."
rm -f /home/guest/.bash_history
rm -f /root/.bash_history

# Remove unused packages and dependencies
echo "Removing unused packages and dependencies..."
apt-get autoremove --purge -y

# Zero out free space
echo "Zeroing out free space... (This may take a while)"
dd if=/dev/zero of=/bigfile bs=1M || true # Continue on error in case of no space left
rm -f /bigfile

# Ensure all changes are written to disk
sync

# Build the environment
echo "Building the live environment..."
/buildenv/linux-live-2.12/build

# Generate data-interface ISO
echo "Generating data-interface ISO..."
/tmp/gen_data-interface_iso.sh

# Move the ISO to the user's Documents directory
echo "Moving ISO to /home/guest/Documents..."
mv /tmp/data-interface-x86_64.iso /home/guest/Documents

echo "Cleanup and build process completed!"
