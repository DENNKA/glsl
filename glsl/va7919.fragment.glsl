#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// 2013-03-17 by @hintz

void main(void)
{
	vec2 p = (gl_FragCoord.xy - 0.5 * resolution.xy) / resolution.yy;
	
	float r = length(p);
	float a = atan(p.y, p.x);
	float z = cos(3.0 * (a + r*3.0*cos(time) + sin(time)));
	float z2 = cos(4.0 * (a + r*3.0*cos(time*1.1) - sin(time*1.01)));
	
	vec3 col = vec3(floor((z*z2+r)*2.0), floor(1.0-sin(time+2.0*(r*z-z2))), floor((r+z2-z*r)*2.0));
	
	gl_FragColor.rgb = 1.0 - col;
}

