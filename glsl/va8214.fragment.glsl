//@T_SRTX1911

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;



const int raytraceDepth = 8;

struct Ray{
	vec3 org;
	vec3 dir;
};

struct Sphere{
	vec3 c;
	float r;
	vec3 col;
};

struct Plane{
	vec3 p;
	vec3 n;
	vec3 col;
};
	
struct Intersection{
	float t;
	vec3 p; //hit point
	vec3 n; //normal
	int hit;
	vec3 col;
};

	


void sphere_intersect(Sphere s, Ray ray, inout Intersection isect){
	vec3 rs = ray.org - s.c;
	float B = dot(rs, ray.dir);
	float C = dot(rs, rs) - (s.r * s.r);
	float D = B * B - C;
	
	if(D > 0.0){
		float t = -B - sqrt(D);
		if((t > 0.0) && (t < isect.t)){
			
			isect.t = t;
			isect.hit = 1;
		
			//Clac normal
			vec3 p = vec3(ray.org.x + ray.dir.x * t,
				      ray.org.y + ray.dir.y * t,
				      ray.org.z + ray.dir.z * t);
			vec3 n = p - s.c;
			n = normalize(n);
			isect.n = n;
			isect.p = p;
			isect.col = s.col;
		}
	}
}




void plane_intersect(Plane pl, Ray ray, inout Intersection isect){
	//d = -(p . n);
	//t = -(ray.org . n + d) / (ray.dir . n);
	float d = -dot(pl.p, pl.n);
	float v = dot(ray.dir, pl.n);
	
	if(abs(v) < 1.0e-6) return; //the plane is parallel to the ray.
	
	float t = -(dot(ray.org, pl.n) + d) / v;
	
	if((t > 0.0) && (t < isect.t)){
		isect.hit = 1;
		isect.t = t;
		isect.n = pl.n;
		
		vec3 p = vec3(ray.org.x + t * ray.dir.x,
			      ray.org.y + t * ray.dir.y, 
			      ray.org.z + t * ray.dir.z);
		isect.p = p;
		float offset = 0.2;
		vec3 dp = p + offset;

		if((mod(dp.x, 1.0) > 0.5 && mod(dp.z, 1.0) > 0.5) ||
		   (mod(dp.x, 1.0) < 0.5 && mod(dp.z, 1.0) < 0.5))
			isect.col = pl.col;
		else
			isect.col = pl.col * 0.5;
	}
}




Sphere sphere[3];
Plane plane;
void Intersect(Ray r, inout Intersection i){
	for(int c = 0; c < 3; c++){
		sphere_intersect(sphere[c], r, i);
	}
	plane_intersect(plane, r, i);
}




int seed = 0;
float random()
{
        seed = int(mod(float(seed)*1364.0+626.0, 509.0));
        return float(seed)/509.0;
}
vec3 computeLightShadow(in Intersection isect)
{
        int i, j;
    int ntheta = 16;
    int nphi   = 16;
    float eps  = 0.000001;

    // Slightly move ray org towards ray dir to avoid numerical probrem.
    vec3 p = vec3(isect.p.x + eps * isect.n.x,
                  isect.p.y + eps * isect.n.y,
                  isect.p.z + eps * isect.n.z);

        vec3 lightPoint = vec3(5,5,5);
    Ray ray;
        ray.org = p;
        ray.dir = normalize(lightPoint - p);

        Intersection lisect;
        lisect.hit = 0;
        lisect.t = 1.0e+30;
        lisect.n = lisect.p = lisect.col = vec3(0, 0, 0);
        Intersect(ray, lisect);
        if (lisect.hit != 0)
                return vec3(0.0,0.0,0.0);
        else
        {
                float shade = max(0.0, dot(isect.n, ray.dir));
                shade = pow(shade,3.0) + shade * 0.5;
                return vec3(shade,shade,shade);
        }

}




void main( void ) {
	vec3 org = vec3(sin(time) , cos(time * 0.5) + 0.75, (sin(-0.0 * 0.25) * 5.0) - 0.0);
	vec2 position= (( gl_FragCoord.xy / resolution.xy ) * 2.0) - 1.0 ;
	vec3 dir = normalize(vec3(position.x * (resolution.x / resolution.y), position.y, -1.0));
	
	sphere[0].c 	= vec3(sin(time) * 2.5, 1.0, -3.5);
	sphere[0].r	= 1.0 + (sin(time) * 0.5);
	sphere[0].col	= vec3(1.0, 0.3, 0.3);
	
	sphere[1].c	= vec3(-0.5 + cos(time) * 3.5, sin(time) * 0.25 + 0.25, -3.0 + sin(time) * 3.5);
	sphere[1].r	= 0.5;
	sphere[1].col	= vec3(0.3, 1.0, 0.3);
	
	sphere[2].c	= vec3(1.0, 0.0, -2.2);
	sphere[2].r	= 0.5;
	sphere[2].col	= vec3(0.3, 0.3, 1.0);

	plane.p = vec3(0.0, -0.5, 0.0);
	plane.n = vec3(0.0, 1.0, 0.0);
	plane.col = vec3(1.0, 1.0, 1.0);
	
	Ray r;
	r.org = org;
	r.dir = normalize(dir);
	vec4 col = vec4(0.0, 0.0, 0.0, 1.0);
	float eps = 0.0001;
	vec3 bcol = vec3(1.0, 1.0, 1.0);
	for(int j = 0; j < raytraceDepth; ++j){
		Intersection i;
		i.hit = 0;
		i.t = 1.0e+30;
		i.n = i.p = i.col = vec3(0.0, 0.0, 0.0);
	
		Intersect(r, i);
		if(i.hit != 0){
			col.rgb += bcol * i.col * computeLightShadow(i);
			bcol *= i.col;
		}else{
			break;
		}	
		r.org = vec3(i.p.x + eps * i.n.x,
			     i.p.y + eps * i.n.y,
			     i.p.z + eps * i.n.z);
		r.dir = reflect(r.dir, vec3(i.n.x, i.n.y, i.n.z));
		
	}
	
	gl_FragColor = col.rgba;
	
}