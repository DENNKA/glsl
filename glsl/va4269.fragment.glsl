// domain warping on noise. about : http://www.iquilezles.org/www/articles/warp/warp.htm
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

mat2 m = mat2( 0.80,  0.60, -0.60,  0.9 );

float hash( float n )
{
    return fract(sin(n)*7919.0);//*
}

float noise( in vec2 x )
{
    vec2 p = floor(x);
    vec2 f = fract(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*7919.0;
    float res = mix(mix( hash(n+ 0.0), hash(n +1.0),f.x), mix( hash(n+ 7919.0), hash(n+ 7920.0),f.x),f.y);
    return res;
}

int mod(int a, int b) {
	return a - ((a / b) * b);
}

float fbm( vec2 p ) {
    p*=3.;
    float f = 0.0;
        f += 0.25000*noise( p ); p = m*p*0.02;
        f += 0.12500*noise( p ); p = m*p*0.13;
        f += 0.06250*noise( p ); p = m*p*0.01;
        f += 0.03125*noise( p ); p = m*p*0.04;
        f += 0.01500*noise( p );
    return f/0.38375;
}

vec2 r(vec2 v, float a) {
	mat2 m = mat2 (cos(a), -sin(a),
		       -sin(a), cos(a*a/20000.) );
	return m*v;
}

void main( void ) {
	vec3 col;
	vec2 p=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
	p.x*=resolution.x/resolution.y;

        vec2 dx1 = vec2(1.0,0.0);	
	vec2 dy1 = vec2(1.2,1.3);
	
	vec2 dx2 = vec2(1.7,1.2);
	vec2 dy2 = vec2(1.3,1.8);
	
	dx1 = r(dx1,time/12.);
	//dy1 = r(dy1,time/8.);
	
	//dx2 = r(dx2,time/120.);
	//dy2 = r(dy2,time/170.);
	
	vec2 q = vec2(fbm( p + dx1 ) , 
		      fbm( p + dy1 ) );
	
	vec2 r = vec2( fbm( p + 1.5*q + dx2 ),
                       fbm( p + 1.5*q + dy2 ) );

	vec2 s = vec2( fbm( p + 1.5*r + dx1+dx2 ),
                       fbm( p + 1.5*r + dy2+dy2 ) );
		
	float v = fbm( p + 4. * s );
	col = v * vec3(q.x,r.x,s.x) + vec3(q.y,r.y,s.y);
	float h = (col.x + col.y + col.z) / 3.0 + 0.1;
	gl_FragColor = vec4( h, h, h, 1. );

}