shader_type canvas_item;

varying vec4 modulate;

void vertex() {
	// Get original modulate
	 modulate = COLOR;
}

void fragment() {
	// Move UV
	vec2 moving_uv = vec2(UV.x - TIME * 2.0, UV.y);
	vec4 colour = texture(TEXTURE, moving_uv);
	
	// Apply original modulate
	if (colour.a > 0.0) {
		colour.a = modulate.a;
	}
	
	COLOR = colour;
}
