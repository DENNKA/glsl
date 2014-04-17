precision mediump float;

uniform float time;
uniform vec2 resolution;

void main(void)
{
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);
	
	float r = sin(p.y*100.0/(-0.8 + sin((0.8+cos(time*5.0))*p.x*0.5)));
	float g = sin(p.x*100.0/(-0.8 + sin((0.3+cos(time*3.0))*p.x*0.4)));
	float b = sin(p.x+time*3.1337/8.0 + cos(p.y));
		
	vec3 col=vec3(r,g,b);
	gl_FragColor=vec4(col, 1.0);
	
}