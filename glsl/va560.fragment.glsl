#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getValue(vec2 p, vec2 p2, float cmin, float cmax)
{
  p -= p2;
  float r=(cmax-cmin) + cmin;
  return abs(r-length(p));  
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);

  	float sint = sin(time);
  	float cost = cos(time);
  
  	float color = 0.0;
  	color += getValue(position, vec2(sint*.1, sint*.2), .3, .4);
  	color *= getValue(position, vec2(cost*.2, cost*.1), .3, .4);  
  	color *= getValue(position, vec2(cost*.3, sint*.2), .3, .4);
    	color *= getValue(position, vec2(sint*.4, cost*.1), .3, .4);
  	color = 1./color*.00003;
  
	gl_FragColor = vec4( vec3( color, color*.5, color ), 1.0 );
}

