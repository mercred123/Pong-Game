shader_type canvas_item;

// Sur Godot 4, le hint s'écrit "source_color". 
// On renomme les variables pour éviter tout conflit avec le mot-clé du hint.
uniform vec4 from_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 to_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Si la couleur source ciblée est proche du noir
    if (length(from_color.rgb) < 0.01) {
        // Calcule la brillance (0.0 pour du noir, 1.0 pour du blanc)
        float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
        // Plus le pixel est noir, plus il prend la couleur cible
        vec3 final_rgb = mix(to_color.rgb, tex_color.rgb, luminance);
        COLOR = vec4(final_rgb, tex_color.a * to_color.a);
    } else {
        // Teinte relative basée sur le rapport entre la couleur actuelle et la couleur voulue
        vec3 tint_factor = to_color.rgb / max(from_color.rgb, vec3(0.001));
        COLOR = vec4(tex_color.rgb * tint_factor, tex_color.a * to_color.a);
    }
}