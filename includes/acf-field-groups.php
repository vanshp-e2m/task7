<?php
/**
 * ACF field group registration.
 *
 * The `page_sections` Flexible Content field is registered in PHP rather than
 * clicked together in the ACF UI so that the schema lives in version control
 * and deploys with the plugin. `'show_in_rest' => 1` is the PHP equivalent of
 * flipping "Show in REST API" on the field group settings screen, and it is
 * what allows an `acf` object to be sent in a REST POST body.
 *
 * @package E2M_REST_Lab
 */

declare( strict_types = 1 );

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Build the sub-fields for the "Hero" layout.
 *
 * @return array<int, array<string, mixed>> ACF sub-field definitions.
 */
function e2m_rest_lab_hero_sub_fields(): array {
	return array(
		array(
			'key'      => 'field_hero_heading',
			'label'    => 'Heading',
			'name'     => 'heading',
			'type'     => 'text',
			'required' => 1,
		),
		array(
			'key'   => 'field_hero_subheading',
			'label' => 'Subheading',
			'name'  => 'subheading',
			'type'  => 'textarea',
			'rows'  => 3,
		),
		array(
			'key'           => 'field_hero_background_image',
			'label'         => 'Background Image',
			'name'          => 'background_image',
			'type'          => 'image',
			// `id` keeps the REST payload symmetrical: GET returns an attachment
			// ID and POST accepts the same attachment ID.
			'return_format' => 'id',
			'preview_size'  => 'medium',
			'library'       => 'all',
		),
		array(
			'key'   => 'field_hero_cta_label',
			'label' => 'Button Label',
			'name'  => 'cta_label',
			'type'  => 'text',
		),
		array(
			'key'   => 'field_hero_cta_url',
			'label' => 'Button URL',
			'name'  => 'cta_url',
			'type'  => 'url',
		),
	);
}

/**
 * Build the sub-fields for the "Text Block" layout.
 *
 * @return array<int, array<string, mixed>> ACF sub-field definitions.
 */
function e2m_rest_lab_text_block_sub_fields(): array {
	return array(
		array(
			'key'   => 'field_text_block_heading',
			'label' => 'Heading',
			'name'  => 'heading',
			'type'  => 'text',
		),
		array(
			'key'          => 'field_text_block_body',
			'label'        => 'Body',
			'name'         => 'body',
			'type'         => 'wysiwyg',
			'tabs'         => 'all',
			'media_upload' => 1,
		),
		array(
			'key'           => 'field_text_block_alignment',
			'label'         => 'Text Alignment',
			'name'          => 'alignment',
			'type'          => 'select',
			'choices'       => array(
				'left'   => 'Left',
				'center' => 'Center',
			),
			'default_value' => 'left',
			'return_format' => 'value',
		),
	);
}

/**
 * Build the sub-fields for the "Media and Text" layout.
 *
 * @return array<int, array<string, mixed>> ACF sub-field definitions.
 */
function e2m_rest_lab_media_text_sub_fields(): array {
	return array(
		array(
			'key'   => 'field_media_text_heading',
			'label' => 'Heading',
			'name'  => 'heading',
			'type'  => 'text',
		),
		array(
			'key'   => 'field_media_text_body',
			'label' => 'Body',
			'name'  => 'body',
			'type'  => 'textarea',
			'rows'  => 4,
		),
		array(
			'key'           => 'field_media_text_image',
			'label'         => 'Image',
			'name'          => 'image',
			'type'          => 'image',
			// This is the sub-field that receives the attachment ID returned by
			// POST /wp/v2/media in the "Upload media" exercise.
			'return_format' => 'id',
			'preview_size'  => 'medium',
			'library'       => 'all',
		),
		array(
			'key'           => 'field_media_text_image_position',
			'label'         => 'Image Position',
			'name'          => 'image_position',
			'type'          => 'select',
			'choices'       => array(
				'left'  => 'Left',
				'right' => 'Right',
			),
			'default_value' => 'left',
			'return_format' => 'value',
		),
	);
}

/**
 * Register the `page_sections` Flexible Content field group.
 *
 * Runs on `acf/init` so it is safe when ACF is inactive: the hook simply
 * never fires and the rest of the plugin keeps working.
 *
 * @return void
 */
function e2m_rest_lab_register_field_groups(): void {
	if ( ! function_exists( 'acf_add_local_field_group' ) ) {
		return;
	}

	acf_add_local_field_group(
		array(
			'key'          => 'group_page_sections',
			'title'        => 'Page Sections',
			'fields'       => array(
				array(
					'key'          => 'field_page_sections',
					'label'        => 'Page Sections',
					'name'         => 'page_sections',
					'type'         => 'flexible_content',
					'instructions' => 'Build the page from stackable sections. Sections can be reordered here or written over the REST API.',
					'button_label' => 'Add Section',
					'layouts'      => array(
						'layout_hero'       => array(
							'key'        => 'layout_hero',
							'name'       => 'hero',
							'label'      => 'Hero',
							'display'    => 'block',
							'min'        => '',
							'max'        => '',
							'sub_fields' => e2m_rest_lab_hero_sub_fields(),
						),
						'layout_text_block' => array(
							'key'        => 'layout_text_block',
							'name'       => 'text_block',
							'label'      => 'Text Block',
							'display'    => 'block',
							'min'        => '',
							'max'        => '',
							'sub_fields' => e2m_rest_lab_text_block_sub_fields(),
						),
						'layout_media_text' => array(
							'key'        => 'layout_media_text',
							'name'       => 'media_text',
							'label'      => 'Media and Text',
							'display'    => 'block',
							'min'        => '',
							'max'        => '',
							'sub_fields' => e2m_rest_lab_media_text_sub_fields(),
						),
					),
				),
			),
			'location'     => array(
				array(
					array(
						'param'    => 'post_type',
						'operator' => '==',
						'value'    => 'page',
					),
				),
				array(
					array(
						'param'    => 'post_type',
						'operator' => '==',
						'value'    => 'project',
					),
				),
			),
			'menu_order'      => 0,
			'position'        => 'normal',
			'style'           => 'default',
			'label_placement' => 'top',
			'active'          => true,
			'description'     => 'Flexible page builder sections, readable and writable over the WordPress REST API.',

			// The single most important line for this module: without it the
			// `acf` key is neither returned by GET nor accepted by POST.
			'show_in_rest'    => 1,
		)
	);
}
add_action( 'acf/init', 'e2m_rest_lab_register_field_groups' );
