#!/bin/bash

# ==========================================================
# Task: Infrastructure Security Check (U-15)
# Description: Check if system accounts have restricted shells.
# ==========================================================

echo "[U-15] Starting System Account Shell Check..."
echo "--------------------------------------------------"

# List of system accounts to check
TARGET_USERS=("adm" "bin" "daemon" "lp" "nobody" "uucp" "sync" "shutdown" "halt")

STATUS="OK"

for user in "${TARGET_USERS[@]}"
do
    USER_ENTRY=$(grep "^${user}:" /etc/passwd)

    if [ -n "$USER_ENTRY" ]; then
        USER_SHELL=$(echo "$USER_ENTRY" | cut -d: -f7)

        # Check if shell is restricted (/nologin or /false)
        if [[ "$USER_SHELL" == *"/nologin" ]] || [[ "$USER_SHELL" == *"/false" ]]; then
            echo "[ PASS ] $user: Shell is restricted ($USER_SHELL)."
        else
            echo "[ WARN ] $user: Vulnerable shell found ($USER_SHELL)!"
            STATUS="VULNERABLE"
        fi
    else
        echo "[ INFO ] $user: Account not found. (Skipping)"
    fi
done

echo "--------------------------------------------------"
echo "Final Result: $STATUS"
