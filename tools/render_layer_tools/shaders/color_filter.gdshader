shader_type spatial;

render_mode cull_back, depth_prepass_alpha;

instance uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
instance uniform int color_mode : hint_enum("Grayscale", "Grayscale + Tint", "Tint Only", "Full Texture") = 0;
instance uniform bool use_emission = false;

uniform sampler2D albedo_texture : source_color;
uniform sampler2D emission_texture : source_color;
uniform sampler2D normal_texture : hint_normal;

uniform bool tint_as_emission = false;

instance uniform vec3 sphere_center = vec3(0.0, 0.0, 0.0);
instance uniform float sphere_radius = 1.0;

void fragment() {
    vec4 tex_color = texture(albedo_texture, UV);
    vec3 final_color;

	vec4 world_pos_homogenous = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0));
    vec3 world_pos = world_pos_homogenous.xyz / world_pos_homogenous.w;
    bool inside_sphere = sphere_radius > 0.0 && distance(world_pos, sphere_center) <= sphere_radius;

    if (inside_sphere) {
		if( color_mode == 3) {
		  	final_color = tex_color.rgb;
		} else {
			final_color = tint_color.rgb;
		}
    } else {
        if (color_mode == 0) {
            float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
            final_color = vec3(gray);
        } else if (color_mode == 1) {
            float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
            final_color = vec3(gray) * tint_color.rgb;
        } else if (color_mode == 2) {
            final_color = tint_color.rgb;
        }
    }

    ALBEDO = final_color;
    ALPHA = max(tex_color.a,tint_color.a);
    NORMAL_MAP = texture(normal_texture, UV).xyz;

    if (use_emission) {
        vec3 emission = texture(emission_texture, UV).rgb;
        if (tint_as_emission) {
            emission = tint_color.rgb;
        }
        EMISSION = emission;
    }
}
