#!/bin/bash

# WordPress file permissions.
#
# For the development environment only! It's a not-safe version.
#
# Usage:
# 1) Once set SH_ROOT_PATH, SH_WP_OWNER and SH_WP_GROUP in the .env file.
# 2) Terminal: sudo bash permissions-dev.sh

# Source the .env file.
source .env

# Echo everything it is doing.
set -x

# Set these variables in the .env file.
SH_ROOT_PATH="${SH_ROOT_PATH:-..}"                              # /path/to/project-root
SH_WP_CONTENT_PATH="${SH_WP_CONTENT_PATH:-../apps/wp-content}"  # /path/to/wp-content
SH_WP_OWNER="${SH_WP_OWNER:-$USER}"                             # Our Linux user.
SH_WP_GROUP="${SH_WP_GROUP:-www-data}"                          # This is usually the web server/Apache group.

# Array of directories to be owned by our user (SH_WP_OWNER).
SPECIAL_DIRS=(".git" ".idea" ".vscode")

# Ensure the script is run as root.
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Visible files and directories owner.
chown "${SH_WP_GROUP}":"${SH_WP_OWNER}" -R "${SH_ROOT_PATH}"/*
# Hidden files and directories owner, except the special directories . and ..
chown "${SH_WP_GROUP}":"${SH_WP_OWNER}" -R "${SH_ROOT_PATH}"/.[^.]*

# Set the owner for specified special directories.
for dir in "${SPECIAL_DIRS[@]}"; do
    if [ -d "${SH_ROOT_PATH}/${dir}" ]; then
        chown "${SH_WP_OWNER}":"${SH_WP_OWNER}" -R "${SH_ROOT_PATH}/${dir}"
    fi
done

# Change directory permissions to rwxrwxr-x.
find "${SH_ROOT_PATH}" -type d -exec chmod 775 {} +

# Change file permissions to rw-rw-r–.
find "${SH_ROOT_PATH}" -type f -exec chmod 664 {} +

echo "WordPress file permissions have been configured for the development environment."
