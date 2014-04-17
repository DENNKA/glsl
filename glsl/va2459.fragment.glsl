//@micgdev
//writing my name as simple rectangles
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;

void main( void ) {

	vec2 p = gl_FragCoord.xy / resolution.xy;

	//Background
	vec4 bgc = vec4(.1);
	gl_FragColor = bgc;
	
	//Letter M
	if(p.x < .05 || p.y > .9 && p.x < 0.5 || p.x > .45 && p.x <.5 || p.x > .225 && p.x < .275){
		gl_FragColor = vec4(.9, .25, .25, 1.);
	}
	
	//Letter i
	if(p.x > .505 && p.x < .555 && (p.y < .45 || p.y > .46 && p.y <.55)){
		gl_FragColor = vec4(.25, .8, .25, 1.);
	}
	
	//Letter D
	if(p.x > .56 && p.x < .8 && p.y < .55){
		gl_FragColor = vec4(.1, .1, .8, 1.);
		if(p.x > .61 && p.y < .45 && p.y > .1 && p.x < .8) gl_FragColor = bgc;
	}
	
	//Letter G
	if(p.x > .81 && p.y < .55){
		gl_FragColor = vec4(.5);
		if(p.x > .86 && p.y < .45 && p.y > .35) gl_FragColor = bgc;
		if(p.x > .86 && p.x < .91 && p.y < .35 && p.y > .3) gl_FragColor = bgc;
		if(p.x > .86 && p.x < .95 && p.y < .3 && p.y > .1) gl_FragColor = bgc;
	}
	
}