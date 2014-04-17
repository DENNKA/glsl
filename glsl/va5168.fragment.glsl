#ifdef GL_ES
precision mediump float;
#endif

//tigrou (ind) 2012.08.30 (tigrou dot ind at gmail.com)
uniform float time;
uniform vec2 resolution;

float wheel(vec2 p,float t)
{
	
  vec2 m = vec2(mod(p.x,2.0)-1.0, mod(p.y,2.0)-1.0);
  
  float a = pow(sin(t + 4.0 * atan(m.y,m.x)), 3.0);
  float e = 0.355 + min(a * 0.28, 2.26*(0.5+0.5*sin(time)));
  float d = length(m);
	
  return d < e && d > 0.3 ? 1.0 - abs(sin(t+1.0*atan(m.y,m.x)*1.0))*0.25  : 0.0;   
}


const float PI = 3.14159265;
void main( void ) {

	vec2 p = (gl_FragCoord.xy / min(resolution.x, resolution.y))-0.5;
        p *= 5.0;
	
        float t = sin(time)*10.0;
	
	float r = wheel(p, t)+wheel(p+vec2(1.0,1.0), t);
	float g = wheel(p+vec2(1.0,0.0),-t+PI/2.0);
        float b = wheel(p+vec2(0.0,1.0),-t-PI/2.0)+g;
	
	gl_FragColor = vec4(r,0,b, 1.0);
}
