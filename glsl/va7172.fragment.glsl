#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec3 light_pos = vec3( 100.0,100.0,-100.0 );
const vec4 cube_pos_rt = vec4( 200.0, 100.0, 0.0, 25.0 );
const float pi = 3.1415926535;

// !!!!!!!
// is this right for material colour?

const vec3 mat_ambient=vec3(0.0,0.0,0.0);
const vec3 mat_diffuse=vec3(0.0,0.0,1.0);
const vec3 mat_specular=vec3(1.0,1.0,1.0);

// also, what would be convertion from phong specular/hardness
// to roughness/reflectance (if its even possible)?

const int light_max = 4;
const int light_num = 4;
const vec3 light_0 = vec3( 10.0,10.0,10.0 );
const vec3 light_1 = vec3(-10.0,10.0,10.0 );
const vec3 light_2 = vec3( 10.0,-10.0,10.0 );
const vec3 light_3 = vec3(-10.0,-10.0,10.0 );
const vec3 light_col_0 = vec3( 1., 1., 1. );
const vec3 light_col_1 = vec3( 1.0,0.0,0.0 );
const vec3 light_col_2 = vec3( 0.0,1.0,0.0 );
const vec3 light_col_3 = vec3( 0.0,0.0,1.0 );
vec3 lights[light_max];
vec3 light_cols[light_max];

float F_Schlick( vec3 n, vec3 l, vec3 v, vec3 h, float reflectance )
{
	float xx = dot(l,h);
	return reflectance + ( 1.0 - reflectance )*pow(( 1.0-xx), 5.0 );
}

float Fresnel( vec3 n, vec3 l, vec3 v, vec3 h, float reflectance )
{
	return F_Schlick(n,l,v,h,reflectance);
}

float V_CookTorrance( vec3 n, vec3 l, vec3 v, vec3 h,float roughness )
{
	return 4.0/(dot( v+l ,v+l));
}
float V_Schlick( vec3 n, vec3 l, vec3 v, vec3 h, float roughness )
{
	float a = roughness * sqrt( 2.0/pi);
	return 1.0 / ( ( max(0.0,dot(n,l))*(1.0-a)+a) * ( max(0.0,dot(n,v))*(1.0-a)+a) );
}
float Visibility( vec3 n, vec3 l, vec3 v, vec3 h, float roughness )
{
//	return V_CookTorrance(n,l,v,h, roughness );
	return V_Schlick(n,l,v,h, roughness );
}

float D_Beckmann( vec3 n, vec3 h, float roughness )
{
	float n_h = max( 0.0, dot( n, h ) );
	return exp( ( n_h*n_h - 1.0 ) / (roughness*roughness*n_h*n_h) ) /
			   ( pi * roughness*roughness*n_h*n_h*n_h*n_h );
}

float D_BlinnPhong( vec3 n, vec3 h, float roughness )
{
	float nn = 2.0/(roughness*roughness) - 2.0;
	float n_h = max( 0.0, dot( n, h ) );
	
	return (nn + 2.)/( 2. * pi ) * pow( n_h, nn );
}

float Distribution( vec3 n, vec3 h, float roughness )
{
	return D_BlinnPhong( n, h, roughness );
	return D_Beckmann( n, h, roughness );
}

float specular( vec3 n, vec3 l, vec3 v, float roughness, float reflectance )
{
	// microfacet BRDF
	l = normalize( l );
	v = normalize( v );
	vec3 h = normalize( l + v );
	n = normalize ( n );
	return pi/4.0*reflectance*max( 0.0, dot( l, n ) )*Fresnel( n, l, v, h, reflectance ) * Visibility( n, l, v, h, roughness ) * Distribution( n, h, roughness );
}

float Diff_Lambert( vec3 n, vec3 l, vec3 v, float roughness)
{
	return 1.0 / pi * max( 0.0, dot( l, n ) );
}

float Diff_OrenNayar( vec3 n, vec3 l, vec3 v, float roughness)
{
	float a = 1.0 - 0.5*roughness*roughness/(roughness*roughness+0.33);
	float b = 0.45*roughness*roughness/(roughness*roughness+0.09);
	float cos_alpha = min( dot(n,l), dot(n,v) );
	float cos_beta = max( dot(n,l), dot(n,v) );
	
	float sin_alpha = sqrt(1.0 - cos_alpha*cos_alpha);
	float tan_beta = sqrt(1.0 - cos_beta*cos_beta)/cos_beta;
	
	vec3 outer_nv = cross(n,v);
	vec3 outer_nl = cross(n,l);
	float cos_phi_ir = dot( normalize(outer_nv), normalize(outer_nl) );
	return 1.0 / pi * max( 0.0, dot( l, n ) )*( a + ( b * max( 0.0, cos_phi_ir )*sin_alpha*tan_beta) );
}
float diffuse( vec3 n, vec3 l, vec3 v, float roughness, float reflectance )
{
	l = normalize( l );
	v = normalize( v );
	vec3 h = normalize( l + v );
	n = normalize ( n );
	float diff;
	diff= Diff_OrenNayar(n,l,v,roughness);
	diff = Diff_Lambert(n,l,v,roughness);
	diff = (1.0-reflectance*Fresnel(n,l,v,h,reflectance))*diff;
	return diff;
}

vec4 cube_normal_z( vec2 proj_pos, vec4 cube_pos_r )
{
	vec3 cube_center_to_proj = vec3( proj_pos, 0.0 ) - cube_pos_r.xyz;
	float xy2 = ( cube_center_to_proj.x * cube_center_to_proj.x +
					cube_center_to_proj.y * cube_center_to_proj.y );
	
	float r = cube_pos_r.w * cube_pos_r.w - xy2;
	if( r < 0.0 )
		return vec4(-10.0,0.0,0.0,0.0);
	
	r = sqrt(r);
	float z = cube_center_to_proj.z - r;
	
	vec4 ret = vec4( cube_center_to_proj.xy, r, z );
	
	ret.xyz = normalize(ret.xyz );
	
	return ret;
	
}

void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec3 albedo = vec3( 0.8,0.2,0.2);
	float reflectance = 0.0;
	float roughness = 0.0;
	
	vec3 accumulated_col = vec3( 0.0, 0.0, 0.0 );
	
	vec4 cube_pos_r_t = cube_pos_rt;
	lights[0] = light_0;
	lights[1] = light_1;
	lights[2] = light_2;
	lights[3] = light_3;
	light_cols[0] = light_col_0;
	light_cols[1] = light_col_1;
	light_cols[2] = light_col_2;
	light_cols[3] = light_col_3;
	
	for(int m = 0; m< light_num;m++ )
	{
		float ppp = time*1.0;
		mat2 vmat = mat2( vec2( cos(ppp), -sin(ppp)),vec2( sin(ppp) ,cos(ppp) ));
		lights[m].xz = vmat * lights[m].xz;
	}
	
	int x_index = int(gl_FragCoord.x) / int(resolution.x);
	int y_index = int(gl_FragCoord.y) / int(resolution.y);
	
	roughness = 0.1;//min( 1.0, float(x_index) * 50.0 / resolution.x );
	reflectance = 0.1;//min( 1.0, float(y_index) * 50.0 / resolution.y );
	
	cube_pos_r_t.x = (float(x_index)+0.5) * resolution.x;
	cube_pos_r_t.y = (float(y_index)+0.5) * resolution.y;

	vec4 test = cube_normal_z( gl_FragCoord.xy, cube_pos_r_t );
	if( test.x > -2.0 )
	{
		for(int l = 0; l< light_num;l++)
		{
			vec3 light_col = light_cols[l];
			vec3 light_dir = lights[l];
			vec3 diff = light_col*albedo*diffuse((test.xyz), (light_dir), vec3( 0.0,0.0,1.0), roughness, reflectance );
			vec3 spec = light_col*specular( (test.xyz), (light_dir), vec3( 0.0,0.0,1.0), roughness, reflectance );
			accumulated_col += vec3( (spec.rgb*mat_specular) + (diff.rgb*mat_diffuse) );
		}
	}
	
	gl_FragColor = vec4( pow( mat_ambient+accumulated_col, vec3(1.0/2.2,1.0/2.2,1.0/2.2)), 1.0 );
}