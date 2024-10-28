shader_type canvas_item;

uniform sampler2D displacement_mask;

uniform float displacement_amount = 5.0f;

void fragment()
{
	vec4 displacement = texture(displacement_mask, UV);
	float uv_displace_amount = displacement_amount * 1.0f / float(textureSize(TEXTURE, 0).x);
	vec2 displacement_uv = UV + displacement.xy * uv_displace_amount;
	
	COLOR = texture(TEXTURE, displacement_uv);
}