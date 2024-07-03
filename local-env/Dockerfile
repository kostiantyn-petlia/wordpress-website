# Dockerfile
#
# https://hub.docker.com/_/wordpress
#
# [1] It is used in the .htaccess file. (Use 'apachectl -M' to get the list of modules.)
# [2] We use git to install Xdebug below and Vim can help us to edit files inside a docker container.
# [3] See https://xdebug.org/docs/install for datails
#     and available branches of XDebug could be seen here: https://github.com/xdebug/xdebug/branches.
# [4] Copy xdebug.ini to /usr/local/etc/php/conf.d/.
# [5] Since this Dockerfile extends the official Docker image `wordpress`,
#     and since `wordpress`, in turn, extends the official Docker image `php`,
#     the helper script docker-php-ext-enable (defined for image `php`)
#     works here, and we can use it to enable xdebug.

ARG WORDPRESS_VERSION=6.5.5-php8.2-apache
ARG XDEBUG_BRANCH=xdebug_3_3

FROM  wordpress:${WORDPRESS_VERSION}

# Enable the mod_headers Apache module [1]
RUN ln -s /etc/apache2/mods-available/headers.load /etc/apache2/mods-enabled/

# Install git and vim [2]
RUN apt-get update && apt-get install -y git vim

# Install Xdebug from source [3]
RUN cd /tmp \
    && git clone https://github.com/xdebug/xdebug.git \
    && cd xdebug \
    && git checkout ${XDEBUG_BRANCH} \
    && phpize \
    && ./configure --enable-xdebug \
    && make \
    && make install \
    && rm -rf /tmp/xdebug

# Copy custom configuration files
COPY files-to-copy/ /

# Enable Xdebug
RUN docker-php-ext-enable xdebug

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
