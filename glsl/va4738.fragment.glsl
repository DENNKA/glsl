#ifdef GL_ES
precision mediump float;
#endif

// looks absolutely nothing like water

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 noise(vec2);
float perlin(vec2);
float fbm(vec2);
float pattern( in vec2 );

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*10.0;
	float fx=fbm(p);
	float cx=fbm(p);
	p.x+=pow(fx,0.1);
	p.y+=pow(fx,0.1);
	fx=pow(fbm(p),0.5);
	cx=pow(1.-pow(fbm(p*0.85),0.5),20.0);
	float f1 = fbm(p+vec2(3.0));
	vec3 col = max(vec3(fx+f1)*vec3(0.05,0.4,0.9),vec3(cx)+0.01*pow(1.0-f1-fx,10.0)*vec3(0.85,0.6,0.5));
	gl_FragColor=vec4(col,1.0);
}

float fbm(vec2 p) {
	float tme=time*0.1;
	float f=0.0;
	vec2 p1=vec2(p.x+cos(tme+p.y*.25),p.y+sin(tme+p.x*.25));
	f+=perlin(p1);
	f+=perlin(p1*0.5+time*sin(time*0.01))*0.5;
	f+=perlin(p1*0.25)*0.25;
	f+=perlin(p1*0.125)*0.125;
	f+=perlin(p1*0.0625)*0.0625;
	return f/1.0;
}

float perlin(vec2 p) {
	vec2 q=floor(p);
	vec2 r=fract(p);
	float s=dot(noise(q),p-q);
	float t=dot(noise(vec2(q.x+1.0,q.y)),p-vec2(q.x+1.0,q.y));
	float u=dot(noise(vec2(q.x,q.y+1.0)),p-vec2(q.x,q.y+1.0));
	float v=dot(noise(vec2(q.x+1.0,q.y+1.0)),p-vec2(q.x+1.0,q.y+1.0));
	float Sx=3.0*(r.x*r.x)-2.0*(r.x*r.x*r.x);
	float a=s+Sx*(t-s);
	float b=u+Sx*(v-u);
	float Sy=3.0*(r.y*r.y)-2.0*(r.y*r.y*r.y);
	return a+Sy*(b-a);
}

vec2 noise(vec2 n) {
	vec2 ret;
	ret.x=fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453)*2.0-1.0;
	ret.y=fract(sin(dot(n.xy, vec2(34.9865, 65.946)))* 28618.3756)*2.0-1.0;
	return normalize(ret);
}