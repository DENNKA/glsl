
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xx );
	vec2 ms = mouse;
	ms *= resolution.xy;
	ms /= resolution.xx;
	float d = distance(position,ms) * 0.6;
	float color = (d < sin(time + (position.x * position.y * 80.0) - position.y * 80.0) * 1.1 + 0.1) ? 1.0 - d * 5.0 : 0.0;
		
	gl_FragColor = vec4( vec3(color,color * 2.,  color * 3.), 1.0 );

}