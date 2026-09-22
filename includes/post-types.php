<?php
/**
 * Custom post type registration.
 *
 * The `project` CPT is the object the Module 9 exercises read, count and
 * write over the REST API, so every setting here that affects REST visibility
 * is deliberate and commented.
 *
 * @package E2M_REST_Lab
 */

declare( strict_types = 1 );

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

const E2M_PROJECT_POST_TYPE = 'project';
const E2M_PROJECT_REST_BASE = 'projects';

/**
 * Register the `project` custom post type and expose it to the REST API.
 *
 * `show_in_rest` is what makes the type appear in the /wp-json/ index and
 * gives it a /wp/v2/projects collection. Without it the CPT exists in
 * wp-admin but is invisible to every REST client, which is the exact failure
 * the "Explore" exercise asks you to spot and fix.
 *
 * @return void
 */
function e2m_rest_lab_register_project_cpt(): void {
	$labels = array(
		'name'               => __( 'Projects', 'e2m-rest-lab' ),
		'singular_name'      => __( 'Project', 'e2m-rest-lab' ),
		'add_new_item'       => __( 'Add New Project', 'e2m-rest-lab' ),
		'edit_item'          => __( 'Edit Project', 'e2m-rest-lab' ),
		'new_item'           => __( 'New Project', 'e2m-rest-lab' ),
		'view_item'          => __( 'View Project', 'e2m-rest-lab' ),
		'search_items'       => __( 'Search Projects', 'e2m-rest-lab' ),
		'not_found'          => __( 'No projects found', 'e2m-rest-lab' ),
		'all_items'          => __( 'All Projects', 'e2m-rest-lab' ),
		'menu_name'          => __( 'Projects', 'e2m-rest-lab' ),
	);

	register_post_type(
		E2M_PROJECT_POST_TYPE,
		array(
			'labels'       => $labels,
			'public'       => true,
			'has_archive'  => true,
			'menu_icon'    => 'dashicons-portfolio',
			'menu_position'=> 20,
			'supports'     => array( 'title', 'editor', 'excerpt', 'thumbnail', 'revisions', 'custom-fields', 'author' ),
			'rewrite'      => array( 'slug' => 'projects', 'with_front' => false ),
			'taxonomies'   => array( 'category', 'post_tag' ),

			// REST exposure. These three lines are the whole point of the CPT here.
			'show_in_rest' => true,
			'rest_base'    => E2M_PROJECT_REST_BASE,
			'rest_controller_class' => 'WP_REST_Posts_Controller',
		)
	);
}
add_action( 'init', 'e2m_rest_lab_register_project_cpt' );
