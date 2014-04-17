#ifdef GL_ES
precision mediump float;
#endif

uniform float time; 
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt = 80.0;
	float nd = 0.0;
	vec4 cbuff = vec4(0.0);

	for(float i=0.0; i<28.0;i++){
	nd =sin(3.14*0.3*pos.x + (i*0.1+sin(+time)*0.9) + time)*0.5+0.01 + pos.x;
	amnt = 1.0/abs(nd-pos.y)*0.01; 
	
	cbuff += vec4(amnt, amnt*0.15 , amnt*pos.y, 01.0);
	}
	
	for(float i=0.0; i<1.0;i++){
	nd =sin(3.14*2.0*pos.y + i*40.5 + time)*12.3*(pos.x+10.3)+0.5;
	amnt = 1.0/abs(nd-pos.x)*0.0015;
	
	cbuff += vec4(amnt*0.1, amnt*0.2 , amnt*pos.x, 1.0);
	}
	
	vec4 dbuff =  texture2D(backbuffer,1.0-pos)*0.1;
        vec4 col = vec4(cbuff + dbuff);
        col = vec4( smoothstep(col.x, .2, 5.*  sin(time) ));
	gl_FragColor = col;
  
}
