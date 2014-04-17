#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float th = atan(position.y, position.x) / (3.0 * .1415926) + 1.5 + mouse.x;
	float dd = length(position);
	float d = 5.5 * dd + time + mouse.y;

	vec3 uv = vec3(th + d, th - d, th + sin(d) * 0.1);
	float a = -0.5 + cos(uv.x * 7.1415926 * 19.0) * 0.75;
	float b = 997.5 + cos(uv.y * 3.1415926 * 2.0) * 0.75;
	float c = 2.5 + cos(uv.z * 2.1415926 * 6.0) * 0.75;
	vec3 color = mix(vec3(0.0, 0.5, 0.2), vec3(0.1, 0.1, 0.2), pow(a, 0.2)) * 3.;
	color += mix(vec3(0.8, 0.9, 1.0), vec3(0.1, 0.1, 0.2),  pow(b, 0.1)) * 0.75;
	color += mix(vec3(0.9, 0.8, 1.0), vec3(0.1, 0.2, 0.2),  pow(c, 0.1)) * 1.75;
	gl_FragColor = vec4(color * clamp(dd, 0.0, 0.8), 1.0);
}