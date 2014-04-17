
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Tweaked by T21 : 3d noise

float rand(vec3 n, float res)
{
  n = floor(n*res+.5);
  return fract(sin((n.x+n.y*1e2+n.z*1e4)*1e-4)*1e5);
}

float map( vec3 p )
{
    p = mod(p,vec3(1.0, 1.0, 1.0))-rand(p, 20.0) * 0.2;
    return length(p.xy)-.1;
}

void main( void )
{
    vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    vec3 camPos = vec3(cos(time*0.3), sin(time*0.3), 1.5);
    vec3 camTarget = vec3(0.0, 0.0, 0.0);

    vec3 camDir = normalize(camTarget-camPos);
    vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    vec3 camSide = cross(camDir, camUp);
    float focus = 2.0;

    vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    vec3 ray = camPos;
    float d = 0.0, total_d = 0.0;
    const int MAX_MARCH = 100;
    const float MAX_DISTANCE = 5.0;
    float c = 1.0;
    for(int i=0; i<MAX_MARCH; ++i) {
        d = map(ray);
        total_d += d;
        ray += rayDir * d;
        if(abs(d)<0.001) { break; }
        if(total_d>MAX_DISTANCE) { c = 0.; total_d=MAX_DISTANCE; break; }
    }
	
    float fog = 5.0;
    vec4 result = vec4( vec3(c*.4 , c*.6, c) * (fog - total_d) / fog, 1.0 );

    ray.z -= 5.+time*.5;
    float r = rand(ray, 33.);
    gl_FragColor = result*(step(r,.3)+r*.2+.1);
}
