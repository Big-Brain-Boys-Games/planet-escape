shader_type spatial;
render_mode cull_disabled;
render_mode depth_draw_always;
//render_mode diffuse_burley;

global uniform float wave_time;
global uniform vec4 sky_color;

uniform sampler2D heightmap : filter_linear_mipmap_anisotropic;

float get_height(vec3 pos)
{
	pos *= 0.01;
	//float magic_number = sin(pos.x * 1.6) + cos(pos.z * 1.2);
	//float z = sin(pos.z*14.0+magic_number+pos.z*9.0+sin(pos.z*20.0)*cos(TIME*0.37)+sin(pos.x*17.0)*cos(TIME*0.4)+sin(TIME*1.2) +TIME*1.6);
	//z *= 0.1;
	//z += sin(pos.x*20.0+magic_number+pos.z*12.2+sin(TIME*0.7)*0.4+TIME*2.0+pos.z*1.4)*0.05;
	//z += sin(pos.x*1.5*pos.z*1.0+sin(TIME*1.26)*0.4+TIME*2.0)*0.1;
	//z += magic_number*0.01;
	float z = 1.0 - texture(heightmap, pos.xz*1.0 + vec2(0, wave_time*0.018)).r;
	z *= 1.0 - texture(heightmap, pos.xz/1.3 + vec2(wave_time*0.01, 0)).r;
	return pow(z, 0.6)*0.15-0.05;
}


void vertex() {
	vec3 wrld_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.y += get_height(wrld_position);
	
	
	//VERTEX.y += 0.05;~
	
	// Called for every vertex the material is visible on.
}

const vec3 ign = vec3(0.06711056f, 0.00583715f, 52.9829189f);

void fragment() {
	vec3 wrld_vertex = vec4(INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float height = get_height(wrld_vertex);
	ALBEDO = mix(vec3(4, 8, 61)/255.0, vec3(59.0/255.0, 222.0/255.0, 247.0/255.0), height*20.0);
	ALBEDO.r = clamp(ALBEDO.r, 0, 1);
	ALBEDO.g = clamp(ALBEDO.g, 0, 1);
	ALBEDO.b = clamp(ALBEDO.b, 0, 1);
	// Called for every pixel the material is visible on.
	
	float alpha = distance(CAMERA_POSITION_WORLD, wrld_vertex)*3.0;
	
	alpha *= clamp(0.6+dot(NORMAL, -VIEW), 0.3, 1);
	
	alpha = clamp(alpha, 0, 1);
	//if (alpha < 0.001 || alpha < fract(ign.z * fract(dot(FRAGCOORD.xy, ign.xy)))) {
		//discard;
	//}
	
	ALBEDO *= alpha;
	ALPHA = alpha;
	
	SPECULAR = 0.7;
	ROUGHNESS = 0.3;
	METALLIC = 0.4;
	//RIM = 0.5;
	//CLEARCOAT = 0.9;
	//ANISOTROPY = -0.5;
	//SSS_STRENGTH = 0.5;
	
	
	float texel_size = 4.0;
	
	float h_l = get_height(wrld_vertex + vec3(-texel_size, 0.0, 0.0));
    float h_r = get_height(wrld_vertex + vec3(texel_size, 0.0, 0.0));
    float h_d = get_height(wrld_vertex + vec3(0.0, 0.0, -texel_size));
    float h_u = get_height(wrld_vertex + vec3(0.0, 0.0, texel_size));

	float height_scale = 20.0;
	float terrain_size = 0.2;
	
    // Normal calculation (Model Space)
    vec3 n = normalize(vec3((h_l - h_r) * height_scale, 2.0 * (terrain_size * texel_size), (h_d - h_u) * height_scale));
    
    // Derive Tangent and Bitangent based on the calculated Normal
    vec3 t = normalize(vec3(1.0, 0.0, 0.0)); 
    t = normalize(cross(t, n));
    vec3 b = cross(n, t);


    NORMAL = (VIEW_MATRIX * (MODEL_MATRIX * vec4(n, 0.0))).xyz;
    TANGENT = (VIEW_MATRIX * (MODEL_MATRIX * vec4(t, 0.0))).xyz;
    BINORMAL = (VIEW_MATRIX * (MODEL_MATRIX * vec4(b, 0.0))).xyz;
	
    
    // Use a small offset for better precision
    
	
	if (!FRONT_FACING) {
		//ALPHA = 0.4;
		NORMAL = -NORMAL;
		
		float f = dot(normalize(NORMAL), normalize(VIEW));
		
		if(f > 0.3 - (CAMERA_POSITION_WORLD.y-128.0)/80.0)
		{
			EMISSION = sky_color.rgb;
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
