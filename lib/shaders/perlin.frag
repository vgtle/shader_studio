#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;
uniform float bass;
uniform float lowerMid;
uniform float mid;
uniform float higherMid;
uniform float treble;
uniform float air;

uniform sampler2D uTexture;
out vec4 frag_color;



/// ==== Helpers ====

// GLSL textureless classic 2D noise "cnoise",
// with an RSL-style periodic variant "pnoise".
// Author:  Stefan Gustavson (stefan.gustavson@liu.se)
// Version: 2011-08-22
//
// Many thanks to Ian McEwan of Ashima Arts for the
// ideas for permutation and gradient selection.
//
// Copyright (c) 2011 Stefan Gustavson. All rights reserved.
// Distributed under the MIT license. See LICENSE file.
// https://github.com/stegu/webgl-noise

vec4 mod289(vec4 x)
{
  return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec4 permute(vec4 x)
{
  return mod289(((x*34.0)+10.0)*x);
}

vec4 taylorInvSqrt(vec4 r)
{
  return 1.79284291400159 - 0.85373472095314 * r;
}

vec2 fade(vec2 t) {
  return t*t*t*(t*(t*6.0-15.0)+10.0);
}


// Classic Perlin noise, periodic variant
float pnoise(vec2 P, vec2 rep)
{
  vec4 Pi = floor(P.xyxy) + vec4(0.0, 0.0, 1.0, 1.0);
  vec4 Pf = fract(P.xyxy) - vec4(0.0, 0.0, 1.0, 1.0);
  Pi = mod(Pi, rep.xyxy); // To create noise with explicit period
  Pi = mod289(Pi);        // To avoid truncation effects in permutation
  vec4 ix = Pi.xzxz;
  vec4 iy = Pi.yyww;
  vec4 fx = Pf.xzxz;
  vec4 fy = Pf.yyww;

  vec4 i = permute(permute(ix) + iy);

  vec4 gx = fract(i * (1.0 / 41.0)) * 2.0 - 1.0 ;
  vec4 gy = abs(gx) - 0.5 ;
  vec4 tx = floor(gx + 0.5);
  gx = gx - tx;

  vec2 g00 = vec2(gx.x,gy.x);
  vec2 g10 = vec2(gx.y,gy.y);
  vec2 g01 = vec2(gx.z,gy.z);
  vec2 g11 = vec2(gx.w,gy.w);

  vec4 norm = taylorInvSqrt(vec4(dot(g00, g00), dot(g01, g01), dot(g10, g10), dot(g11, g11)));
  g00 *= norm.x;  
  g01 *= norm.y;  
  g10 *= norm.z;  
  g11 *= norm.w;  

  float n00 = dot(g00, vec2(fx.x, fy.x));
  float n10 = dot(g10, vec2(fx.y, fy.y));
  float n01 = dot(g01, vec2(fx.z, fy.z));
  float n11 = dot(g11, vec2(fx.w, fy.w));

  vec2 fade_xy = fade(Pf.xy);
  vec2 n_x = mix(vec2(n00, n01), vec2(n10, n11), fade_xy.x);
  float n_xy = mix(n_x.x, n_x.y, fade_xy.y);
  return 2.3 * n_xy;
}

/// hsv2rgb
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

/// === Code ===

float color(vec2 xy) { return pnoise(xy + uTime / 3 , vec2(16)); }

float getEdgeOffset(vec2 p, float strength, float o, float factor) {
  float offset = strength * o;
  vec2 pOffset = p + vec2(offset); 
  float x = pow(((uSize.x - offset - pOffset.x )/ uSize.x), factor);
  float y = pow(((uSize.y - offset - pOffset.y )/ uSize.y), factor);
  float x_low = pow(((pOffset.x + offset) / (uSize.x + offset)), factor);
  float y_low = pow(((pOffset.y + offset) / (uSize.y+ offset)), factor);
  return x + y + x_low + y_low;

}

float easeInOutCubic(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 1.0 - pow(-2.0 * t + 2.0, 3.0) / 2.0;
}

float sdAxisAlignedRect(vec2 uv, vec2 tl, vec2 br)
{
    vec2 d = max(tl-uv, uv-br);
    return length(max(vec2(0.0), d)) + min(0.0, max(d.x, d.y));
}

float logarithmicTransform(float x) {
  return x;
}


float getStrength(float x1, float y1) {
  float limit = 10;

   vec2 uv = vec2(x1, y1);
  vec2 area1 = vec2(0.5, 0.5);
  vec2 area2 = vec2(0.5, 0.5);
  float bassY = 0;
  float lowerMidY = 0.2;
  float midY = 0.4;
  float higherMidY = 0.6;
  float trebleY = 0.8;
  float airY = 1;

  float disBass =0;
  float disLowerMid =0;
  float disMid =0;
  float disHigherMid =0;
  float disTreble =0;
  float disAir =0;

  if (x1 < 0.5) {
    float disF = 1;
    float distanceBassVector = 1 - max(0, disF - abs(length(vec2(0, 1 - bassY) - uv)));
    float distanceLowerMidVector = 1 - max(0, disF - abs(length(vec2(0, 1 - lowerMidY) - uv)));
    float distanceMidVector = 1 - max(0, disF - abs(length(vec2(0, 1 - midY) - uv)));
    float distanceHigherMidVector = 1 - max(0, disF - abs(length(vec2(0, 1 - higherMidY) - uv)));
    float distanceTrebleVector = 1 - max(0, disF - abs(length(vec2(0, 1 - trebleY) - uv)));
    float distanceAirVector = 1 - max(0, disF - abs(length(vec2(0, 1 - airY) - uv)));

  
  disBass = (abs(length(distanceBassVector)));
  disLowerMid = (abs(length(distanceLowerMidVector)));
  disMid = (abs(length(distanceMidVector)));
  disHigherMid = (abs(length(distanceHigherMidVector)));
  disTreble = (abs(length(distanceTrebleVector)));
  disAir = (abs(length(distanceAirVector)));

  } else {
  float disF = 1;
    float distanceBassVector = 1 - max(0, disF - abs(length(vec2(1, 1 - bassY) - uv)));
    float distanceLowerMidVector = 1 - max(0, disF - abs(length(vec2(1, 1 - lowerMidY) - uv)));
    float distanceMidVector = 1 - max(0, disF - abs(length(vec2(1, 1 - midY) - uv)));
    float distanceHigherMidVector = 1 - max(0, disF - abs(length(vec2(1, 1 - higherMidY) - uv)));
    float distanceTrebleVector = 1 - max(0, disF - abs(length(vec2(1, 1 - trebleY) - uv)));
    float distanceAirVector = 1 - max(0, disF - abs(length(vec2(1, 1 - airY) - uv)));

  

  disBass = (abs(distanceBassVector));
  disLowerMid = (abs(length(distanceLowerMidVector)));
  disMid = (abs(length(distanceMidVector)));
  disHigherMid = (abs(length(distanceHigherMidVector)));
  disTreble = (abs(length(distanceTrebleVector)));
  disAir = (abs(length(distanceAirVector)));

  }
  float fact = 0.08;
  float bassValue = logarithmicTransform(bass  *  (1 - disBass)) * fact;
  float lowerMidValue = logarithmicTransform(lowerMid / 2 *  (1 - disLowerMid)) * fact;
  float midValue = logarithmicTransform(mid / 2 *  (1 - disMid)) * fact;
  float higherMidValue = logarithmicTransform(higherMid / 2 *  (1 - disHigherMid)) * fact;
  float trebleValue = logarithmicTransform(treble / 2 *  (1 - disTreble)) * fact;
  float airValue = logarithmicTransform(air / 2 *  (1 - disAir)) * fact;
  return ( (bassValue + lowerMidValue + midValue + higherMidValue + trebleValue + airValue) * sdAxisAlignedRect(uv, area1, area2) );
}



void main() {
   vec2 p = FlutterFragCoord().xy;
  vec2 p_y_n = p / uSize.y;
  vec2 p_n = p / uSize;
    float frequencyFactor = getStrength(p_n.x, p_n.y);

    float n = color(p_y_n * 1.0 + (frequencyFactor * 0.3));
    float n2 = color(p_y_n * 0.4+ (frequencyFactor * 0.3));
    float a = 0;
    
    float strength = 0.6 + (frequencyFactor * 0.1);

    a = getEdgeOffset(p, strength , (n * 40 + n2 * 2), 12) ;
    float a2 = easeInOutCubic(getEdgeOffset(p, strength , (n * 6 + n2 * 2), 30)) ;
    float a3 = getEdgeOffset(p, strength , (n * 20 + n2 * 2), 1) ;

    frag_color = texture(uTexture, p_n);
    vec3 color = hsv2rgb(vec3(((p_n.y / 4) ) + uTime / 20,0.6, 0.9));
    float factor = (a * (0.84 + ((frequencyFactor ) * 2 + (a3 *0.24))) + a2 * (1 + (frequencyFactor * frequencyFactor * 0.44))) / 5;
    frag_color = vec4(factor * color * 1.4+ frag_color.xyz * max(0, 1 - factor) - 0.1 , 1);
}

