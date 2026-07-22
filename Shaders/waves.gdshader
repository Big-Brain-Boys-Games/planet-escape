shader_type spatial;
render_mode cull_disabled;

void vertex() {
	vec3 pos = VERTEX + NODE_POSITION_WORLD*0.25;
	float magic_number = sin(pos.x * 1.6) + cos(pos.z * 1.2);
	float z = sin(pos.z*14.0+magic_number+pos.z*9.0+sin(pos.z*20.0)*cos(TIME*0.37)+sin(pos.x*17.0)*cos(TIME*0.4)+sin(TIME*1.2) +TIME*1.6);
	z *= 0.1;
	z += sin(pos.x*20.0+magic_number+pos.z*12.2+sin(TIME*0.7)*0.4+TIME*2.0+pos.z*1.4)*0.05;
	z += sin(pos.x*1.5*pos.z*1.0+sin(TIME*1.26)*0.4+TIME*2.0)*0.1;
	z += magic_number*0.01;
	VERTEX.y = pow(z, 2);
	//VERTEX.y += 0.05;~
	
	// Called for every vertex the material is visible on.
}

const vec3 ign = vec3(0.06711056f, 0.00583715f, 52.9829189f);

void fragment() {
	vec3 wrld_vertex = vec4(INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALBEDO = mix(vec3(4, 8, 61)/255.0, vec3(59.0/255.0, 222.0/255.0, 247.0/255.0), wrld_vertex.y);
	ALBEDO.r = clamp(ALBEDO.r, 0, 1);
	ALBEDO.g = clamp(ALBEDO.g, 0, 1);
	ALBEDO.b = clamp(ALBEDO.b, 0, 1);
	// Called for every pixel the material is visible on.
	
	float alpha = distance(CAMERA_POSITION_WORLD, wrld_vertex)*3.0;
	alpha = clamp(alpha, 0, 1);
	if (alpha < 0.001 || alpha < fract(ign.z * fract(dot(FRAGCOORD.xy, ign.xy)))) {
		discard;
	}
	
	if (!FRONT_FACING) {
		NORMAL = -NORMAL;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
