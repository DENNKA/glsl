#ifdef GL_ES
precision mediump float;
#endif
#define RADIANS 0.017453292519943295

uniform float time;
uniform vec2 resolution;

const int zoom = 100;
const float brightness = 0.975;
float fScale = .25;

float cosRange(float degrees, float range, float minimum) {
	return (((1.0 + cos(degrees * RADIANS)) * 0.5) * range) + minimum;
}

void main(void)
{
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);
	float ct = cosRange(time*5.0, 3.0, 1.1);
	float xBoost = cosRange(time*0.1, 5.0, 5.0);
	float yBoost = cosRange(time*0.1, 10.0, 5.0);
	
	fScale = cosRange(time * 0.9, 0.75, 0.75);
	
	for(int i=1;i<zoom;i++) {
		float _i = float(i);
		vec2 newp=p;
		newp.x+=0.95/_i*sin(_i*p.y+time*cos(ct)*0.3/40.0+0.03*_i)*fScale+xBoost;		
		newp.y+=0.90/_i*sin(_i*p.x+time*ct*0.3/80.0+0.03*float(i+15))*fScale+yBoost;
		p=newp;
	}
	
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	col *= brightness;
	gl_FragColor=vec4(col, 5.0);
	
}