#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float GetHeight( vec2 p )
{
	float height = sin( length( p + vec2( sin( time * 0.94 ), cos( time ) ) * 0.15 ) * 100.0 );
	height += sin( length( p + vec2( sin( time * 1.74 ), cos( time * 0.65 ) ) * 0.15 ) * 100.0 );
	height += sin( length( p + vec2( sin( time * 0.54 ), cos( time * 0.85 ) ) * 0.15 ) * 100.0 );
	return ( height / 3.0 ) * 0.05;

}

float arFix = 1.0 / resolution.x;

void main( void ) 
{
	vec2 centrePos = ( gl_FragCoord.xy - resolution.xy * 0.5 ) * arFix;
	vec2 rightPos = ( gl_FragCoord.xy + vec2( 0.5, 0.0 ) - resolution.xy * 0.5 ) * arFix;
	vec2 downPos = ( gl_FragCoord.xy + vec2( 0.0, 0.5 ) - resolution.xy * 0.5 ) * arFix;

	vec3 centre = vec3( centrePos, GetHeight( centrePos ) );
	vec3 right = vec3( rightPos, GetHeight( rightPos ) );
	vec3 down = vec3( downPos, GetHeight( downPos ) );

	vec3 normal = normalize( cross( right - centre, down - centre ) );

	vec3 light = vec3( sin( time ) * 0.5, cos( time * 1.13 ) * 0.125, 1.0 ) - centre;

	vec3 color = dot( normal, normalize( light ) ) * ( 1.0 / pow( length( light ), 128.0 ) ) * vec3( 1.0, 0.0, 0.0 );
	light = vec3( sin( time * 0.5 ) * 0.5, cos( time * 0.73 ) * 0.125, 1.0 ) - centre;
	color += dot( normal, normalize( light ) ) * ( 1.0 / pow( length( light ), 128.0 ) ) * vec3( 0.0, 1.0, 0.0 );
	light = vec3( sin( time * 1.34 ) * 0.5, cos( time * 0.93 ) * 0.125, 1.0 ) - centre;
	color += dot( normal, normalize( light ) ) * ( 1.0 / pow( length( light ), 128.0 ) ) * vec3( 0.0, 0.0, 1.0 );
	
	gl_FragColor = vec4( color, 0.1 );
}
