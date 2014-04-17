precision mediump float;

uniform float time;
uniform vec2 resolution;
uniform vec2 touch;

void main( void )
{
	float mx = max( resolution.x, resolution.y );
	vec2 uv = (gl_FragCoord.xy-resolution.xy*.5)/mx;

	float angle = .78539816339745;
	uv *= mat2(
		cos( angle ), -sin( angle ),
		sin( angle ), cos( angle ) );

	float fineness = mx*.4;
	float sy = uv.y*fineness;
	float c = fract(
		sin( floor( sy )/fineness*12.9898 )*
		437.5854 );

	// streak anti-aliasing
	float f = fract( sy );
	c *= min( f, 1.-f )*2.;

	// highlights
	c += sin( uv.y*31.415+time * .5 )*.5;

	// background
	float r = -uv.y+.5;
	float b = uv.y+.5;

	gl_FragColor = vec4(
		mix(
			vec3( touch.x, touch.y, r ),
			vec3( c ),
			.3 ),
		1.0 );
}
