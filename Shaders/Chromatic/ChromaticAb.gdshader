shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;
uniform float amount = 1.0;
uniform sampler2D offset_texture: hint_default_white;

void fragment() {
  vec4 color = textureLod(screen_texture, UV, 0.0);

  float adjusted_amount = amount * texture(offset_texture, UV).r / 100.0;

  color.r = textureLod(screen_texture, vec2(UV.x + adjusted_amount, UV.y), 0.0).r;
  color.g = textureLod(screen_texture, UV, 0.0).g;
  color.b = textureLod(screen_texture, vec2(UV.x - adjusted_amount, UV.y), 0.0).b;

  COLOR = color;
}