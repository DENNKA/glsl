#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 spirala(vec2 position) {
  float d = 20.0*log(0.02 + distance(position, vec2(0.5, 0.5)) ); // odleglosc od srodka
  //float fala = pow(sin(time - d), 2.0);
  float fala = -0.5*pow(sin(13.4*time- d*0.2)+1.0, 0.25); // falowanie
  float faza0 = atan(position.x-0.5, position.y-0.5);
  float faza = 0.0;
  float color = 1.0+sin(2.0*faza  + d + fala - time*10.0);
  color = color*color;
  return vec3(color, sin(d + 10.0*faza0)*color, cos(d + faza0)*color);
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ); //- (mouse-vec2(0.5, 0.5));

	float color = 0.0;
	//color += sin( 10.0*position.x * (cos(0.5*time)+1.4) );
	//color += sin( 10.0*position.y * (sin(time) + 2.1 ) );
	//color += sin( 1.1 + distance(20.0*position, vec2(10.0+11.0*sin(time), 0.0+10.0*cos(time)) ));
	//color += 2.0*(1.0+sin( position.x*position.x + position.y*position.y));
	//color += 2.0*(1.0+sin( position.x*position.x - position.y*position.y));

        vec3 c1 = spirala(position + 0.05*vec2(sin(-4.0*time), cos(4.0*time)));
  	vec3 c2 = spirala(position - 0.2*sin(time*0.03)*vec2(0.45*sin(time*0.2), 0.51*cos(time*0.3)));
  	vec3 c3 = spirala(position + 0.1*sin(time*0.03)*vec2(0.3*sin(time*0.4), 0.6*cos(time*0.5)));

	//gl_FragColor = vec4( vec3( color, color*sin(color+time*1.1314), color*sin(color+time*0.1))/(8.0), 1.0 );
	//gl_FragColor = vec4( vec3( color, cos(time)*color, sin(color*sin(time)))/(30.0), 1.0 );
  	//gl_FragColor = vec4( vec3( color, color, color)/(20.0), 1.0 );
  	gl_FragColor = vec4( (c1)/(4.0), 1.0 );

} 