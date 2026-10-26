shader_type canvas_item;

// Cores
uniform vec4 text_color : source_color = vec4(0.97, 0.77, 0.24, 1.0); // Amarelo do topo
uniform vec4 dot_color : source_color = vec4(0.85, 0.40, 0.10, 1.0);  // Laranja da base

// Tamanho dos pontos nas extremidades
uniform float max_dot_size : hint_range(0.05, 0.9) = 0.65;             // Tamanho MÁXIMO da bolinha
uniform float min_dot_size : hint_range(0.0, 0.9) = 0.0;               // Tamanho MÍNIMO da bolinha

// Densidade global
uniform vec2 dot_density = vec2(60.0, 40.0);                          

// CONTROLES DE CORREÇÃO DO DEGRADÊ
uniform float gradient_start : hint_range(0.0, 1.0) = 0.2;            // Ponto onde as bolinhas começam a sumir (topo do número)
uniform float gradient_end : hint_range(0.0, 1.0) = 0.8;              // Ponto onde as bolinhas atingem tamanho máximo (base do número)
uniform float gradient_power : hint_range(0.1, 5.0) = 1.0;            // Contraste/Curva de transição do degradê

void fragment() {
	vec4 orig_color = texture(TEXTURE, UV);
	
	// Se for pixel transparente, não desenha nada
	if (orig_color.a < 0.01) {
		discard;
	}
	
	// Aplica o padrão de bolinhas estático que você escolheu
	vec2 st = SCREEN_UV * dot_density;
	vec2 grid = fract(st) - vec2(0.5);
	float dist_to_center = length(grid);
	
	float normalized_y = clamp((UV.y - gradient_start) / (gradient_end - gradient_start), 0.0, 1.0);
	normalized_y = pow(normalized_y, gradient_power);
	
	float dynamic_size = mix(min_dot_size, max_dot_size, normalized_y);
	
	float edge_smooth = fwidth(dist_to_center);
	float half_tone_pattern = smoothstep(dynamic_size - edge_smooth, dynamic_size + edge_smooth, dist_to_center);
	
	vec3 final_rgb = mix(dot_color.rgb, text_color.rgb, half_tone_pattern);
	
	COLOR = vec4(final_rgb, orig_color.a);
}
