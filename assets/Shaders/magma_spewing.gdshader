shader_type spatial;

//render_mode unshaded;

uniform sampler2D tex : filter_linear_mipmap_anisotropic;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x *= 0.2 * (VERTEX.y + 17.0) + sin(TIME*8.0 - VERTEX.y*0.7)*0.3;
	VERTEX.z *= 0.2 * (VERTEX.y + 17.0) + sin(TIME*8.0 - VERTEX.y*0.7)*0.3;
}

void fragment() {
	ALBEDO = texture(tex, (UV*5.0 + vec2(0, TIME*1.1)) * vec2(1, 5)).rgb;
	ALBEDO *= texture(tex, (UV*1.0 + vec2(0, TIME*0.8)) * vec2(1, 5)).rgb;
	ALBEDO.r = pow(ALBEDO.r, 0.5);
	ALBEDO.g = pow(ALBEDO.g, 0.5);
	ALBEDO.b = pow(ALBEDO.b, 0.5);
	
	float factor = 3.0;
	EMISSION.r = pow(ALBEDO.r, factor);
	EMISSION.g = pow(ALBEDO.g, factor);
	EMISSION.b = pow(ALBEDO.b, factor);
	EMISSION *= 2.0;
	ALBEDO *= 0.3;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
