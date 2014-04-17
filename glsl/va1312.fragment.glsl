//created by nikoclass

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


float rand (float x) {
	return fract(sin(x * 24614.63) * 36817.342);	
}

float wave (in vec2 p, in vec2 dir, in float size) {
	dir += vec2(rand(size)) - vec2(0.5);
	return sin(dot(p, dir) / (size + rand(size)) + time) * (size + rand(size));		
}

float f(in vec2 p){
	p *= 80.0;
	
	float res = 0.0;
	res += wave (p, vec2(0.0, 1.0), 8.0);
	res += wave (p, vec2(-1.0, -1.0), 7.0);
	res += wave (p, vec2(0.0, -1.0), 6.0);
	res += wave (p, vec2(0.0, 1.0), 5.0);
	res += wave (p, vec2(1.0, 0.0), 4.0);
	res += wave (p, vec2(-1.0, 0.0), 3.0);
	res += wave (p, vec2(-1.0, 1.0), 2.0);
	res += wave (p, vec2(1.0, 1.0), 1.0);
		
	return res * 0.1;
}

void main( void ) {
	vec2 p = (gl_FragCoord.xy / resolution.xy );
	float c = f(p);
	gl_FragColor = vec4(c, c, 1.0, 1.0);

}