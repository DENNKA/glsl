#ifdef GL_ES
precision mediump float;
#endif
// #I need Smoke and mirros !! anyone can help with the design?   -Harley.
uniform float time;
uniform vec2 resolution;

#define N 6
//nice coffee ... kind of
void main( void ) {
	vec2 v=(gl_FragCoord.xy-(resolution*0.5))/min(resolution.y,resolution.x)*10.0;
	float t=time * 0.4,r=2.0;
	for (int i=1;i<N;i++){
		float d=(3.14159265 / float(N))*(float(i)*14.0);
		r+=length(vec2(v.y,v.x))+1.21;
		v = vec2(v.x+cos(r+sin(r)-d)+cos(t),v.y-cos(r+sin(r)+d)+sin(t));
	}
        r = (sin(r*0.05)*0.5)+0.5;
	r = pow(r, 30.0);
	gl_FragColor = vec4(r,pow(max(r-0.75,0.0)*4.0,2.0),pow(max(r-1.875,0.1)*5.0,4.0), 1.0 );
}
