

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define THICKNESS 0.05


float cubicPulse( float c, float w, float x )
{
    x = abs(x - c);
    if( x>w ) return 0.0;
    x /= w;
    return 1.0 - x*x*(3.0-2.0*x);
}

float drawGraph(vec2 pos, float env) {
	if ((pos.y < env + THICKNESS) && (pos.y > env - THICKNESS)) {
		return 1.0;	
	}
	return 0.0;
}

void main( void ) {
	vec3 color = vec3(0.0);
	float PI = 3.1415926535897932384626433; 
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position = position * vec2(2.0) - vec2(1.0); 	

	color += drawGraph(position, 0.25 * sin(position.x * mod(time, 10.0) + time * 100.0)); 

	gl_FragColor = vec4(color,1.0);
}