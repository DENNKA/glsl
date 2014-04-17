#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(0,0))) * 431.5453);
}

void main()
{
	vec2 pos = -1.0 + 2.0 * gl_FragCoord.xy / resolution;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	float t = time + 1.0 / u;
	
	vec3 color = vec3(abs(sin(t * 10.0 + v))) * u * 0.25;
	color += vec3(abs(sin(-t + v))) * u * 0.75;
	
	color.y *= 0.8;
	color.z *= 0.6;
	color *= rand(vec2(t, v)) * 0.2 + 0.8;
	
	gl_FragColor = vec4(color, 1.0);
}