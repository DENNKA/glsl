#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void
main(void)
{
	vec2 p = gl_FragCoord.xy / resolution.x * 30.0;
	
	p = vec2(mod(p.x, 3.0), mod(p.y, sqrt(3.0)));
	p = vec2(abs(p.x - 1.5), abs(p.y - sqrt(3.0)/2.0));
	p = p * mouse / 0.5;
	
	float z = -sqrt(3.0)*p.x + sqrt(3.0);
	
	float c = float(p.y < z);

	vec3 color = vec3(c);
	
	gl_FragColor = vec4(color, 1);

}