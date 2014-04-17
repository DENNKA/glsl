// Antialiased mandelbrot set by Kabuto

// Set quality to 1 (or even 0.5)

// See 1603.4 for a version that renders julia sets instead

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int MAX_ITER =50;

const float ANTIALIAS = 2.5; // .5 = smoother but wider

float point(vec2 s) {
	vec4 a = vec4(s,1,0);
	vec2 m = mouse*vec2(.2,-.02)+vec2(.89,1.01);
	vec4 c = vec4(s,1,0) * vec4(m,m);
	
	for(int iter = 0; iter < MAX_ITER; iter++) {	
		// Testing every 4th iteration is enough for not getting float overflow and makes this routine much faster
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		a = a.x*a*vec4(1,1,2,2)+a.y*a.yxwz*vec4(-1,1,-2,2)+c;
		if(a.x*a.x+a.y*a.y > 16.) {
			return length(a.zw)/length(a.xy)/log(length(a.xy));
		}
	}
	return 1e10;

}
 
void main( void ) {
	float zoom = .004;
	
	vec2 p = (( gl_FragCoord.xy / resolution.xy - .5))*vec2(resolution.x/resolution.y, 1.) * 2. * zoom + vec2(-.043,.9865);
	
	float z = ANTIALIAS/(point(p)*zoom/resolution.y);
	gl_FragColor = vec4(vec3(z)*vec3(0.15,0.5,1.0), 1.);
}
