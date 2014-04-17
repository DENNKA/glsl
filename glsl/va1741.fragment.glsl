/* lame-ass tunnel by kusma */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float th = atan(position.y, position.x) / (2.0 * 3.1415926) + 0.5;
	float dd = length(position);
	float d = 0.525 / dd + time;

	vec3 uv = vec3(th + d, th - d, th + tan(d) * 0.6);
	float a = 0.5 - sin(uv.x * 3.1415926 * 2.0) * 0.5;
	float b = 0.5 + sin(uv.y * 3.1415926 * 2.0) * 0.5;
	float c = 0.5 + sin(uv.z * 3.1415926 * 6.0) * 0.5;
	vec3 color = mix(vec3(1.0, 0.8, 0.9), vec3(0.1, 0.1, 0.2), pow(a, 0.2)) * 0.75;
	color += mix(vec3(0.8, 0.9, 1.0), vec3(0.1, 0.1, 0.2),  pow(b, 0.5)) * 0.75;
	color += mix(vec3(0.9, 0.8, 1.0), vec3(0.1, 0.2, 0.2),  pow(c, 0.1)) * 0.75;
	gl_FragColor = vec4(color * clamp(dd, 0.0, 1.0), 1.0);
}