precision mediump float;
uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

void main() {
  float yy = gl_FragCoord.y / 200.0;
  float xx = gl_FragCoord.x / 200.0;

	vec2 o = vec2(
    80.0 * cos(time * 3.0 + yy + xx),
    80.0 * sin(time * 2.4- xx));

  float r = time + 50.0 * sin(time / 1.0);

  vec2 p = (gl_FragCoord.xy + o) / vec2(30.0, 30.0);

  int x = int(mod(p.x, 2.0));
  int y = int(mod(p.y, 2.0));
  int t = x * (1 - y) + y * (1 - x);

  float sh = float(t) / 2.0;
  float br = ((o.x-0.5)*(o.y-0.5)) / 20000.0;

  gl_FragColor = vec4(
    sh + br,
    sh + br,
    sh + br,
    1);
}
