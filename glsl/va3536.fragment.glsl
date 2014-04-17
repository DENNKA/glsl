#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;



vec3 sausage( vec3 col, vec2 position, float sharpness, float waves, float wavyness ) {
	col *= abs(sin(time)*sharpness)*sin(position.x*waves-sin(position.y*wavyness));
	return col;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	
	vec3 col, col2, col3;
	
	col = sausage(vec3(0.9, 0.2, 0.0), position, 1.5, 25.0, time*25.0);
	col2 = sausage(vec3(0.2, 0.5, 0.7), position, 1.5, 100.0, cos(time)*80.0);
	col3 = sausage(vec3(0.2, 0.5, 0.7), position, 15.0, 100.0, cos(time)*15.0);
	
	col *= col2+0.5;
	col *= col3;
	
	col /= 1.0-position.y;
	
	gl_FragColor = vec4( col, 1.0 );
}
