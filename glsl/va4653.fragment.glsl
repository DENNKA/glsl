#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += tan( position.x * tan( time / 15.0 ) * 80.0 ) + tan( position.y * tan( time / 15.0 ) * 10.0 );
	color += tan( position.y * tan( time / 10.0 ) * 40.0 ) + tan( position.x * tan( time / 25.0 ) * 40.0 );
	color += tan( position.x * tan( time / 5.0 ) * 10.0 ) + tan( position.y * tan( time / 35.0 ) * 80.0 );
	color *= tan( time / 10.0 ) * 0.5;

	gl_FragColor = vec4(
		max(
		min(
			vec3( color*239./255., color* 84./255. , color* 56./255. ),
			vec3( 239./255. , 84./255. , 56./255.)
			),
			vec3( 49./255. , 44./255. , 38./255.)
		),
		1.0
	);
}