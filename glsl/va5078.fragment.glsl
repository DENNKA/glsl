//AMB 2012
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
varying vec2 surfacePosition;
uniform vec2 resolution;
const float MAXITERATIONS = 170.0;
const float INCREMENT = 1.5;
const float pi = 3.1415926536;

/*
 *	- Use Left Mouse Button to move once you have clicked "hide code", and Right Mouse Button to Zoom
 *	- Zoom using the value below
 *	- Choose 1 from the dropdown menu above
 */

// User Variables ---------

const float 	START_ZOOM = 1.0; // Initial Zoom. Big => zoomed in;
const float 	SPEED = 2.0; // This is how fast the fractal becomes less "bloomed". Smaller => faster.
const vec2 	START = vec2(0.32, 0.61); // Starting coordinates

const vec3	COLOR_WEIGHT = vec3(4.0, 1.0, 2.5)/MAXITERATIONS; // Relative weights of the colours used in the fractal.

//-------------------------

void main( void ) {
	
	float x0 = surfacePosition.x / START_ZOOM + START.x;
	float y0 = surfacePosition.y / START_ZOOM + START.y;
	float x = 0.0;
	float y = 0.0;
	
	float count = 0.0;
	float limit = 20000.0;//(1.0 - sin(mod(time * 0.7, pi))) * 100.0 + 2.1;
	
	for (float i = 0.0; i < MAXITERATIONS; i += INCREMENT){
		
		
		if (distance(x, y) > limit) {break;}
		float t = 0.0;
		float xtemp = pow(x, 2.0) - pow(y, 2.0);
		
		y = (2.0*x*y) + y0;
		xtemp *= 1.0 + 0.0002*time*cos(i*0.3+(0.23*time));
		x = xtemp + x0;
		//x *= 1.0 + 0.00008*time*cos(MAXITERATIONS-i*0.26+(0.33*time));
		//y *= 1.0 + 0.00009*time*sin(MAXITERATIONS-i*0.29+(0.43*time));
		count += INCREMENT;
		
	}
	
	gl_FragColor = vec4(count*COLOR_WEIGHT.r, count*COLOR_WEIGHT.g, count*COLOR_WEIGHT.b, 1.0);
}