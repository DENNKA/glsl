#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform vec2 mouse;
uniform float time;
uniform sampler2D tex;

#define GRID_SIZE 1
#define PI 3.1416

vec3 color(float d) {
	return d * vec3(0, 1, 0);	
}

int mod(int a, int b) {
	return a - ((a / b) * b);
}

void main(void)
{
	vec2 p = (-1.0 + 2.0 * ((gl_FragCoord.xy) / resolution.xy));
	//p -= (2.0 * mouse.xy) - vec2(1.0);
	p.x *= (resolution.x / resolution.y);
	vec2 uv;

	float a = (atan(p.y,p.x) + time);
	float r = sqrt(dot(p,p));

	uv.x = 0.1/r;
	uv.y = a/(PI);
	
	float len = dot(p,p);
	
	vec3 col = color(pow(fract(uv.y / -2.0), 10.0));
	if (len > 0.7) col = vec3(0.8,0.8,0.8);
	if (len > 0.73) col = vec3(0,0,0);
	

	gl_FragColor = vec4(col, 1.0);
}