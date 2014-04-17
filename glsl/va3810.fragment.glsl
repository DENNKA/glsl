
// toying with Perlin noise with http://glsl.heroku.com/e#3801.4 as a base.
// e4r

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float PI = 3.14159265359;

float timeScale = 0.2; 		// Slow down time a little.
float zoom = 1.0;
/*
	noise related
*/
vec3 permute(vec3 x) { return mod(((x*34.0)+1.0)*x, 289.0); }
// Perlin simplex noise
float snoise(vec2 v)
  {
  const vec4 C = vec4(0.211324865405187, 0.366025403784439,
					 -0.577350269189626, 0.024390243902439);
  vec2 i  = floor(v + dot(v, C.yy) );
  vec2 x0 = v -   i + dot(i, C.xx);
  vec2 i1;
  i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
//  i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
//  i1.y = 1.0 - i1.x;
  vec4 x12 = x0.xyxy + C.xxzz;
  x12.xy -= i1;
  i = mod(i, 289.0);
  vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
	+ i.x + vec3(0.0, i1.x, 1.0 ));
  vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy),
    dot(x12.zw,x12.zw)), 0.0);
  m = m*m ;
  m = m*m ;
  vec3 x = 2.0 * fract(p * C.www) - 1.0;
  vec3 h = abs(x) - 0.5;
  vec3 ox = floor(x + 0.5);
  vec3 a0 = x - ox;
  m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );
  vec3 g;
  g.x  = a0.x  * x0.x  + h.x  * x0.y;
  g.yz = a0.yz * x12.xz + h.yz * x12.yw;
  return 130.0 * dot(m, g);
}

float fbm( vec2 p)
{
	float f=0.0;
	
	f += 0.5000*snoise(p); p*=2.02;
	f += 0.2500*snoise(p); p*=2.03;
	f += 0.1250*snoise(p); p*=2.01;
	f += 0.0625*snoise(p); p*=2.04;
	f /= 0.9375;
	return f;
}

// --- end of noise code


// l:  Wave length
// f:  Frequency
vec2 calculateParams(vec2 a) {	
	return vec2(  
		2.0 * PI * a.x,	// Angular frequency		
	        2.0 * PI / a.y ); // Wave number		
}
	
void main() {
	
	float y0 = 0.15; // amplitude
	
	// Normalize and center coord
	float scale = resolution.y / zoom;
	vec2 pos = (gl_FragCoord.xy / scale);
	pos -= vec2((resolution.x / scale) / 2.0, (resolution.y / scale) / 2.0);
	
	// Standing wave equation first Harmonic
        vec2 p = calculateParams(vec2(1.0, 1.0));
	float y = 2.0 * y0 * cos(p.x * time* timeScale) * sin(p.y * pos.x);

//	vec2 pv2 = 8. * vec2( pos.x+cos(time/10.) , pos.y+sin(time/7.)  );
	vec2 pv2 = 8. * vec2( pos.x , pos.y  );
	float noise = fbm(pv2);
	float noise2 = fbm(vec2(time,time+0.5));
	
	//noise = noise2;
	
	// Pixel color based on distance to wave.
	float dist = abs(y-pos.y);
	
	float color = 1.0  / (exp(dist* 50.1));
	
	//float color = 1.0 / (exp(abs((y - pos.y))* 50.0));
	// float color = abs(y-pos.y);//;1.0 / (exp(abs((y - pos.y))* 50.0));
		
	color = mix ( color, noise2, 1./(10. * dist));
	
	//color= reflect(noise,color);
	
	color = color * noise;
	
	gl_FragColor = vec4( vec3( 1.0, 0.7, 0.6 ) * color, 1.0 );
		
}
