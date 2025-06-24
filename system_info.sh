#!/bin/bash

echo "Welcome to the system information script."
echo "Script run on: $(date)"
echo "Running on host: $(hostname)"
echo

# Checking system uptime
echo "#####################################"
echo "System Uptime: "
uptime
echo

# Memory Utilization
echo "#####################################"
echo "Memory Utilization (in MB)"
free -m
echo

# Disk Utilization
echo "#####################################"
echo "Disk Utilization"
df -h
echo

# CPU Load
echo "#####################################"
echo "CPU Load"
top -bn1 | grep "Cpu(s)"
echo
