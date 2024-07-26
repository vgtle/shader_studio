#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uLocation;
uniform vec2 uLazy;

out vec4 frag_color;

void main() {
  vec2 l = uLocation;
  vec2 m = uLazy ;
  vec2 p = FlutterFragCoord().xy ;
  float t = length(uSize - uSize);
  if (length(m - p ) < 30){
    frag_color = vec4(1.0, 0.0, t, 1);
    return;
  }

  if (length(l - p ) < 30){
    frag_color = vec4(0.0, 1.0, 0.0, 1);
    return;
  }

  frag_color = vec4(0.0, 0.0, 0.0, 0);

  //    if (length(l - p ) > length(m)){
  //     float distance =  length(l - p ) / length(m);
  //     frag_color = vec4(0.0, 0.0, 0.0, 0);
  //     return;
  // } else {
  //     float distance =  length(l - p ) / length(m);

  //     frag_color = vec4(0, 0, 0, 1 - distance);
  //     return;
  // }

}