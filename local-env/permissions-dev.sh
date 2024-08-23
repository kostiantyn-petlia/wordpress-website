#!/bin/bash

# WordPress file permissions.
#
# For the development environment only! It's a not-safe version.
#
# Usage:
# 1) Once set WP_PATH, WP_OWNER and WP_GROUP in the .env file.
# 2) Terminal: sudo bash permissions-dev.sh

# Source the .env file.
source .env

# Echo everything it is doing.
set -x

# Set these variables in the .env file.
WP_PATH="${WP_PATH:-..}"          # /path/to/wordpress
WP_OWNER="${WP_OWNER:-$USER}"     # Our Linux user
WP_GROUP="${WP_GROUP:-www-data}"  # This is usually the web server/Apache group

# Array of directories to be owned by our user (WP_OWNER).
SPECIAL_DIRS=(".git" ".idea" ".vscode")

# Ensure the script is run as root.
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Visible files and directories owner.
chown "${WP_GROUP}":"${WP_OWNER}" -R "${WP_PATH}"/*
# Hidden files and directories owner, except the special directories . and ..
chown "${WP_GROUP}":"${WP_OWNER}" -R "${WP_PATH}"/.[^.]*

# Set the owner for specified special directories.
for dir in "${SPECIAL_DIRS[@]}"; do
    if [ -d "${WP_PATH}/${dir}" ]; then
        chown "${WP_OWNER}":"${WP_OWNER}" -R "${WP_PATH}/${dir}"
    fi
done

# Change directory permissions to rwxrwxr-x.
find "${WP_PATH}" -type d -exec chmod 775 {} +

# Change file permissions to rw-rw-r–.
find "${WP_PATH}" -type f -exec chmod 664 {} +

echo "WordPress file permissions have been configured for the development environment."
