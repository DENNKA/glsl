#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

//http://glsl.heroku.com/e#6295.0
varying vec2 surfacePosition;

vec4 textureRND2D(vec2 uv){
	uv = floor(fract(uv)*1e3);
	float v = uv.x+uv.y*1e3;
	return fract(1e5*sin(vec4(v*1e-2, (v+1.)*1e-2, (v+1e3)*1e-2, (v+1e3+1.)*1e-2)));
}

float noise(vec2 p) {
	vec2 f = fract(p*1e3);
	vec4 r = textureRND2D(p);
	f = f*f*(3.0-2.0*f);
	return (mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y));	
}

float cloud(vec2 p) {
	float v = 0.0;
	v += noise(p*1.)*.50000;
	v += noise(p*2.)*.25000;
	v += noise(p*4.)*.12500;
	v += noise(p*8.)*.06250;
	v += noise(p*16.)*.03125;
	return v*v*v;
}

float lengthN(vec2 v, float n)
{
	vec2 tmp = pow(abs(v)*sin(time), vec2(n));
	return pow(tmp.x*tmp.y, 1.0/n);
}
 
float rings(vec2 p)
{
	vec2 p2 = mod(p*15.0, 4.0)-2.0;
	return sin(lengthN(p2, 4.0)*16.0);
}
 
vec2 trans(vec2 p)
{
	float sec;
	sec = time*1.016;
	return vec2(p.x+cos(sec), p.y+sin(sec));
}
 
void main() {
	vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
	vec2 uv	= -1.0 + 2.0 * (gl_FragCoord.xy/resolution.xy);
	vec3 D	 = normalize(vec3(uv.x * 1.25, uv.y, 1));
	
	//rotate
	float rot = 0.3-sin(0.3 * time + sin(time * 0.2)) * 0.4;
	D = vec3(
		D.x * cos(rot) - D.y * sin(rot),
		D.x * sin(rot) + D.y * cos(rot), D.z);

	//pos
	vec3 p	 = vec3(-time * 8.5, 0, time * 8.0);
	int id	 = 0;

	//raymarching
	vec3 g	 = p;
	for(int i = 0 ; i < 50; i++) {
		
		//ground
		float k = 8.0 + dot(g, vec3(0, 1, 0)) + sin(g.x*0.5) + sin(g.z*0.5);

		//sky
		float h = 10.0 - dot(g, vec3(0, 1, 0));
		
		//sky?
		if(h < k)
		{
			k = h;
			id = 1;
		}
		else
		{
			id = 0;

		}
		//next pos.
		g += D * k * 0.5;
	}

	//depth
	float L = length(g - p);

	//fog
	float c = L;

	//beam
	float beampulse = sin(170.0 * time + sin(time * 110.0)) * 0.03;
	vec3	beamdirection = normalize(vec3(0, 0.7, cos(cos(time * 0.5) + time * 0.7) * 0.7).yzx);
	vec3	beam = vec3(3, 2, 1) * pow(dot(D, beamdirection), 0.4 + beampulse);

	//sun
	float sun = pow(dot(D, normalize(vec3(0, -0.1, 1))), 64.0) * 4.5;
	vec4	color = vec4(0);
	
	if(id == 1) //issky
	{
		color = vec4(
			0.5 * cloud(g.xz * 0.0005) + cloud(g.xz * 0.0001)) +		//cloud
			0.6 * mix(vec4(4,2,1,1), vec4(1,2,2,1), D.y) - beam.xyzz - sun; //sky sun and beam
	}
	else //ground
	{
		color = vec4(rings(trans(g.xz * 0.03)),0.2,0.5,0.5) - c * 0.01;
	}
	gl_FragColor = color + c * 0.001;
}
