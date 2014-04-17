//@ME 
//Stones
//TODO: colors, cover with moss, ...
// some colo[u]r added here by @danbri
//
// iq's noise generation! superb!

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.80 );

float hash( float n )
{
	return fract(sin(n)*43758.5453);
}

float noise( in vec2 x )
{
	vec2 p = floor(x);
	vec2 f = fract(x);
    	f = f*f*(3.0-2.0*f);
    	float n = p.x + p.y*57.0;
    	float res = mix(mix( hash(n+  0.0), hash(n+  1.0),f.x), mix( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    	return res;
}

float fbm( vec2 p )
{
    	float f = 0.0;
    	f += 0.50000*noise( p ); p = m*p*2.02;
    	f += 0.25000*noise( p ); p = m*p*2.03;
    	f += 0.12500*noise( p ); p = m*p*2.01;
    	f += 0.06250*noise( p ); p = m*p*2.04;
    	f += 0.03125*noise( p );
    	return f/0.984375;
}

float thing(vec2 pos) 
{
	vec2 p = pos;
	pos.x = fract(pos.x + fbm(p*0.9) +.5)-0.5;
	pos.y = fract(pos.y + fbm(p*0.9) +.5)-0.5;
	
	//pos.x = fract(pos.x + fbm(p*0.75) +.5)-0.5;
	//pos.y = fract(pos.y + fbm(p*0.75) +.5)-0.5;
	
	pos = abs(pos);
	float r = sqrt(pos.x*pos.y * 2.0) * 3. ;
	return clamp((r*fbm(p*1.5)+(fbm(p*m*25.) * 0.25))-.25, 0.0, 1.0);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 9.0;
	world.x *= resolution.x / resolution.y;
	world.x += time;
	float shade = thing(world);
	float green =  noise(vec2(world.x,world.y) );
	float red =  noise(vec2(world.y,world.x) );
	float blue =  noise(vec2(1.0 - world.y,1.0 - world.x) );

	gl_FragColor = vec4( mix(red*shade, red-shade -.2, noise(vec2(world.x * sin(time/1000.), world.y)) ), shade * green, shade * blue, 1.0 );
}