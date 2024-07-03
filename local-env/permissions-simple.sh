#!/bin/bash

# WordPress file permissions
#
# Simple not-safe version.
#
# Usage: sudo bash permissions-simple.sh

# Source the .env file
source .env

# Echo everything it is doing
set -x

# Set these variables in the .env file
WP_PATH="${WP_PATH:-..}"            # /path/to/wordpress
WP_OWNER="${WP_OWNER:-$USER}"       # Our Linux user
WP_GROUP="${WP_GROUP:-www-data}"    # This is usually the web server/Apache group

# Visible files and directories owner
chown $WP_GROUP:$WP_OWNER -R "$WP_PATH/*"
# Hidden files and directories owner, except the special directories . and ..
chown $WP_GROUP:$WP_OWNER -R "$WP_PATH/.[^.]**"

# Change directory permissions to rwxrwxr-x
find ../ -type d -exec chmod 775 {} \;

# Change file permissions to rw-rw-r–
find ../ -type f -exec chmod 664 {} \;

echo "WordPress simple permissions have been set."
