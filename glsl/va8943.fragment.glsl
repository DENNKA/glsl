
//
// Thematica : 4 couronnes
// Credit: http://glsl.heroku.com/e#8774.0 et d'autres!

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const int nn=5;
vec3 rotX(vec3 v, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    mat3 mx=mat3(1.0,0.0,0.0,0.0,c,-s,0.0,s,c);
   return mx*v;
}
vec3 rotY(vec3 v, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    mat3 my=mat3(c,0.0,-s,0.0,1.0,0.0,s,0.0,c);
   return my*v;
}
vec3 rotZ(vec3 v, float angle)
{
    float s = sin(angle);
    float c = cos(angle);
    mat3 mz=mat3(c,-s,0.0,  s,c,0.0,  0.0,0.0,1.0);
   return mz*v;
}
mat3 rot(vec3 axe, float angle)
{ 
   
    float s = sin(angle);
    float c = cos(angle);
    float d = 1.0 - c;
    axe = normalize(axe);
    float x=axe.x;
    float y=axe.y;
    float z=axe.z; 
    return  mat3(
   	d * x * x + c      , d * x * y - z * s ,  d * z * x + y * s,
               d * x * y + z * s,  d * y * y + c     ,  d * y * z - x * s,
               d * z * x - y * s ,  d * y * z + x * s,  d * z * z + c      );         
}



float pointToTore( vec3 p, float gr, float r){
	
	return length(vec2(length(p.xz)-gr,p.y))-r;


}
float pointToBox(vec3 p, vec3 c){
 return length(max(abs(p)-c,0.0)); 
}
float pointToSphere(vec3 p, float r){
 return length(p)-r; 
}
float pointToCylindre(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.xz);
float k=(r<ra)? length(vec2(ra-r,pa.y-h)) : pa.y-h-0.001;
 return (pa.y<h)?(ra-r) : k;


}
float tourneCouronne(vec3 pos,vec3 axe, vec3 milieu)
{	mat3 m=rot(axe,time);
	vec3 po=pos+milieu;
	po=m*po-milieu;
	vec3 dim=vec3(0.2,0.05,0.2);
	float r1= pointToCylindre(po,0.04,0.16 );
	float r2= pointToCylindre(po,0.05,0.15);
	return max(-r2,r1);}

vec2 map( vec3 pos )
{	
	float r3=pointToSphere(pos,0.05);
	 float r=tourneCouronne(pos,vec3(1.0,0.0,-1.0),vec3(0.1,0.0,0.1));
	 r=min(r,r3);
	  float r4=tourneCouronne(pos,vec3(1.0,0.0,1.0),vec3(-0.1,0.0,0.1));
	   r=min(r,r4);
	    float r5=tourneCouronne(pos,vec3(-1.0,0.0,1.0),vec3(-0.1,0.0,-0.1));
	   r=min(r,r5); 
	    float r6=tourneCouronne(pos,vec3(-1.0,0.0,-1.0),vec3(0.1,0.0,-0.1));
	   r=min(r,r6); 
    	return vec2(r,1.0);
}

vec3 calcNormal( in vec3 pos)
{
	vec3 eps = vec3( 0.001, 0.0, 0.0 );
	vec3 nor = vec3(
	    map(pos+eps.xyy).x - map(pos-eps.xyy).x,
	    map(pos+eps.yxy).x - map(pos-eps.yxy).x,
	    map(pos+eps.yyx).x - map(pos-eps.yyx).x );
	return normalize(nor);
}


vec2 castRay( in vec3 ro, in vec3 rd, in float maxd )
{
    float precis = 0.001;
    float h=precis*2.0;
    float t = 0.0;
    float m = -1.0;
    for( int i=0; i<60; i++ )
    {
        if( abs(h)<precis||t>maxd ) break;
        t += h;
	    vec2 res = map( ro+rd*t );
        h = res.x;
	    m = res.y;
    }

    if( t>maxd ) m=-1.0;
    return vec2( t, m );
}


vec3 render( in vec3 ro, in vec3 rd )
{ 
   vec3 col = vec3(0.0);
   vec2 res = castRay(ro,rd,20.0);
   float t = res.x;
   float m = res.y;
   if( m>-0.5 )
   {
      vec3 pos = ro + t*rd;
      vec3 nor = calcNormal( pos );

      col =nor* dot(nor,pos) ;
		
		
   }
   
   col *=exp(-0.01*t*t)+1.0;


   return vec3(sqrt(clamp(col,0.0,1.0) ));
}

void main( void ) {

   vec2 q = gl_FragCoord.xy/resolution.xy;
   vec2 p = -1.0+2.0*q;
   p.x *= resolution.x/resolution.y;
	
   // camera	
   vec3 ro = vec3( mouse.x, mouse.y , mouse.x);	
   vec3 ta = vec3( 0.0, 0.0, 0.0 );
	
   // camera tx
   vec3 cw = normalize( ta-ro );
   vec3 cp = vec3( 0.0, 1.0, 0.0 );
   vec3 cu = normalize( cross(cw,cp) );
   vec3 cv = normalize( cross(cu,cw) );
   vec3 rd = normalize( p.x*cu + p.y*cv + 2.5*cw );

   vec3 col = render( ro, rd );
   gl_FragColor=vec4( col, 1.0 );
	}
