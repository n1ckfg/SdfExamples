class Vec4 {
  
  float x;
  float y;
  float z;
  float w;
  
  Vec4(float _x, float _y, float _z, float _w) {
    x = _x;
    y = _y;
    z = _z;
    w = _w;
  }
  
  Vec4(PVector p, float _w) {
    x = p.x;
    y = p.y;
    z = p.z;
    w = _w;
  }
  
  Vec4(PVector p, float _z, float _w) {
    x = p.x;
    y = p.y;
    z = _z;
    w = _w;
  }
  
  Vec4() {
    x = 0.0;
    y = 0.0;
    z = 0.0;
    w = 0.0;
  }
  
}


class Mat4 {

  Vec4 x;
  Vec4 y;
  Vec4 z;
  Vec4 w;
  
  Mat4(Vec4 _x, Vec4 _y, Vec4 _z, Vec4 _w) {
    x = _x;
    y = _y;
    z = _z;
    w = _w;
  }
  
  Mat4() {
    x = new Vec4();
    y = new Vec4();
    z = new Vec4();
    w = new Vec4();
  }
    
  
}
