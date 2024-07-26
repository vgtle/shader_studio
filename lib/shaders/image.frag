#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 mousePosition;
uniform sampler2D uTexture;

out vec4 fragColor;

void main() {
  vec2 uv = FlutterFragCoord().xy / uSize;
  if (abs(mousePosition.x - uv.x) < 0.05 && abs(mousePosition.y - uv.y) < 0.05) {
    uv.y = uv.y + 0.03;
    fragColor = texture(uTexture, uv);
  } else {
    fragColor = texture(uTexture, uv);
  }
}