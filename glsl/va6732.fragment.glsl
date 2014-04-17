// warping hexagons, WIP. @psonice_cw
// I'm sure there's a less fugly way of making a hexagonal grid, but hey :)

//  Maybe - Try this...

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

float hex(vec2 p, float r){
	p = abs(p);
	return max(p.x+p.y*0.57735,p.y*1.1547)-r;
}

void main(void) 
{ 
	vec2 pos = gl_FragCoord.xy;
	
	vec2 p = pos/50.0; 

	p.x *= 1.1547;
	p.y += mod(floor(p.x), 2.0)*0.5;
	p = mod(p, 1.0) - 0.5;
	float d = max(-hex(vec2(p.x/1.1547,p.y),0.57735), hex(vec2(p.x*1.5*0.57735, p.y),0.57735));
	
	float  r = (1.0+cos(time))*0.4;	
	gl_FragColor = vec4(smoothstep(r, r-0.1, d));

}
