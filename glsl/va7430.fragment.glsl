# ifdef GL_ES
precision mediump float;
# endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;

vec3 Hue( float hue )
{
	vec3 rgb = fract(hue + vec3(0.0,2.0/3.0,1.0/3.0));

	rgb = abs(rgb*2.0-1.0);
		
	return clamp(rgb*3.0-1.0,0.0,1.0);
}

vec3 HSVtoRGB( vec3 hsv )
{
	return ((Hue(hsv.x)-1.0)*hsv.y+1.0) * hsv.z;
}

vec3 RGBtoGray( vec3 rgb )
{
	float c = 0.299*rgb.x+0.587*rgb.y+0.114*rgb.z;
	return vec3(c,c,c);
}

void main()
{
	float h = gl_FragCoord.x / resolution.x;
	
	float s = gl_FragCoord.y / resolution.y;
	
	float v = mouse.y;
	
	//gl_FragColor = vec4(HSVtoRGB(vec3(h,s,v)),1.0);
	//grayscale
	gl_FragColor = vec4(RGBtoGray(HSVtoRGB(vec3(h,s,v))),1.0);
}
