#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 distanceVector = gl_FragCoord.xy - mouse * resolution;
	float angle = atan(distanceVector.x, distanceVector.y) + time * .5 * (1. - 0.0001 * length(distanceVector));
	float isSolid = clamp(cos(angle*16.0 + 2. * sin(time * 5. - length(distanceVector) * 0.05)) * 100.0, 0.95, 1.0);
	gl_FragColor = vec4(144.0/255.0, 8.0/255.0, 78.0/255.0, 1.0) * isSolid;
}