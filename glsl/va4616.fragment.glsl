
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// Trapped by curiouschettai

void main( void ) {  
	vec2 uPos = ( gl_FragCoord.xy / resolution.y );//normalize wrt y axis
	uPos -= vec2((resolution.x/resolution.y)/2.0, 0.5);//shift origin to center
	
	float multiplier = 0.02; // Grosseur
	const float step = 0.1065; //segmentation
	const float loop = 100.0; //Longueur
	const float timeSCale = 1.45; // Vitesse
	
	vec3 blueGodColor = vec3(0.0);
	for(float i=1.0;i<loop;i++){		
		float t = time*timeSCale-step*i;
		vec2 point = vec2(0.92*sin(t), 0.65*sin(t*0.85));
		point += vec2(0.15*cos(t*6.0), 0.3*sin(t*2.0));
		point /= 2.0;
		float componentColor= multiplier/((uPos.x-point.x)*(uPos.x-point.x) + (uPos.y-point.y)*(uPos.y-point.y))/i;
		blueGodColor += vec3(componentColor * 0.0, componentColor*2.0, componentColor/4.0);
	}
	
	
	vec3 color = vec3(0,0,0);
	color += blueGodColor;
   
	
	gl_FragColor = vec4(color, 1.0);
}