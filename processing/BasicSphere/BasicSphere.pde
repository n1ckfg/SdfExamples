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
  for (int y=0; y<img.height; y++) {
    for (int x=0; x<img.width; x++) {
      int loc = x + y * img.width;
      img.pixels[loc] = color(255,0,0);
    }
  }
  
  img.updatePixels();
  image(img, 0, 0, width, height);
}
