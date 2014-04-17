#ifdef GL_ES
precision mediump float;
#endif

#define M_PI 3.1415926535897932384626433832795
#define N 7.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	// This is a reimplementation of this thing:
	// http://mainisusuallyafunction.blogspot.no/2011/10/quasicrystals-as-sums-of-waves-in-plane.html
	
	// FORK
	// Optimised and edited by @Eiyeron.
	
	vec2 position = ( gl_FragCoord.xy ) / 2.0 + mouse * resolution*0.1;

	float color = 6.0;

	for (float i = 0.0; i < N; ++i) {
		float a = i * (4.0 * M_PI / N);
		color += cos( (position.x * cos(a) + position.y * sin(a)) + time ) / 0.5 + 0.5;
	}

	float m = mod(color * 1.0, time);
	color = m >= 1.0 ? 9.0-m : m;
	color = smoothstep(15.*abs(sin(time*1.24)), 25.*abs(cos(time/.9544)) + 15., m);
	gl_FragColor = vec4( vec3( color, 0.0, 0.2 ), 1.0 );

}
