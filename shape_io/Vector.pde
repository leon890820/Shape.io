static class Vector2 {
  float x;
  float y;
  Vector2(float x, float y) {
    this.x=x;
    this.y=y;
  }
  Vector2() {
    x=0;
    y=0;
  }

  Vector2 copy() {
    return new Vector2(x, y);
  }

  static Vector2 plus(Vector2 v1, Vector2 v2) {
    return new Vector2(v1.x+v2.x, v1.y+v2.y);
  }
  Vector2 plus(Vector2 v) {
    return new Vector2(x+v.x, y+v.y);
  }

  void add(Vector2 v) {
    x+=v.x;
    y+=v.y;
  }

  static Vector2 minus(Vector2 v1, Vector2 v2) {
    return new Vector2(v1.x-v2.x, v1.y-v2.y);
  }
  Vector2 minus(Vector2 v) {
    return new Vector2(x-v.x, y-v.y);
  }

  void sub(Vector2 v) {
    x-=v.x;
    y-=v.y;
  }

  static Vector2 scalar(float n, Vector2 v) {
    return new Vector2(n*v.x, n*v.y);
  }
  Vector2 scalar(float n) {
    return new Vector2(n*x, n*y);
  }

  void mult(float n) {
    x*=n;
    y*=n;
  }

  static Vector2 divide(float n, Vector2 v) {
    return new Vector2(v.x/n, v.y/n);
  }
  Vector2 divide(float n) {
    return new Vector2(x/n, y/n);
  }

  void division(float n) {
    x/=n;
    y/=n;
  }
  Vector2 rotated(float a) {
    float newx=cos(a)*x-sin(a)*y;
    float newy=sin(a)*x+cos(a)*y;
    return new Vector2(newx, newy);
  }

  void rotate(float a) {
    float newx=cos(a)*x-sin(a)*y;
    float newy=sin(a)*x+cos(a)*y;
    x=newx;
    y=newy;
  }
  void translate(Vector2 p) {
    x+=p.x;
    y+=p.y;
  }

  float getLengthSquare() {
    return x*x+y*y;
  }
  float getLength() {
    return sqrt(getLengthSquare());
  }
  Vector2 getUnitVector() {
    return this.divide(getLength());
  }
  void normalize() {
    this.division(getLength());
  }
  Vector2 getNormalize() {
    return this.divide(getLength());
  }

  float dot(Vector2 v) {
    return x*v.x+y*v.y;
  }

  float projectOntoLength(Vector2 v) {
    float a=this.dot(v)/v.getLengthSquare();
    return a;
  }
  Vector2 projectOnto(Vector2 v) {
    return v.scalar(this.projectOntoLength(v));
  }
  Vector2 getNormal() {
    return new Vector2(-x, y);
  }
  void println() {
    print("x : "+x+" y : "+y+"\n");
  }
  void set(Vector2 v){
    x=v.x;
    y=v.y;
  }
  boolean equal(Vector2 v){
    if(v.x==x && v.y==y) return true;
    else return false;
  }

}
