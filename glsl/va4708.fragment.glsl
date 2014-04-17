#ifdef GL_ES
precision mediump float;
#endif
// mods by dist, shrunk slightly by @danbri
// color mod and mouse controls by @kpicbluestone

precision mediump float;
uniform float time;
uniform vec2 mouse, resolution;
void main(void) {
	vec2 uPos = ( gl_FragCoord.xy / resolution.xy );//normalize wrt y axis
	uPos -= .5;
	vec3 color = vec3(0.0);
	float vertColor = 0.0;
	for( float i = 0.; i < 8.; ++i ) {
		uPos.y += sin( uPos.x*(i) + (time*1.3 * i * i * 0.3) ) * 0.15*mouse.y;
		float fTemp = abs(0.5 / uPos.y / 90.0) * (mouse.x+0.1)/10.0*6.0;
		vertColor += fTemp;
		color += vec3( fTemp*(7.0-i)/10.0, (fTemp*i/3.0)*(max(sin(time*0.5)*5.0,0.3)), pow(fTemp,0.9)*1.5 );
	}
	gl_FragColor = vec4(color, 1.0);
}