shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float threshold : hint_range(0.0, 1.0) = 0.5;
uniform float smoothness : hint_range(0.001, 0.5) = 0.01;
uniform float mix_amount : hint_range(0.0, 1.0) = 0.0;
// Agora vem ativado por padrão para inverter o preto e o branco
uniform bool flip_colors = true;

void fragment() {
    vec4 scene_color = texture(screen_texture, SCREEN_UV);
    
    // Calcula a luminosidade padrão (Grayscale)
    float luma = dot(scene_color.rgb, vec3(0.299, 0.587, 0.114));
    
    // Transforma em Preto ou Branco puro com base no threshold
    float bw = smoothstep(threshold - smoothness, threshold + smoothness, luma);
    
    // Se flip_colors for verdadeiro, inverte o resultado (Branco vira Preto e vice-versa)
    if (flip_colors) {
        bw = 1.0 - bw;
    }
    
    vec3 final_color = mix(scene_color.rgb, vec3(bw), mix_amount);
    COLOR = vec4(final_color, scene_color.a);
}
