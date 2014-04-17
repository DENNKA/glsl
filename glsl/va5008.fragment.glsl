#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// From "Random-Access Rendering of General Vector Graphics"
// posted by Trisomie21
// @mod* by rotwang

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float det(vec2 a, vec2 b) { return a.x*b.y-b.x*a.y; }

vec2 get_distance_vector(vec2 b0, vec2 b1, vec2 b2)
{
	float a=det(b0,b2), b=2.0*det(b1,b0), d=2.0*det(b2,b1);
	float f=b*d-a*a;
	vec2 d21=b2-b1, d10=b1-b0, d20=b2-b0;
	vec2 gf=2.0*(b*d21+d*d10+a*d20);
	gf=vec2(gf.y,-gf.x);
	vec2 pp=-f*gf/dot(gf,gf);
	vec2 d0p=b0-pp;
	float ap=det(d0p,d20), bp=2.0*det(d10,d0p);
	float t=clamp((ap+bp)/(2.0*a+b+d), 0.0,1.0);
	return mix(mix(b0,b1,t),mix(b1,b2,t),t);
}

vec3 clr_a( vec2 pos)
{
	float d = length(pos) - 8.0;
	d = clamp(1.0-d, 0.0, 1.0);
	return vec3(d,d*0.6,d*0.2);
}


vec3 clr_b( vec2 pos)
{
	float d = length(pos) - 8.0;
	d = clamp(1.0-d, 0.0, 1.0);
	return vec3(d*0.2,d*0.6,d);
}


vec3 clr_c( vec2 pos)
{
	float d = length(pos)-1.0;
	d = clamp(1.0-d, 0.0, 1.0);
	return vec3(d,d,d);
}

void main(void)
{
	vec2 pos = gl_FragCoord.xy;
	vec2 p[3];
	float s = 1.0;//resolution.x/1920.0;
	
	p[0] = vec2(resolution.x*.30,resolution.y*.4);
	p[1] = mouse*resolution;
	p[2] = vec2(resolution.x*.60,resolution.y*.6);

	// make the bez pass thru the control point (THX)
	p[1]+=(p[1]-((p[0]+p[2])*0.5));
	
	vec2 xy = get_distance_vector(p[0]-pos, p[1]-pos, p[2]-pos);
	
	vec3 ca = clr_a(xy);
	vec3 cb = clr_b(p[0] -pos);
	vec3 cc = clr_b(p[2] -pos);
	vec3 cd = clr_c(xy);
	vec3 clr = mix(ca+cb+cc,cd, 0.5);
	gl_FragColor = vec4(clr, 1.0);

}