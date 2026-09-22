<?php
/**
 * Front-end rendering for the `page_sections` Flexible Content field.
 *
 * Twenty Twenty-Five is a block theme, so there is no classic `page.php` to
 * drop a loop into. Hooking `the_content` works in both block and classic
 * themes because the core/post-content block runs the same filter, which keeps
 * this renderer theme-independent.
 *
 * @package E2M_REST_Lab
 */

declare( strict_types = 1 );

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Append rendered ACF sections beneath the normal post content.
 *
 * @param string $content The post content as filtered so far.
 * @return string Content with the rendered sections appended.
 */
function e2m_rest_lab_append_sections( string $content ): string {
	// The WYSIWYG sub-field re-enters `the_content`, so guard against recursion.
	static $is_rendering = false;

	if ( $is_rendering ) {
		return $content;
	}

	if ( ! function_exists( 'have_rows' ) ) {
		return $content;
	}

	if ( ! is_singular( array( 'page', E2M_PROJECT_POST_TYPE ) ) || ! is_main_query() || ! in_the_loop() ) {
		return $content;
	}

	$post_id = get_the_ID();

	if ( ! $post_id || ! have_rows( 'page_sections', $post_id ) ) {
		return $content;
	}

	$is_rendering = true;

	wp_enqueue_style( 'e2m-rest-lab-sections' );

	ob_start();
	echo '<div class="e2m-sections">';

	while ( have_rows( 'page_sections', $post_id ) ) {
		the_row();

		switch ( get_row_layout() ) {
			case 'hero':
				e2m_rest_lab_render_hero();
				break;
			case 'text_block':
				e2m_rest_lab_render_text_block();
				break;
			case 'media_text':
				e2m_rest_lab_render_media_text();
				break;
		}
	}

	echo '</div>';
	$sections = (string) ob_get_clean();

	$is_rendering = false;

	return $content . $sections;
}
add_filter( 'the_content', 'e2m_rest_lab_append_sections', 20 );

/**
 * Register (but do not force-load) the section stylesheet.
 *
 * Registering on `wp_enqueue_scripts` and enqueuing only while rendering keeps
 * the CSS off pages that have no sections.
 *
 * @return void
 */
function e2m_rest_lab_register_assets(): void {
	wp_register_style(
		'e2m-rest-lab-sections',
		E2M_REST_LAB_URL . 'assets/sections.css',
		array(),
		E2M_REST_LAB_VERSION
	);
}
add_action( 'wp_enqueue_scripts', 'e2m_rest_lab_register_assets' );

/**
 * Render the "Hero" layout for the current flexible-content row.
 *
 * @return void
 */
function e2m_rest_lab_render_hero(): void {
	$heading    = (string) get_sub_field( 'heading' );
	$subheading = (string) get_sub_field( 'subheading' );
	$image_id   = (int) get_sub_field( 'background_image' );
	$cta_label  = (string) get_sub_field( 'cta_label' );
	$cta_url    = (string) get_sub_field( 'cta_url' );

	$background = $image_id ? wp_get_attachment_image_url( $image_id, 'full' ) : '';
	$style      = $background ? sprintf( ' style="background-image:url(%s)"', esc_url( $background ) ) : '';

	printf(
		'<section class="e2m-section e2m-section--hero%s"%s>',
		$background ? ' has-background' : '',
		$style // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped -- built from esc_url above.
	);

	echo '<div class="e2m-section__inner">';

	if ( $heading ) {
		printf( '<h2 class="e2m-section__heading">%s</h2>', esc_html( $heading ) );
	}

	if ( $subheading ) {
		printf( '<p class="e2m-section__subheading">%s</p>', esc_html( $subheading ) );
	}

	if ( $cta_label && $cta_url ) {
		printf(
			'<a class="e2m-section__cta" href="%s">%s</a>',
			esc_url( $cta_url ),
			esc_html( $cta_label )
		);
	}

	echo '</div></section>';
}

/**
 * Render the "Text Block" layout for the current flexible-content row.
 *
 * @return void
 */
function e2m_rest_lab_render_text_block(): void {
	$heading   = (string) get_sub_field( 'heading' );
	$body      = (string) get_sub_field( 'body' );
	$alignment = (string) get_sub_field( 'alignment' );

	printf(
		'<section class="e2m-section e2m-section--text is-aligned-%s"><div class="e2m-section__inner">',
		esc_attr( $alignment ? $alignment : 'left' )
	);

	if ( $heading ) {
		printf( '<h2 class="e2m-section__heading">%s</h2>', esc_html( $heading ) );
	}

	if ( $body ) {
		// The WYSIWYG value is already sanitised on save by ACF and by the REST
		// controller, so wp_kses_post is the right level of escaping here.
		printf( '<div class="e2m-section__body">%s</div>', wp_kses_post( wpautop( $body ) ) );
	}

	echo '</div></section>';
}

/**
 * Render the "Media and Text" layout for the current flexible-content row.
 *
 * @return void
 */
function e2m_rest_lab_render_media_text(): void {
	$heading  = (string) get_sub_field( 'heading' );
	$body     = (string) get_sub_field( 'body' );
	$image_id = (int) get_sub_field( 'image' );
	$position = (string) get_sub_field( 'image_position' );

	printf(
		'<section class="e2m-section e2m-section--media-text is-image-%s"><div class="e2m-section__inner">',
		esc_attr( $position ? $position : 'left' )
	);

	if ( $image_id ) {
		printf(
			'<figure class="e2m-section__media">%s</figure>',
			wp_get_attachment_image( $image_id, 'large', false, array( 'loading' => 'lazy' ) ) // phpcs:ignore WordPress.Security.EscapeOutput.OutputNotEscaped -- core returns escaped markup.
		);
	}

	echo '<div class="e2m-section__text">';

	if ( $heading ) {
		printf( '<h2 class="e2m-section__heading">%s</h2>', esc_html( $heading ) );
	}

	if ( $body ) {
		printf( '<p class="e2m-section__body">%s</p>', esc_html( $body ) );
	}

	echo '</div></div></section>';
}
