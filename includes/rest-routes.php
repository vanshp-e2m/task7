<?php
/**
 * Custom REST API routes.
 *
 * Registers `GET /wp-json/e2m/v1/projects/count`, which reports how many
 * projects exist in a given status. The route exists mainly to demonstrate a
 * permission callback that actually denies people: anonymous callers get a
 * 401 and logged-in users without `edit_posts` get a 403.
 *
 * @package E2M_REST_Lab
 */

declare( strict_types = 1 );

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

const E2M_REST_NAMESPACE = 'e2m/v1';

/**
 * Register the plugin's custom REST routes.
 *
 * @return void
 */
function e2m_rest_lab_register_routes(): void {
	register_rest_route(
		E2M_REST_NAMESPACE,
		'/projects/count',
		array(
			array(
				'methods'             => WP_REST_Server::READABLE,
				'callback'            => 'e2m_rest_lab_get_projects_count',

				// NEVER `__return_true` here. This callback is the only thing
				// standing between this data and the open internet.
				'permission_callback' => 'e2m_rest_lab_projects_count_permission',
				'args'                => array(
					'status' => array(
						'description'       => 'Post status to count. Defaults to publish.',
						'type'              => 'string',
						'default'           => 'publish',
						'enum'              => array( 'publish', 'draft', 'pending', 'private', 'future' ),
						'sanitize_callback' => 'sanitize_key',

						// register_rest_route() does NOT add a validate_callback for
						// you. Without this line the `enum` above is documentation
						// only, and ?status=nonsense sails through to the handler.
						'validate_callback' => 'rest_validate_request_arg',
					),
				),
			),
			'schema' => 'e2m_rest_lab_projects_count_schema',
		)
	);
}
add_action( 'rest_api_init', 'e2m_rest_lab_register_routes' );

/**
 * Decide whether the current request may read the project count.
 *
 * Two separate failures are reported separately, because they mean different
 * things to a client: 401 says "you did not authenticate", 403 says "we know
 * who you are and you still may not do this".
 *
 * @param WP_REST_Request $request The incoming request.
 * @return true|WP_Error True when allowed, WP_Error describing the refusal otherwise.
 */
function e2m_rest_lab_projects_count_permission( WP_REST_Request $request ) {
	unset( $request ); // Not needed to make the decision, but kept for signature clarity.

	if ( ! is_user_logged_in() ) {
		return new WP_Error(
			'e2m_rest_not_authenticated',
			__( 'You must be authenticated to read the project count.', 'e2m-rest-lab' ),
			array( 'status' => 401 )
		);
	}

	if ( ! current_user_can( 'edit_posts' ) ) {
		return new WP_Error(
			'e2m_rest_forbidden',
			__( 'Your account does not have permission to read the project count.', 'e2m-rest-lab' ),
			array( 'status' => 403 )
		);
	}

	return true;
}

/**
 * Return the number of projects in the requested status.
 *
 * @param WP_REST_Request $request The incoming request.
 * @return WP_REST_Response The count payload.
 */
function e2m_rest_lab_get_projects_count( WP_REST_Request $request ): WP_REST_Response {
	$status = (string) $request->get_param( 'status' );

	// wp_count_posts() is a single cached query, far cheaper than running a
	// WP_Query and counting the returned posts.
	$counts = wp_count_posts( E2M_PROJECT_POST_TYPE );
	$count  = isset( $counts->$status ) ? (int) $counts->$status : 0;

	return new WP_REST_Response(
		array(
			'post_type'   => E2M_PROJECT_POST_TYPE,
			'status'      => $status,
			'count'       => $count,
			'generated_at'=> current_time( 'c' ),
			'requested_by'=> wp_get_current_user()->user_login,
		),
		200
	);
}

/**
 * Describe the response shape so the route self-documents via OPTIONS.
 *
 * @return array<string, mixed> JSON Schema for the count response.
 */
function e2m_rest_lab_projects_count_schema(): array {
	return array(
		'$schema'    => 'http://json-schema.org/draft-04/schema#',
		'title'      => 'e2m_projects_count',
		'type'       => 'object',
		'properties' => array(
			'post_type'    => array(
				'description' => 'The post type that was counted.',
				'type'        => 'string',
			),
			'status'       => array(
				'description' => 'The post status that was counted.',
				'type'        => 'string',
			),
			'count'        => array(
				'description' => 'Number of matching posts.',
				'type'        => 'integer',
			),
			'generated_at' => array(
				'description' => 'ISO-8601 timestamp of the response, in site time.',
				'type'        => 'string',
				'format'      => 'date-time',
			),
			'requested_by' => array(
				'description' => 'Login of the authenticated user that made the request.',
				'type'        => 'string',
			),
		),
	);
}
