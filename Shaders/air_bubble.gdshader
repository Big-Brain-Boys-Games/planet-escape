shader_type spatial;

void vertex() {
	float widener = sin(TIME);
	float lengthener = cos(TIME+0.1);
	VERTEX.xz *= 1.0+widener*0.1;
	VERTEX.y *= 1.0+lengthener*0.1;
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALPHA = 0.5+dot(NORMAL, -VIEW);
	ALPHA = ALPHA + pow(abs(ALPHA), 1.4)*2.5;
	ALPHA = clamp(ALPHA, 0, 1);
	
	ROUGHNESS = 0.3;
	RIM = 0.4;
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
