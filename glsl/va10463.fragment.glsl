#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float timeScale = 1.2;


void main( void ) {
	float cycle = fract(time*timeScale);
	//cycle *= cycle;
	
	vec2 grid = vec2( 100, 200 );
	
	vec2 position = ( gl_FragCoord.xy / resolution.xy * grid ) - vec2(cycle,0);

	float color = 0.0;
	
	if ( mod(position.y,2.0) < 1.0 ) {
		if ( fract(position.x) < cycle ) color = 1.0;
	} else {
		if ( fract(position.x) > cycle ) color = 1.0;
	}
	
	if ( mod( floor(time*timeScale), 2.0) < 1.0 ) color = 1.0 - color;
		
	gl_FragColor = vec4( color, color, color, 1.0 );


}