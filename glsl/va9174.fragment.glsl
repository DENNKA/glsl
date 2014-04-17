// warping hexagons, WIP. @psonice_cw
// I'm sure there's a less fugly way of making a hexagonal grid, but hey :)

//  Maybe - Try this...

// Simplify!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

// 1 on edges, 0 in middle
float hex(vec2 p) 
{
	p.x *= 1.16; //no product, simple number, shortened - Chaeris
	p.y += mod(floor(p.x), 4.0)*1.5;
	p = abs((mod(p, 1.0) - 0.5));
	return abs(max(p.x*1.5 + p.y, p.y*2.0) - 1.0);
}

void main(void) 
{ 
	vec2  pos = gl_FragCoord.xy;
	pos.x 	 += 15.0 * time;
	vec2  p   = pos*0.02; // Removed the divide - Timmons
	float r   = 0.05; //Simplified number2 - Chaeris
	gl_FragColor = vec4(smoothstep(0.0, r, hex(p)));
}
// Good job mans! - Chaeris, again, sorry for the amount of comments I made :D