<?php
/**
 * Plugin Name:       E2M REST Lab
 * Plugin URI:        https://github.com/e2m/e2m-rest-lab
 * Description:       Module 9 practical: a `project` custom post type exposed to the REST API, an ACF Flexible Content field group (`page_sections`) that can be written over REST, a front-end renderer for those sections, and a custom `e2m/v1/projects/count` route guarded by a real permission callback.
 * Version:           1.0.0
 * Requires at least: 6.4
 * Requires PHP:      8.0
 * Author:            Vansh Patel
 * License:           GPL-2.0-or-later
 * Text Domain:       e2m-rest-lab
 *
 * @package E2M_REST_Lab
 */

declare( strict_types = 1 );

if ( ! defined( 'ABSPATH' ) ) {
	exit; // No direct access.
}

define( 'E2M_REST_LAB_VERSION', '1.0.0' );
define( 'E2M_REST_LAB_PATH', plugin_dir_path( __FILE__ ) );
define( 'E2M_REST_LAB_URL', plugin_dir_url( __FILE__ ) );

require_once E2M_REST_LAB_PATH . 'includes/post-types.php';
require_once E2M_REST_LAB_PATH . 'includes/acf-field-groups.php';
require_once E2M_REST_LAB_PATH . 'includes/rest-routes.php';
require_once E2M_REST_LAB_PATH . 'includes/render-sections.php';

/**
 * Flush rewrite rules on activation so the `project` CPT archive and its
 * REST route resolve immediately instead of 404-ing until permalinks are saved.
 *
 * @return void
 */
function e2m_rest_lab_activate(): void {
	e2m_rest_lab_register_project_cpt();
	flush_rewrite_rules();
}
register_activation_hook( __FILE__, 'e2m_rest_lab_activate' );

/**
 * Clean up rewrite rules when the plugin is switched off.
 *
 * @return void
 */
function e2m_rest_lab_deactivate(): void {
	flush_rewrite_rules();
}
register_deactivation_hook( __FILE__, 'e2m_rest_lab_deactivate' );
