shader_type canvas_item;

void fragment() {
	vec2 moving_uv = vec2(UV.x - TIME * 2.0, UV.y);
	vec4 colour = texture(TEXTURE, moving_uv);
	
	if (colour.a > 0.0) {
		colour.a = 0.3;
	}
	
	COLOR = colour;
}
