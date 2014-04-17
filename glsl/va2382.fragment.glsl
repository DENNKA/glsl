//original author = 
//fork by harley : repeat gears over x/y axis, add more colors
// funny ;)
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 distanceVector = (gl_FragCoord.xy / resolution.xy);
	distanceVector.x *= resolution.x;
	distanceVector.y *= resolution.y;
	
	float d = 50.0;
	
	float newtime = time * sign(mod(distanceVector.x, d * 2.0) - d) * sign(mod(distanceVector.y, d * 2.0) - d);
	
	distanceVector.x = mod(distanceVector.x, d) - d / 2.0;	
	distanceVector.y = mod(distanceVector.y, d) - d / 2.0;
	
	float angle = atan(distanceVector.x, distanceVector.y);
	
	float scale = 0.0014;
	float cogMin = 0.06; // 'min' is actually the outer edge because I'm using 1/distance... for reasons I can't remember :(
	float cogMax = 0.97; // 'max' is the inner edge, so this controls the size of the hole in the middle - the higher the value the smaller the hole


	float distance = 1.0 - scale * ((distanceVector.x * distanceVector.x) + (distanceVector.y * distanceVector.y));

	
	// tooth adjust makes the teeth slope so they get smaller as they get further out
	float toothAdjust = 2.4 * (distance - cogMin);
	// 12 defines the number of cog teeth
	float angleFoo = sin(angle*12.0 - newtime * 4.0) - toothAdjust;
	cogMin += 20.0 * clamp(1.0 * (angleFoo + 0.2), 0.0, 1.015); // add 0.2 to make teeth a bit thinner, the 0.015 clamp controls the thickness of the cog ring
	
	// By multiplying values up and clamping we can get a solid cog with slight anti-aliasing
	float isSolid = clamp(2.0 * (distance - cogMin) / cogMax, 0.0, 1.0);
	isSolid = clamp(isSolid * 100.0 * (cogMax - distance), 0.0, 1.0);
	
	// Make it BlitzTech purple	
	float brightness = isSolid *(1.0-sin(angle*3.0-newtime)*0.5);
	gl_FragColor = vec4(brightness*0.3,brightness*0.05,brightness*0.5 * sign(newtime), 1.0 );
}