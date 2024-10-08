#!/bin/bash

# WordPress file permissions.
#
# TODO Check it twice for security
# It's a safe version.
# https://developer.wordpress.org/advanced-administration/security/hardening/#file-permissions
#
# Usage:
# 1) Once set WP_PATH, WP_OWNER and WP_GROUP in the .env file.
# 2) Terminal: sudo bash permissions-prod.sh
#
# Ignore the executable bit changes one time:
# git -c core.fileMode=false <command>
# git -c core.fileMode=false status

# Source the .env file.
source .env

# Echo everything it is doing.
set -x

# Set these variables in the .env file.
WP_PATH="${WP_PATH:-..}"          # /path/to/wordpress
WP_OWNER="${WP_OWNER:-$USER}"     # Our Linux user
WP_GROUP="${WP_GROUP:-www-data}"  # This is usually the web server/Apache group

# Ensure the script is run as root.
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Set ownership of all files.
chown -R "${WP_OWNER}":"${WP_OWNER}" "${WP_PATH}"

# Set base permissions.
find "${WP_PATH}" -type d -exec chmod 755 {} \;
find "${WP_PATH}" -type f -exec chmod 644 {} \;

# Make .htaccess writable by the web server if it exists.
if [ -f "${WP_PATH}/.htaccess" ]; then
    chmod 664 "${WP_PATH}/.htaccess"
    chgrp "${WP_GROUP}" "${WP_PATH}/.htaccess"
fi

# Set wp-content permissions.
chgrp -R "${WP_GROUP}" "${WP_PATH}/wp-content"
chmod g+s "${WP_PATH}/wp-content"

# Make directories writable by the web server (it's for updates).
DIRECTORIES=("cache" "languages" "mu-plugins" "plugins" "themes" "uploads")
for DIR in "${DIRECTORIES[@]}"; do
  if [ -d "${WP_PATH}/${DIR}" ]; then
    chmod -R 775 "${WP_PATH}/${DIR}"
    chgrp -R "${WP_GROUP}" "${WP_PATH}/${DIR}"
    echo "Processed ${DIR} directory"
  else
    echo "Error: ${DIR} directory not found"
  fi
done

echo "WordPress file permissions have been configured for the production environment."
