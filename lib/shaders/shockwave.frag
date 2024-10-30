#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

uniform sampler2D uTexture;
out vec4 frag_color;

float shockwaveDistance(float time, vec2 p) {
    float distanceFromBottom = length(p - vec2(0.5, 1.3));

    float e = 2.718281828459045;
    float inRadius = pow(e, -pow(-1 + distanceFromBottom * -1 + time  * 12, 2));
    return abs(inRadius);
}

void main() {
     vec2 p = FlutterFragCoord().xy / uSize;
    float x = uTime / 1.5;
    float time = (x < 0.5
  ? (1 - sqrt(1 - pow(2 * x, 2))) / 2
  : (sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2);
    vec2 direction = normalize(vec2(0.5, 1.3 ) - p);
    float offset = shockwaveDistance(x , p);
    vec4 pNew = texture(uTexture, p + direction * offset * 0.07) + offset * 0.3;
    frag_color = vec4(pNew.xyz,1) ;
   
}

