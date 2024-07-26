#include <flutter/runtime_effect.glsl>

uniform vec2 u_size;
uniform vec2 u_location;
uniform vec2 u_velocity;
uniform sampler2D u_texture;

out vec4 frag_color;

void main() {
  vec2 l = u_location;
  vec2 v = u_velocity;
  vec2 p = FlutterFragCoord().xy;


  vec2 m = -v * pow(clamp(1.0 - length(l - p) / 190, 0.0, 1.0), 2) * 1.5 ;
  
  vec3 c = vec3(0.0);

  for (int i = 0; i < 10; i++) {
    float s = 0.175 + 0.005 * i;
      c += vec3(
          texture(u_texture, (p + s * m) / u_size).r, 
         texture(u_texture, (p + (s + 0.035) * m) / u_size).g, 
          texture(u_texture, (p + (s + 0.06) * m) / u_size).b
      );
    }
    
    frag_color = vec4(c / 10.0, 1.0);
}