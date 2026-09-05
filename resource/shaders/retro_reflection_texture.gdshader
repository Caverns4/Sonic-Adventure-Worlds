shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_disabled, vertex_lighting;

uniform sampler2D albedo_tex: source_color;
uniform vec3 albedo_color : source_color;

void fragment() {
	vec3 n = normalize(NORMAL);
	vec3 v = normalize(VIEW);
	vec3 ref_dir = reflect(-v, n);
	
	float map_to_sphere = 2.0 * sqrt(
		ref_dir.x * ref_dir.x + ref_dir.y * ref_dir.y +
		(ref_dir.z + 1.0) * (ref_dir.z + 1.0));
	vec2 sphere_uv = ref_dir.xy / map_to_sphere + 0.5;
	
	vec3 reflection = texture(albedo_tex,sphere_uv).rgb;

	ALBEDO = albedo_color * reflection;
	SPECULAR = 0.0;
}
