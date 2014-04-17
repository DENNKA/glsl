#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.1415926535
//#define PI2 (PI*2.0)

void main(void)
{
	float spinTime = 0.1;
	float spinTimeMultiply = 0.214;
	
	vec2 position = 100.0 * ((gl_FragCoord.xy) / resolution.y);
	
	float r = length(position);
	float a = atan(position.y, position.x);
	float d = r - a;// + PI;
	float n = PI * float(int(d / PI));
	float k = a + n ;
	
	spinTime = (spinTimeMultiply * time);
	
	float rand = sin(PI * floor((0.008) * k * n + (spinTime)));
	
	gl_FragColor.rgba = vec4(fract((time)*rand*vec3(0.32, 0.81, 0.83)), 1.0);
}

