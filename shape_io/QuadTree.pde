class QuadTree{
  QuadTree[] QT;
  ArrayList<Collider> colliders;
  float w;
  float h;
  Vector2 position;
  int MAX=4;
  Box box;
  QuadTree(float x,float y,float _w,float _h){
    colliders=new ArrayList<Collider>();
    position=new Vector2(x,y);
    QT=new QuadTree[4];
    for(int i=0;i<QT.length;i+=1) QT[i]=null;
    w=_w;
    h=_h;
    
    box=new Box(x,y,w,h);
  }
  
  
  void show() {
    //Vector2 cPosition=game.cam.transform.getPosition();
    for (int i=0; i<QT.length; i+=1) {
      if (QT[i]!=null) QT[i].show();
    }


    
  }
  void insert(Collider c) {
    if (colliders.size()<MAX) {
      colliders.add(c);
      return;
    }
    if (QT[0]==null)subquadtree();  
    Vector2 position=c.collider.transform.getPosition();
    for (int i=0; i<QT.length; i+=1) {
      if (pnpoly(position.x, position.y, QT[i].box)) {
        QT[i].insert(c);
        return;
      }
    }
    QT[3].insert(c);
    return;
  }
  void subquadtree() {
    QT[0]=new QuadTree(position.x-w/4, position.y-h/4, w/2, h/2);
    QT[1]=new QuadTree(position.x+w/4, position.y-h/4, w/2, h/2);
    QT[2]=new QuadTree(position.x+w/4, position.y+h/4, w/2, h/2);
    QT[3]=new QuadTree(position.x-w/4, position.y+h/4, w/2, h/2);
  }

  void query(Box range, ArrayList found) {
    if (!checkCollision(range, box)) return;
    Collider b=new Collider(range);
    
    for (Collider p : colliders) {      
      if (p.isCollider(b)) {
       
        found.add(p);
      }
    }
    if (QT[0]!=null) {
      for (QuadTree qt : QT) {
        qt.query(range, found);
      }
    }
  }

}

boolean pnpoly(float x, float y, Box b) {
  boolean c=false;
  for (int i=0, j=b.realvertex.length-1; i<b.realvertex.length; j=i++) {
    if (((b.realvertex[i].y>y)!=(b.realvertex[j].y>y))&&(x<(b.realvertex[j].x-b.realvertex[i].x)*(y-b.realvertex[i].y)/(b.realvertex[j].y-b.realvertex[i].y)+b.realvertex[i].x)) {
      c=!c;
    }
  }
  b.touch=c;
  return c;
}

boolean checkCollision(Box b1, Box b2) {
  boolean collision=true;
  for (Vector2 v : b1.vertexDirection) {
    float[] b1MM=b1.projectOnLineMaxAndMin(v.getNormal());
    float[] b2MM=b2.projectOnLineMaxAndMin(v.getNormal());
    if (b2MM[0]>b1MM[1]||b1MM[0]>b2MM[1]) {
      collision=false;
    }
  }
  for (Vector2 v : b2.vertexDirection) {
    float[] b1MM=b1.projectOnLineMaxAndMin(v.getNormal());
    float[] b2MM=b2.projectOnLineMaxAndMin(v.getNormal());
    if (b2MM[0]>b1MM[1]||b1MM[0]>b2MM[1]) {
      collision=false;
    }
  }
  
  return collision;
}
