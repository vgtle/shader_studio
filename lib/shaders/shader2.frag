#version 460 core

#include <flutter/runtime_effect.glsl>

precision highp float;
uniform vec2 resolution;
uniform vec2 offset;
uniform vec2 mouse;
uniform float time;
uniform sampler2D src;

uniform vec2 move;

out vec4 fragColor;

vec4 tex(vec2 uv) {
  float y = floor(uv.y);  
  float ys = sin(y+0.7);  
  uv.x += ys + time * 0.05 * ys;
 
  return texture(src, fract(uv) * 0.99 + 0.005);
}

void main() {
  vec2 uv = FlutterFragCoord().xy / resolution;
    
  float dist = 0.;   
  
  for (int i = 0; i < 8; i++) {
    float fi = float(i);
    vec2 md = mouse.xy - move * resolution * fi * .2;
    float r = 250. + fi * 50.;
    dist += pow(smoothstep(r, 0., length(md - FlutterFragCoord().xy)), 2.) * (1. - fi * 0.1); 
  }
         
  vec2 mv = move * dist;
  
  vec2 uvr, uvg, uvb;     
  vec4 cr, cg, cb;
  
  for (float i = 0.; i < 8.; i++) {  
    float ii = 1. + i / 8. * 0.2;
    uvr = uv - mv * ii * 1.;
    uvg = uv - mv * ii * 1.4;  
    uvb = uv - mv * ii * 1.8;  

    cr += tex(uvr);
    cg += tex(uvg);
    cb += tex(uvb);  
  }
  cr /= 8.;
  cg /= 8.;
  cb /= 8.;    
       
  fragColor = vec4(cr.r, cg.g, cb.b, cr.a + cg.a + cb.a);
  fragColor.rgb = pow(fragColor.rgb, vec3(.4));
}
