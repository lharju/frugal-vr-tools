shader_type spatial;
render_mode unshaded, shadows_disabled, ambient_light_disabled, fog_disabled;

uniform vec3 color : source_color = vec3(1.0);
uniform int repeat = 10; 
uniform float grid = 0.1;

void fragment() {
	vec2 uv = UV * vec2(3.0, 2.0) * float(repeat);
	ALBEDO = color * step(min(-cos(uv.x * TAU), -cos(uv.y * TAU)) * 0.5 + 0.5, grid);
}
