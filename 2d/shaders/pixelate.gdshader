shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int amount = 4;

void fragment()
{
	float amt = float(amount);
	vec2 uv_new = SCREEN_UV - mod(SCREEN_UV, 1.0 / vec2(640., 360.) * amt);
	COLOR = textureLod(screen_texture, uv_new, 0.0);
}
