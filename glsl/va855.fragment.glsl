//
// some mandelbulb
// 
// colored by @hintz using: http://glsl.heroku.com/e#774.11

#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution, mouse;

vec3 rotatey(vec3 r, float v)
{
  return vec3(r.x*cos(v)+r.z*sin(v),r.y,r.z*cos(v)-r.x*sin(v)); 
}
vec3 rotatex(vec3 r, float v) 
{
  return vec3(r.y*cos(v)+r.z*sin(v),r.x,r.z*cos(v)-r.y*sin(v)); 
}

float terrain(vec3 pos) 
{
    vec3 z = pos*0.00003;
    vec3 c = z*(3.0+vec3(sin(time/15.0)*0.66,sin(time/15.0)*0.1,sin(time/15.0)));
    float r = 0.0;
    
    for (float count=0.0; count<5.0; count+=1.0)
    {
        vec3 z2 = z*z;
        r = sqrt(dot(z,z));
        if (r>2.0) 
	{
            break;
        }
        float planeXY = sqrt(z2.x+z2.y)+0.0000001;
        r += 0.0000001;
        float sinPhi = z.y/planeXY;
        float cosPhi = z.x/planeXY;
        float sinThe = planeXY/r;
        float cosThe = z.z/r;
        //level 1
        sinPhi = 2.0 * sinPhi * cosPhi;
        cosPhi = 2.0 * cosPhi * cosPhi - 1.0;
        sinThe = 2.0 * sinThe * cosThe;
        cosThe = 2.0 * cosThe * cosThe - 1.0;
        //level 2.
        sinPhi = 2.0 * sinPhi * cosPhi;
        cosPhi = 2.0 * cosPhi * cosPhi - 1.0;
        sinThe = 2.0 * sinThe * cosThe;
        cosThe = 2.0 * cosThe * cosThe - 1.0;
        //level 3.
        sinPhi = 2.0 * sinPhi * cosPhi;
        cosPhi = 2.0 * cosPhi * cosPhi - 1.0;
        sinThe = 2.0 * sinThe * cosThe;
        cosThe = 2.0 * cosThe * cosThe - 1.0;
        
        float rPow = pow(r, 8.0);
        z.x = sinThe * cosPhi;
        z.y = sinThe * sinPhi;
        z.z = cosThe;
        z *= rPow;
        z += c;
    }
    return r- 2.0;
}

vec3 shootRay(vec3 cam,vec3 ray)
{
  vec3 step = ray * 100.0;
  vec3 test = cam + ray*10000.0;
  
  for (int i = 0; i<50; i++)
  {
    test -= step * terrain(test);
  }

  return test; 
}

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t)
{
  float xx=x+sin(t*fx)*cos(t*sx)/mouse.x;
  float yy=y+cos(t*fy)*sin(t*sy)/mouse.y;
  
  return 0.4/sqrt(abs(xx*xx+yy*yy));
}

void main()
{  
  vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

  float x=2.0*p.x;
  float y=2.0*p.y;
  
  float a=makePoint(x,y,3.3,2.9,1.3,0.3,time);
  a+=makePoint(x,y,1.9,2.0,0.4,0.4,time);
  a+=makePoint(x,y,0.2,0.7,0.4,0.5,time);
  a+=makePoint(x,y,2.3,0.1,0.6,1.3,time);
  a+=makePoint(x,y,0.8,1.7,0.5,0.4,time);
  a+=makePoint(x,y,0.3,1.0,0.4,0.4,time);
  a+=makePoint(x,y,1.4,1.3,0.4,1.5,time);
  a+=makePoint(x,y,1.3,2.1,0.6,0.3,time);
  a+=makePoint(x,y,1.8,1.4,0.5,1.4,time);   
  
  float b=makePoint(x,y,1.2,1.9,0.3,0.3,time);
  b+=makePoint(x,y,0.7,2.7,0.4,4.0,time);
  b+=makePoint(x,y,1.4,0.6,0.4,0.5,time);
  b+=makePoint(x,y,2.6,0.4,0.6,0.3,time);
  b+=makePoint(x,y,0.1,1.4,0.5,0.4,time);
  b+=makePoint(x,y,0.7,1.7,0.4,0.4,time);
  b+=makePoint(x,y,0.8,0.5,0.4,0.5,time);
  b+=makePoint(x,y,1.4,0.9,0.6,0.3,time);
  b+=makePoint(x,y,0.7,1.3,0.5,0.4,time);

  float c=makePoint(x,y,3.7,0.3,0.3,0.3,time);
  c+=makePoint(x,y,1.9,1.3,0.4,0.4,time);
  c+=makePoint(x,y,0.8,0.9,0.4,0.5,time);
  c+=makePoint(x,y,1.2,1.7,0.6,0.3,time);
  c+=makePoint(x,y,0.3,0.6,0.5,0.4,time);
  c+=makePoint(x,y,0.3,0.3,0.4,0.4,time);
  c+=makePoint(x,y,1.4,0.8,0.4,0.5,time);
  c+=makePoint(x,y,0.2,0.6,0.6,0.3,time);
  c+=makePoint(x,y,1.3,0.5,0.5,0.4,time);
   
  vec3 d=vec3(b*c,a*c,a*b)*0.01;
   
  vec2 m = mouse.xy - 0.5;
  float t = time*0.2;
  vec3 campos = vec3(3.0 * cos(t), 3.0 * sin(t*0.8), 3.0 * sin(t*0.7));
  vec3 raydir = normalize(vec3(0.0,0.0,1.0));
  raydir = rotatey(raydir, m.x);  
  raydir = rotatex(raydir, m.y);  
  raydir = rotatey(raydir, p.y);
  raydir = rotatex(raydir, p.x);
  vec3 hit = shootRay(campos,raydir);
 
 // float bump = abs(sin(hit.z*0.002)+(sin(hit.x*0.002)+sin(hit.y*0.002)));
 // hit += bump*100.0;
 
  float axe=1.0;
  float vx = terrain(hit+vec3(-axe, 0.0, 0.0))-terrain(hit+vec3( axe, 0.0, 0.0));
  float vy = terrain(hit+vec3( 0.0,-axe, 0.0))-terrain(hit+vec3( 0.0, axe, 0.0));
  float vz = terrain(hit+vec3( 0.0, 0.0,-axe))-terrain(hit+vec3( 0.0, 0.0, axe));
  
  vec3 n  = normalize(vec3(vx,vy,vz));
  vec3 ln1 = normalize(vec3(cos(t),sin(t*3.0)*1.0,-0.1));
  vec3 lp2 = vec3(sin(t*7.9),sin(t*10.8),sin(t*7.3)+4.0)*10000.0;
  vec3 ln2 = normalize(lp2-hit);
  float ld2 = max(0.0, 9000.0 / distance(lp2,hit));
  
  vec3 col = d;// + (bump*bump)* 0.03; 
  col += mix(vec3(0.5,0.5,0.5),vec3(0.3,0.4,0.5),1.0);  
  col += max(0.0,dot(n,ln1)) * vec3(0.6,0.4,0.1);
  col += max(0.0,dot(n,ln2)) * vec3(4.5,3.4,2.6) * (ld2*ld2);
  
  float fog = max(0.0,min(1.0, (7000.0 / distance(campos,hit)))); 
  
  gl_FragColor = vec4(col*fog+d, 1.0);
}
