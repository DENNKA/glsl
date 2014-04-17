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
	float a = atan(floor(p.y*p.x), floor(p.x*p.y));
	float z = cos(3.0 * (a + r*3.0*cos(time) - sin(time)));
	float z2 = cos(4.0 * (a + r*3.0*cos(time*1.1) - sin(time*1.01)));
	

	float c1 = 0.0;
	float c2 = 1.0-sin(time+2.0*(r*z-z2));
	float c3 = (r+z2-z*r)*2.0;
	c3 = floor(c3*2.0);
	c2 = floor(c2*2.0);
	vec3 col = r*vec3(c1, c2, c3);		
	//vec3 col = r*vec3(0, 1.0-sin(time+2.0*(r*z-z2)), (r+z2-z*r)*2.0);	
	
	
	gl_FragColor.rgb = 1.0 - col;
}

