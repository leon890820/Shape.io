class Collider {
  BoxShape collider;
  float hei;
  float wid;
  Boolean isWork=true;
  Boolean destory=false;
  String tag="";
  Building building;
  Mine mine;
  Collider(float x, float y, float w, float h,Building b) {
    wid=w;hei=h;
    collider=new Box(x, y, w, h);
    collider.setPosition(new Vector2(x, y));
    building=b;
    
  }
  Collider(float x, float y, float w, float h,Mine m) {
    wid=w;hei=h;
    collider=new Box(x, y, w, h);
    collider.setPosition(new Vector2(x, y));
    mine=m;
    
  }
  Collider(float x, float y, float w, float h) {
    wid=w;hei=h;
    collider=new Box(x, y, w, h);
    collider.setPosition(new Vector2(x, y));

    
  }
  Collider(Box b) {
    collider=b;
    Vector2 position=b.transform.getPosition();
    collider.setPosition(new Vector2(position.x, position.y));
    //collider.createVertex();
    //collider.createVertexDirection();
  }
  Collider(float x, float y) {
    collider=new Spot(x, y);

    //collider.transform.setPosition(new Vector2(x, y));
    //collider.createVertex();
    //collider.createVertexDirection();
  }
  void setNewColliderPosition(float x,float y){
    collider=new Box(x, y, wid, hei);
    collider.setPosition(new Vector2(x, y));
  }
  
  Mine getMine(){
    return mine;
  }
  
  Building getBuilding(){
    return building;
  }
  void setTag(String s){
    tag=s;
  }
  void setScale(Vector2 p) {
    collider.setScale(p);
  }
  void show() {
    if (isWork) {
      collider.show();
    }
  }
  
  void setDestory(boolean b){
    destory=b;
  }
  boolean getDestory(){
    return destory;
  }
  
  boolean isCollider(Collider c) {
    //SAT
    
    if (collider.getType()==ShapeType.BOX && c.collider.getType()==ShapeType.BOX) return SAT(c);
    else if (collider.getType()==ShapeType.SPOT && c.collider.getType()==ShapeType.BOX) return ponyly(collider.transform.getPosition(),c.collider);
    else if (collider.getType()==ShapeType.BOX && c.collider.getType()==ShapeType.SPOT) return ponyly(c.collider.transform.getPosition(),collider);
    else return false;
  }
  boolean ponyly(Vector2 v,BoxShape b) {
    float x=v.x;
    float y=v.y;
    boolean c=false;
    for (int i=0, j=b.realvertex.length-1; i<b.realvertex.length; j=i++) {
      if (((b.realvertex[i].y>y)!=(b.realvertex[j].y>y))&&(x<(b.realvertex[j].x-b.realvertex[i].x)*(y-b.realvertex[i].y)/(b.realvertex[j].y-b.realvertex[i].y)+b.realvertex[i].x)) {
        c=!c;
      }
    }
    b.touch=c;
    return c;
  }
  boolean SAT(Collider c) {
    
    collider.collision=false;
    c.collider.collision=false;
    boolean collision=true;
    float record=10000;
    Vector2 rv=new Vector2();
    
    for (Vector2 v : collider.vertexDirection) {
      
      float[] MM=collider.projectOnLineMaxAndMin(v.getNormal());
      float[] cMM=c.collider.projectOnLineMaxAndMin(v.getNormal());
      

      if (cMM[0]>=MM[1]||MM[0]>=cMM[1]) {

        collision=false;
      } else {
        if ( -cMM[0]+MM[1]>0) {
          if (record> -cMM[0]+MM[1]) {
            record= -cMM[0]+MM[1];
            rv=v.copy();
          }
        } else {
          if (record>-MM[0]+cMM[1]) {
            record= -cMM[0]+MM[1];
            rv=v.copy();
          }
        }
      }
    }
    for (Vector2 v : c.collider.vertexDirection) {
      float[] MM=collider.projectOnLineMaxAndMin(v.getNormal());
      float[] cMM=c.collider.projectOnLineMaxAndMin(v.getNormal());
      if (cMM[0]>=MM[1]||MM[0]>=cMM[1]) {
        collision=false;
      } else {
        if ( -cMM[0]+MM[1]>=0) {
          if (record> -cMM[0]+MM[1]) {
            record= -cMM[0]+MM[1];
            rv=v.copy();
          }
        } else {
          if (record>-MM[0]+cMM[1]) {
            rv=v.copy();  
            record= -MM[0]+cMM[1];
          }
        }
      }
    }


    collider.collision=(collision||collider.collision);
    c.collider.collision=collision||c.collider.collision;
    rv.y*=-1;
    return collision;
  }
  void setPosition(Vector2 v) {
    collider.setPosition(v);
  }
}


class Cursor {
  Transform transform;
  Collider collider;
  ArrayList<Collider> found;
  Cursor(float x, float y) {
    transform=new Transform();
    collider=new Collider(x, y);
    found=new ArrayList<Collider>();

    //game.colliders.add(collider);
  }
  void run(Vector2 p) {
    
    Box b=new Box(p.x, p.y, 1000, 1000);
    found.clear();
    transform.setPosition(p);
    collider.setPosition(p);
    game.quadTree.query(b,found);
    if (debugMode) collider.show();
    //println(found.size());
  }
  void destory(){    
    for(Collider c:found){
      if(c==collider) continue;
      if(collider.isCollider(c)){
        c.setDestory(true);
      }
    }
    
  
  }
}
