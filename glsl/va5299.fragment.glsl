#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

const vec2 bricksize = vec2(5.0, 5.0);
const vec2 brickspace = vec2(1.0, 1.0); //Adjust spacing



void main(void)
{
	vec3 color = vec3(0.75, 0.3, 0.3);
	
	vec2 position = gl_FragCoord.xy;
	
	float row = floor(gl_FragCoord.y/bricksize.y);
	
	if (mod(row, 2.0) < 1.0)
	{
		position.x += bricksize.x/2.0;
	}
	
	if (mod(position.x, bricksize.x) < brickspace.x || mod(position.y, bricksize.y) < brickspace.y)
	{
		color = vec3(0.5, 0.5, 0.5);
	}
	
	gl_FragColor = vec4(color, 1.0);
}