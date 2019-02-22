PShader shader;

void setup() {
  size(800, 600, P2D);
  shader = loadShader("test.glsl");
}

void draw() {
  background(0);
  filter(shader);
}
