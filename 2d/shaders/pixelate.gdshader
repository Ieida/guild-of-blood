shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 1.0;
varying mat4 mdlm;

void vertex() {
	//mdlm = ;
}

void fragment() {
	vec4 gfragcoord = mdlm * FRAGCOORD;
	float x = gfragcoord.x - mod(gfragcoord.x, pixel_size);
	float y = gfragcoord.y - mod(gfragcoord.y, pixel_size);
	float shift = floor(pixel_size / 2.0);
	COLOR = texture(TEXTURE, vec2(x + shift, y + shift) * SCREEN_PIXEL_SIZE);
}