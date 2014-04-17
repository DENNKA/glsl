//Edit @ToBSn
// Edited by Anoki -changed some params
//

#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float getValue(vec2 p, float x2, float y2, float t)
{
  float x=p.x;
  float y=p.y;
  float cx = cos(x);
  float cy = cos(y);
  float theta=dot(x2, y2) * cx * cy;
  vec2 d = vec2(cos(theta), sin(theta)) + vec2(x, y);
  d *= vec2(y, y) * cos(p.y * (t * 0.1)) + dot(x,y);
  return length(d*theta);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) * 2.0 - vec2(1.0,resolution.y/resolution.x);
  	position *= 50.0;
  
  	float t = time + 1.0;

  	float a = 0.0;
  	a += getValue(position, tan(t)*.1, cos(t)*.2, t);
    	a *= getValue(position, sin(t)*.1, cos(t)*.2, t);
  	a += getValue(position, tan(t)*.1, cos(t)*.2, t);
  	a /= getValue(position, sin(t)*.1, cos(t)*.2, t);
  	a = 1./a;
  
  	float b = 0.0;
  	b += getValue(position, cos(t)*.1, sin(t)*.2, t);
    	b *= getValue(position, cos(t)*.1, sin(t)*.2, t);
  	b += getValue(position, cos(t)*.1, sin(t)*.2, t);
  	b /= getValue(position, cos(t)*.1, sin(t)*.2, t);
  	b = 1./b;
  
  	float c = 0.0;
  	c += getValue(position, sin(t)*.1, cos(t)*.2, t);
    	c *= getValue(position, sin(t)*.1, cos(t)*.2, t);
  	c += getValue(position, sin(t)*.1, cos(t)*.2, t);
  	c /= getValue(position, sin(t)*.1, cos(t)*.2, t);
  	c = 1./c;
  
	gl_FragColor = vec4( a, b, c, 1.0 );
}