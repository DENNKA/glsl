#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) {
 vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
 
  gl_FragColor = vec4(pos, 0.0, 1.0);
}