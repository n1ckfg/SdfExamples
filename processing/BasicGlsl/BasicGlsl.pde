PShader shader;

void setup() {
  size(800, 600, P2D);
  shader = loadShader("sdf.glsl");
  shader.set("iResolution", float(width), float(height), 1.0);
}

void draw() {
  background(0);
  filter(shader);
}
