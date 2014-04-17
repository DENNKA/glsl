//AAAAA
//What did I do
// @scratchisthebes

#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159
#define TAU 6.283

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float arc(vec2 pos,vec4 btrir,float ang,vec2 p);

void main( void ) {

	vec2 p = gl_FragCoord.xy;

	float color = 0.;
	
	for(int i=1; i <= 10; i++) {
		color += arc(resolution/4.,vec4(0,PI/2.,3,400),time*float(i),p);
	}
	
	gl_FragColor = vec4(color*0.5,color*0.5,color*1.2,1.0);
}

float arc(vec2 pos,vec4 btrir,float ang,vec2 p)
{
	vec2 c = resolution/2.;
	
	float d = distance(p,vec2(c));
	
	float a = atan(p.x-c.x,p.y-c.y)+PI+ang;
	
	a = mod(a,TAU);
	
	float color = 0.0;
	
	if(a > btrir.x && a < btrir.y && d > btrir.z && d < btrir.w)
	{
		float diff = d-btrir.z;
		float rtrn = smoothstep(0.0,1.0,pow(sin(diff/16.*PI),0.25));
		
		float eb = 3.0;
		if(a < btrir.x+(PI/eb))
		{
			rtrn *= smoothstep(0.0,1.0,a/(PI/eb));
		}
				
		if(a > btrir.y-(PI/eb))
		{
			float ad = a - (btrir.y-(PI/eb));
			rtrn *= smoothstep(1.0,0.0,ad/(PI/eb));
		}
		return rtrn;
	}
	
	return 0.0;
}

