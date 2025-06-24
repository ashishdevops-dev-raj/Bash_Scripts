#!/bin/bash
set -e

SOURCE_FILE="/home/corpuser/platform.lic"
DESTINATION_DIR="/home/ashsihraj.vc"
LOG_FILE="/var/log/copy_and_restart_tomcat.log"
TOMCAT_SERVICE="tomcat"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_message "Script started."

if [[ ! -f "$SOURCE_FILE" ]]; then
    log_message "Source file does not exist: $SOURCE_FILE"
    exit 1
fi

if [[ ! -d "$DESTINATION_DIR" ]]; then
    log_message "Destination directory does not exist: $DESTINATION_DIR"
    exit 1
fi

cp -p "$SOURCE_FILE" "$DESTINATION_DIR/"
log_message "Successfully copied $SOURCE_FILE to $DESTINATION_DIR."

log_message "Restarting Tomcat service..."
sudo systemctl restart "$TOMCAT_SERVICE"
log_message "Tomcat restarted successfully."

log_message "Script finished."
