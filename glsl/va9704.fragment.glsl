// warping hexagons, WIP. @psonice_cw
// I'm sure there's a less fugly way of making a hexagonal grid, but hey :)

//  Maybe - Try this...

// Simplify!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

// 1 on edges, 0 in middle
float hex(vec2 p, float r2) 
{
	p.x *= 1.16; //no product, simple number, shortened - Chaeris
	p.y += mod(floor(p.x), 4.0) * 0.5;
	p = abs((mod(p, 1.00) - 0.5));
	return abs(max(p.x * 1.5 + p.y, p.y * 2.0) - r2);
}

void main(void) 
{ 
	vec2  pos = gl_FragCoord.xy;
	pos.x 	 += 15.0;
	vec2  p   = pos * 0.03; // Removed the divide - Timmons
	float r1  = 0.1; //Simplified number2 - Chaeris
	float r2  = 0.3;

	float c1 = smoothstep(.0, r1, hex(p,1.0 - r2));
	float c2 = smoothstep(.0, r1, hex(p,1.0 - r2 + (.03 * sin(time /1.3)) ));

	gl_FragColor = vec4(c1,c2,c1+(2. * c1-c2),1.);
}
// Good job mans! - Chaeris, again, sorry for the amount of comments I made :D