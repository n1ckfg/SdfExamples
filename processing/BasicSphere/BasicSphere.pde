PImage img;
color bgColor = color(0);
    
void setup() {
  size(800, 600, P2D);
  img = createImage(320, 240, RGB);
  img.loadPixels();
  for (int i=0; i<img.pixels.length; i++) {
    img.pixels[i] = bgColor;
  }
}

void draw() {
  background(0);
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {
      int loc = x + y * img.width;
      
      // Math stuff, computes the direction of the current ray by setting
      // up a camera matrix with the given position and looking direction.
      PVector worldDir = getRayDirection(eye, look_at, 45.0, new PVector(x, y), new PVector(img.width, img.height));
      
      float t = march(eye, worldDir);
      
      color fragColor;
      if (t < 0.0) {
        // Didnt hit any objects
        fragColor = color(0);
      } else {
        // Hit something
         fragColor = color(255,0,0);
      }
      img.pixels[loc] = fragColor;
    }
  }
  
  img.updatePixels();
  image(img, 0, 0, width, height);
}
