
//CubesINTore
// Thematica : Circulation dans un Tore
// Credit: http://glsl.heroku.com/e#8774.0 

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float gr=3.5;
const float pr=2.5;
const float cot=0.6;
const  float pi=3.1415926;

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




float pointToBox(vec3 p, float c){
 return length(max(abs(p)-c,0.0)); 
}
float pointToTore( vec3 p){
	
	return pr-length(vec2(length(p.xz)-gr,p.y));
}
float sdBox( vec3 p, float b )
{
  vec3 d = abs(p) -vec3(b);
  return min(max(d.x,max(d.y,d.z)),0.0) +
         length(max(d,0.0));
}
float sdTorus( vec3 p, vec2 t )
{
  vec2 q = vec2(length(p.xz)-t.x,p.y);
  return length(q)-t.y;
}

vec4 pointToObjects( vec3 p )
{	                     
float q=pi*2.0/float(3.0);
vec4 dists;
float temps=time*0.6;
 dists.w= pointToTore(p);	 
 float i=1.0; dists.x=sdBox(rotZ(rotY(p,temps+q*i)-vec3(gr,0.0,0.0),2.0*temps+2.0*q*i)-vec3(0.0,pr-cot,0.0), cot); 
i+=1.0;       dists.y=sdBox(rotZ(rotY(p,temps+q*i)-vec3(gr,0.0,0.0),2.0*temps+2.0*q*i)-vec3(0.0,pr-cot,0.0), cot); 
i+=1.0;       dists.z=sdBox(rotZ(rotY(p,temps+q*i)-vec3(gr,0.0,0.0),2.0*temps+2.0*q*i)-vec3(0.0,pr-cot,0.0), cot); 


    return dists;  
}

vec2 map( in vec3 pos )
{	
	vec4 res = pointToObjects(pos);
	float d=30.0, m=-1.0;
	if (res.w<d)  {d=res.w;  m=0.0;}
  	if(res.x<d)    {d=res.x;   m=1.0;}
  	if(res.y<d)    {d=res.y;   m=2.0;}
  	if(res.z<d)    {d=res.z;   m=3.0;}
 
    	return vec2(d,m);
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


vec2 marching( in vec3 ro, in vec3 rd, in float maxd )
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
   vec2 res = marching(ro,rd,20.0);
    float t = res.x;
   float m = res.y;
   if( m<-0.5 )  
  	 {col=vec3(0.5); } 
   else
  	 {if(abs(m)<0.01)
  	 	{
  	 	vec3 pos = ro +t*rd;
    
  	 	float alpha=atan(pos.z,pos.x);
  	 	float beta=atan(pos.y,(sin(alpha)+cos(alpha))*pos.y-gr);
  	 	col=vec3(step(mod(alpha+beta,pi/6.0),pi/12.0));
  	 	vec3 no= calcNormal(pos);
  	 	col=dot(col,no)*no;
  	 	}
  	 	else
  	 	{
  	 	col=vec3(cos(pi*m/6.0),sin(pi*m/6.0),1.0-sin(pi*m/6.0)); 
  	 	vec3 np= calcNormal(ro+t*rd);
  	 	col=abs(dot(col,np)*np);
  	 	}
  	 }
   return vec3(sqrt(clamp(col,0.0,1.0) ));
}                                                                                       
  

  

void main( void ) {

   vec2 q = gl_FragCoord.xy/resolution.xy;
   vec2 p = -1.0+2.0*q;
   p.x *= resolution.x/resolution.y;
  
 
// camera
	float time0=-time*0.8;
	vec2 angles=vec2((0.5-mouse.y)*1.5,(mouse.x-1.5)*1.5);
	vec3 ro =rotY(vec3(3.5,0.0,0.0),time0);
	float focale=0.8;
	vec3 v1=rotY(vec3(p.x,p.y,focale),time0 );
	v1=rotX(rotY(v1,angles.y),angles.x);
	vec3 rd = normalize(v1);
	vec3 col = render( ro, rd);
	gl_FragColor=vec4( col, 1.0 );	
   }
   
   