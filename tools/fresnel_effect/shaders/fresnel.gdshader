shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, cull_back, unshaded;

uniform vec3 base_color: source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 fresnel_color : source_color = vec3(0, 0, 1.0);

uniform float transparency = 0.1;
uniform float fresnel_power = 5.0;
uniform float fresnel_strength = 1.0;

vec3 fresnel_glow(float amount, float intensity, vec3 color, vec3 normal, vec3 view)
{
	return pow((1.0 - dot(normalize(normal), normalize(view))), amount) * color * intensity;
}

void fragment()
{
	vec3 fresnel = fresnel_glow(fresnel_power, fresnel_strength, fresnel_color, NORMAL, VIEW);
	ALBEDO = base_color + fresnel;
	ALPHA = transparency;
}