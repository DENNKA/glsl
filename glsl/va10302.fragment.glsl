#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float PI = 3.14159;
const float RADIUS = 60.;

const float CELL_SIZE = 8.;
const float CELL_THICK = 1.;
const float CELL_RADIUS = .5*CELL_SIZE - CELL_THICK;

float
squared_distance(const in vec2 a, const in vec2 b)
{
	vec2 d = a - b;
	return dot(d, d);
}

float
add_blob(const in vec2 center)
{
	return 1.5e5/(1. + squared_distance(gl_FragCoord.xy, center));
}

void main(void)
{
	vec2 origin  = .5*resolution;
	float v =
		add_blob(origin + vec2(60.*sin(.1 + 0.6*time), 80.*cos(.7 + 1.8*time))) +
		add_blob(origin + vec2(70.*cos(.2 + 1.1*time), 70.*sin(.5 + 2.2*time))) +
		add_blob(origin + vec2(80.*sin(.3 + 1.6*time), 60.*cos(.3 + 1.6*time)));	
	float w = v - RADIUS;
	
	float r = pow(1. + pow(w, 2.), -.2)*CELL_RADIUS;

	vec2 offs = vec2(step(CELL_SIZE, mod(gl_FragCoord.y, 2.*CELL_SIZE))*.5*CELL_SIZE, 0);
	vec2 cell_center = offs + CELL_SIZE*floor((gl_FragCoord.xy - offs)/CELL_SIZE) + .5*vec2(CELL_SIZE, CELL_SIZE);
	float d = distance(gl_FragCoord.xy, cell_center);
	float c = smoothstep(r + CELL_THICK, r, d);
	
	gl_FragColor = vec4(c, c, c, 1);
}