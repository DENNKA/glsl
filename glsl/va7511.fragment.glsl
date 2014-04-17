#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// tie nd die by Snoep Games.

void main( void ) {

	vec3 color = vec3(0.0, 0.5, 0.5);
	vec2 pos = (( 2.0 * gl_FragCoord.xy - vec2(100, 100) ) / vec2(51000, 2000))*3.0;
	float r=sqrt(pos.x*pos.x+pos.y*pos.y)/15.0;
	float size1=2.0*cos(time/1260.0);
	float size2=5.5*sin(time/20.0);
	
	float rot1=25.00; //82.0+16.0*sin(time/4.0);
	float rot2=-21.00; //82.0+16.0*sin(time/8.0);
	float t=sin(time);
	float a = (10.0)*sin(rot1*atan(pos.x-size1*pos.y/r,pos.y+size1*pos.x/r)+time);
	a += 200.0*acos(pos.x*2.0+cos(time/2.0))+asin(pos.y*5.0+sin(time/2.0));
	a=a*(r/50.0);
	a=200.0*sin(a*5.0)*(r/30.0);
	if(a>5.0) a=a/1200.0;
	if(a<0.5) a=a*122.5;
	gl_FragColor = vec4( cos(a/120.0),a*cos(a/1.0),sin(a/8.0), 1.0 );

}