<?php
/**
 * Plugin Name: PHP Error Reporting Level
 * Description: Disables "PHP Deprecated" messages.
 * Version:     1.0.0
 * Author:      Kostiantyn Petlia
 * License:     GNU General Public License v3 or later
 * License URI: http://www.gnu.org/licenses/gpl-3.0.html
 */

defined('ABSPATH') || exit;

// TODO Remove the plugin when WordPress & plugins are support PHP 8.3 well.

/*
 * Disable "PHP Deprecated:" messages.
 *
 * IMPORTANT:
 * WordPress 6.4 is compatible with exceptions with PHP 8.0, PHP 8.1, and PHP 8.2,
 * and beta compatible with PHP 8.3.
 *
 * What “compatible with exceptions” means?
 *
 * PHP 8.0
 *  - Named parameters. WordPress does not support named parameters.
 *  - Filesystem WP_Filesystem_FTPext and WP_Filesystem_SSH2 when connect fails.
 *
 * PHP 8.1
 *  - Not all “passing null to non-nullable” issues have been found.
 *  - htmlentities() et al needs the default value of the flags parameter explicitly set.
 *  - Replace most strip_tags() with wp_strip_tags().
 *
 * PHP 8.2
 *  - utf8_{encode|decode} deprecation with pending decision on requiring a PHP extension.
 *  - Unknown dynamic properties deprecations.
 *
 * @link https://make.wordpress.org/hosting/handbook/server-environment/#php
 */
if (defined('WP_DEBUG') && WP_DEBUG) {
    error_reporting(E_ALL ^ E_DEPRECATED);
}
