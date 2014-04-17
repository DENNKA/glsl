#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

// http://glsl.heroku.com/e#7433.1 changed a little bit by logos7@o2.pl

void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x/resolution.y;

    float zoo = .62+.38*sin(.1*time);
    float coa = cos( 0.1*(1.0-zoo)*time );
    float sia = sin( 0.1*(1.0-zoo)*time );
    vec2 xy = vec2( p.x*coa-p.y*sia, p.x*sia+p.y*coa);
    vec2 cc = vec2(-.745,.186) + xy;

    vec2 z  = vec2(0.0);
    vec2 z2 = z*z;
    float m2;
    float co = 0.0;


    for( int i=0; i<256; i++ )
    {
        if( m2<1024.0 )
        {
	    vec2 dd = 0.01*vec2(float(i), float(-i));
            z = dd+cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );
            m2 = dot(z,z);
            co += 1.0;
        }
    }

    co = co + 1.0 - log2(.5*log2(m2));

    co = sqrt(co/256.0);
    gl_FragColor = vec4( .5+.5*cos(6.2831*co+0.0),
                         .5+.5*cos(6.2831*co+0.4),
                         .5+.5*cos(6.2831*co+0.7),
                         1.0 );
}