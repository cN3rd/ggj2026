shader_type canvas_item;
render_mode skip_vertex_transform;

void vertex() {
	VERTEX = MODEL_MATRIX[3].xy + VERTEX;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
