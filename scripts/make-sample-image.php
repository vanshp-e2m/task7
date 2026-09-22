<?php
/**
 * Generate the sample image used by the media-upload exercise.
 *
 * Kept in the repo so the practical can be re-run from a clean checkout
 * without hunting for a stock photo. Run with:
 *
 *     php scripts/make-sample-image.php
 *
 * @package E2M_REST_Lab
 */

declare( strict_types = 1 );

$width  = 1200;
$height = 630;
$output = __DIR__ . '/sample-image.png';

$image = imagecreatetruecolor( $width, $height );

if ( false === $image ) {
	fwrite( STDERR, "Could not create image canvas. Is the GD extension loaded?\n" );
	exit( 1 );
}

// Vertical gradient from deep indigo to teal, drawn one row at a time.
for ( $y = 0; $y < $height; $y++ ) {
	$ratio = $y / $height;
	$red   = (int) round( 22 + ( 8 * $ratio ) );
	$green = (int) round( 28 + ( 120 * $ratio ) );
	$blue  = (int) round( 68 + ( 70 * $ratio ) );

	$color = imagecolorallocate( $image, $red, $green, $blue );
	imagefilledrectangle( $image, 0, $y, $width, $y, $color );
}

// Faint diagonal grid so the image is obviously generated, not stock.
$grid = imagecolorallocatealpha( $image, 255, 255, 255, 112 );
for ( $x = -$height; $x < $width; $x += 48 ) {
	imageline( $image, $x, 0, $x + $height, $height, $grid );
}

$white = imagecolorallocate( $image, 255, 255, 255 );
$muted = imagecolorallocatealpha( $image, 255, 255, 255, 40 );

// imagestring() uses built-in bitmap fonts, so no font file is required.
imagestring( $image, 5, 72, 250, 'E2M REST LAB', $white );
imagestring( $image, 4, 72, 290, 'Uploaded via POST /wp-json/wp/v2/media', $muted );
imagestring( $image, 3, 72, 320, 'Module 9 - WordPress REST API practical', $muted );

if ( ! imagepng( $image, $output ) ) {
	fwrite( STDERR, "Failed to write {$output}\n" );
	exit( 1 );
}

imagedestroy( $image );

printf( "Wrote %s (%d bytes)%s", $output, (int) filesize( $output ), PHP_EOL );
