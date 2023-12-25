shader_type spatial;
render_mode unshaded;

uniform sampler2D TEX: hint_screen_texture;

void fragment() {
	ALBEDO = texture(TEX, SCREEN_UV).rgb;
}