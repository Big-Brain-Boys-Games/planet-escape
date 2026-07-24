shader_type spatial;
render_mode world_vertex_coords;
render_mode cull_disabled;


uniform vec3 color : source_color;
uniform float sway_factor;
uniform float sway_scale;
uniform float roughness;
uniform float metalic;

void vertex() {
	VERTEX.x += sin(VERTEX.y*sway_scale+TIME*0.7+VERTEX.x*0.3)*sway_factor;
	VERTEX.z += cos(VERTEX.y*sway_scale+TIME*0.3+VERTEX.z*0.1)*sway_factor;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color;
	ROUGHNESS = roughness;
	METALLIC = metalic;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
