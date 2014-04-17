#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 1024.;

	float color = 0.0;
	color += sin( position.x - cos( time / 15.0 ) * 80.0 ) + cos( position.y * sin( time /2. ) * 10.0 );

	gl_FragColor = vec4( vec3( color, color * 0.1, sin( color + time ) * 0.75 ), 1.0 );

}