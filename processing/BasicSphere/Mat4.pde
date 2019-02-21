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
  
  Vec4 mult(Vec4 v) {
    return v;
  }
  
}
