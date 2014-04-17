#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

const int   complexity      = 55;    // More points of color.
const float mouse_factor    = 12.0;  // Makes it more/less jumpy.
const float mouse_offset    = 2.0;   // Drives complexity in the amount of curls/cuves.  Zero is a single whirlpool.
const float fluid_speed     = 2.0;  // Drives speed, higher number will make it slower.
const float color_intensity = 0.45;

const float Pi = 3.14159;

float sinApprox(float x) {
    x = Pi + (2.0 * Pi) * floor(x / (2.0 * Pi)) - x;
    return (4.0 / Pi) * x - (4.0 / Pi / Pi) * x * abs(x);
}

float cosApprox(float x) {
    return sinApprox(x + 0.5 * Pi);
}

void main()
{
  vec2 p=(2.0*gl_FragCoord.xy-resolution)/max(resolution.x,resolution.y);
  for(int i=35;i<complexity;i++)
  {
    vec2 newp=p;
    newp.x+=0.6/float(i)*cos(float(i)*p.y+time/fluid_speed+0.3*float(i))+mouse.y/mouse_factor+mouse_offset;
    newp.y+=0.6/float(i)*sin(float(i)*p.x+time/fluid_speed+0.3*float(i+500))-mouse.x/mouse_factor+mouse_offset;
    p=newp;
  }
  vec3 col=vec3(10.0*(sin(p.x*7.0)-0.9)+10.0*(cos(p.y*7.0)-0.9));
  gl_FragColor=vec4(col, 1.0);
}
