#ifdef GL_ES
precision mediump float;
#endif

// burl figure
// cig smoke


uniform vec2 resolution;
uniform float time;

const float Pi = 3.14159;
const float fScale=4.3;
const float fEps=0.5;

float sinApprox(float x) {
    x = Pi + (2.0 * Pi) * floor(x / (2.0 * Pi)) - x;
    return (4.0 / Pi) * x - (4.0 / Pi / Pi) * x * abs(x);
}

float cosApprox(float x) {
    return sinApprox(x + 0.5 * Pi);
}

void main()
{
	vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
	for(int i=1;i<20;i++)
	{
		vec2 newp=p;
		newp.x+=0.6/float(i)*sinApprox(float(i)*p.y+time/8.0+0.3*float(i))+400./20.0;		
		newp.y+=0.6/float(i)*sinApprox(float(i)*p.x+time/8.0+0.3*float(i+10))-400./20.0+15.0;
		p=newp;
	}

	p*=fScale;

	vec3 lum=vec3(0.299,0.587,0.114);

	vec2 p1=vec2(p.x,p.y);
	vec2 p2=vec2(p.x+fEps,p.y);
	vec2 p3=vec2(p.x,p.y+fEps);

	vec3 c1=vec3(0.5*sinApprox(3.0*p1.x)+0.5,0.5*sinApprox(3.0*p1.y)+0.5,sinApprox(p1.x+p1.y));
	vec3 c2=vec3(0.5*sinApprox(3.0*p2.x)+0.5,0.5*sinApprox(3.0*p2.y)+0.5,sinApprox(p2.x+p2.y));
	vec3 c3=vec3(0.5*sinApprox(3.0*p3.x)+0.5,0.5*sinApprox(3.0*p3.y)+0.5,sinApprox(p3.x+p3.y));

	float s1=dot(c1,lum);
	float s2=dot(c2,lum);
	float s3=dot(c3,lum);

	vec3 n=normalize(vec3(s1,s2,s3));
	vec3 l=normalize(vec3(-1.0,-1.0,1.0));

	float fSpec=dot(l,n)*2.0;
	vec3 c=(c1*2.8)*fSpec;

	s1=dot(c,lum);
	c=vec3(s1,s1,s1);
	
	gl_FragColor=vec4(c,1.0);
}
