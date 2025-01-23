#!/bin/bash

# WordPress file permissions.
#
# TODO Check it twice in general and for security
# It's a safe version.
# https://developer.wordpress.org/advanced-administration/security/hardening/#file-permissions
#
# Usage:
# 1) Once set SH_ROOT_PATH, SH_WP_OWNER and SH_WP_GROUP in the .env file.
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
SH_ROOT_PATH="${SH_ROOT_PATH:-..}"                          # /path/to/project-root
SH_WP_CONTENT_PATH="${SH_WP_CONTENT_PATH:-../wp-content}"   # /path/to/wp-content
SH_WP_OWNER="${SH_WP_OWNER:-$USER}"                         # Our Linux user.
SH_WP_GROUP="${SH_WP_GROUP:-www-data}"                      # This is usually the web server/Apache group.

# Ensure the script is run as root.
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root." 1>&2
   exit 1
fi

# Set ownership of all files.
chown -R "${SH_WP_OWNER}":"${SH_WP_OWNER}" "${SH_ROOT_PATH}"

# Set base permissions.
find "${SH_ROOT_PATH}" -type d -exec chmod 755 {} \;
find "${SH_ROOT_PATH}" -type f -exec chmod 644 {} \;

# Make .htaccess writable by the web server if it exists.
if [ -f "${SH_ROOT_PATH}/config/wordpress/.htaccess" ]; then
    chmod 664 "${SH_ROOT_PATH}/config/wordpress/.htaccess"
    chgrp "${SH_WP_GROUP}" "${SH_ROOT_PATH}/config/wordpress/.htaccess"
fi

# Set wp-content permissions.
chgrp -R "${SH_WP_GROUP}" "${SH_WP_CONTENT_PATH}"
chmod g+s "${SH_WP_CONTENT_PATH}"

# Make directories writable by the web server (it's for updates).
DIRECTORIES=("cache" "languages" "mu-plugins" "plugins" "themes" "uploads")
for DIR in "${DIRECTORIES[@]}"; do
  if [ -d "${SH_WP_CONTENT_PATH}/${DIR}" ]; then
    chmod -R 775 "${SH_WP_CONTENT_PATH}/${DIR}"
    chgrp -R "${SH_WP_GROUP}" "${SH_WP_CONTENT_PATH}/${DIR}"
    echo "Processed ${DIR} directory"
  else
    echo "Error: ${DIR} directory not found"
  fi
done

echo "WordPress file permissions have been configured for the production environment."
