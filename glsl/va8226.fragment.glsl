#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// just some squares by @hintz 2013-04-20

float squares(float modifier, float uniformity)
{
	float x = 0.03 * gl_FragCoord.x + time * modifier;
	float y = 0.03 * gl_FragCoord.y + time * 0.99 * modifier;
	float r = sin((sin(x) + sin(y)));
	return pow(r, uniformity);
}

void main(void)
{
	gl_FragColor = vec4(squares(2.0, 0.1), squares(3.0, 0.2), squares(5.0, 0.3), 1.0);
}
