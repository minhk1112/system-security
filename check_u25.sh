#!/bin/bash

# ==========================================================
# Task: Infrastructure Security Check (U-25)
# Description: Check NFS service and /etc/exports configuration.
# ==========================================================

echo "[U-25] Starting NFS Service and Configuration Check..."
echo "--------------------------------------------------"

STATUS="OK"

# 1. Check if NFS process is running
NFS_PROCESS=$(ps -ef | grep -E "nfsd|mountd|statd" | grep -v "grep")

if [ -n "$NFS_PROCESS" ]; then
    echo "[ INFO ] NFS Service is currently RUNNING."
    
    # 2. Check /etc/exports file for vulnerable settings
    if [ -f /etc/exports ]; then
        # Check for wildcard '*' or insecure options
        VULN_EXPORTS=$(grep -v "^#" /etc/exports | grep "*")
        
        if [ -n "$VULN_EXPORTS" ]; then
            echo "[ WARN ] Vulnerable NFS export found: $VULN_EXPORTS"
            STATUS="VULNERABLE"
        else
            echo "[ PASS ] No insecure wildcard (*) exports found."
        fi
    else
        echo "[ PASS ] /etc/exports file does not exist (Safe)."
    fi
else
    echo "[ PASS ] NFS Service is NOT running."
fi

echo "--------------------------------------------------"
echo "Final Result: $STATUS"
