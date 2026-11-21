shader_type canvas_item;

void fragment() {
	vec4 texel = texture(TEXTURE, UV);
	// The supplied artwork has a nearly black background instead of transparency.
	texel.a *= step(0.08, max(texel.r, max(texel.g, texel.b)));
	// Keep the cool gray rock and snow; let the board supply grass and soil.
	// Drawing the image's own soil would cover the next hex and look raised.
	texel.a *= step(max(texel.r, texel.g) - 0.015, texel.b);
	COLOR = texel;
}
