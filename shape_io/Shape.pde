abstract class BoxShape {
  ShapeType type;
  Transform transform;
  Vector2[] vertex;
  Vector2[] vertexDirection;
  boolean touch;
  boolean drag;
  boolean collision;
  Vector2[] realvertex;
  BoxShape(ShapeType s) {
    type=s;
    //transform=new Transform();
  }
  abstract void show();
  abstract ShapeType getType();
  abstract void drag();
  abstract void update();
  abstract void setScale(Vector2 p);
  abstract float[] projectOnLineMaxAndMin(Vector2 p);
  abstract void setPosition(Vector2 p);
}

class Box extends BoxShape {
  float w;
  float h;
  //Vector2[] vertex=new Vector2[4];
  //Vector2[] realvertex=new Vector2[4];
  //Vector2[] vertexDirection=new Vector2[4];
  //Transform transform;
  //boolean touch;
  //boolean drag;
  //boolean collision=false;
  String tag;
  Box() {
    super(ShapeType.BOX);
    vertex=new Vector2[4];
    realvertex=new Vector2[4];
    vertexDirection=new Vector2[4];
  }
  Box(float x, float y, float _w, float _h) {
    super(ShapeType.BOX);
    vertex=new Vector2[4];
    realvertex=new Vector2[4];
    vertexDirection=new Vector2[4];
    w=_w;
    h=_h;
    transform=new Transform();
    transform.setPosition(new Vector2(x, y));
    createVertex();
    createVertexDirection();
  }
  @Override
  void setPosition(Vector2 p){
    transform.setPosition(p);
  }
  
  void setScale(Vector2 p) {
    w=p.x;
    h=p.y;
    createVertex();
    createVertexDirection();
  }
  void setTag(String t) {
    tag=t;
  }
  void createVertexDirection() {
    for (int i=0, j=realvertex.length-1; i<realvertex.length; j=i++) {
      vertexDirection[i]=Vector2.minus(realvertex[i], realvertex[j]);
    }
  }

  void createVertex() {
    Vector2 position=new Vector2(0, 0);
    vertex[0]=new Vector2(position.x+w/2, position.y-h/2);
    vertex[1]=new Vector2(position.x-w/2, position.y-h/2);
    vertex[2]=new Vector2(position.x-w/2, position.y+h/2);
    vertex[3]=new Vector2(position.x+w/2, position.y+h/2);
    int c=0;
    for (Vector2 v : vertex) {
      Vector2 newv=v.rotated(transform.angle);
      newv.add(transform.position);
      realvertex[c]=newv.copy();
      c+=1;
    }
  }

  @Override
    ShapeType getType() {
    return type;
  }

  @Override
    void show() {
    Vector2 position=game.cam.transform.getPosition();
    Vector2 tposition=transform.getPosition();
    //println(tposition.x/146,tposition.y/146);
    float scl=game.getScl();
    if (touch)fill(255, 0, 0);
    else if (collision)fill(255, 255, 0);
    else fill(255);
    if (drag) stroke(0, 255, 0);
    else stroke(0);
    beginShape();
    int c=0;
    for (Vector2 v : vertex) {

      Vector2 newv=v.rotated(transform.angle);
      newv.add(tposition);
      realvertex[c]=newv.copy();
      c+=1;      
      vertex((newv.x/146)*scl-position.x+width/2, (newv.y/146)*scl-position.y+height/2);
    }

    endShape(CLOSE);
    //println();
  }
  @Override
    void update() {
  }
  @Override
    void drag() {
    if (drag) {
      Vector2 v=new Vector2(mouseX-pmouseX, mouseY-pmouseY);
      transform.position.add(v);
    }
  }
  void real() {
    int c=0;
    for (Vector2 v : vertex) {
      Vector2 newv=v.rotated(transform.angle);
      newv.add(transform.position);
      realvertex[c]=newv.copy();
      c+=1;
      vertex(newv.x, newv.y);
    }
  }
  float[] projectOnLineMaxAndMin(Vector2 v) {
    float maxRecord=-100000000;
    float minRecord=100000000;
    Vector2 minV=new Vector2(0, 0);
    Vector2 maxV=new Vector2(0, 0);
    for (Vector2 rv : realvertex) {
      //rv.println();
      Vector2 pp=rv.projectOnto(v);
      float ff=rv.projectOntoLength(v);
      //print(ff+" ");
      if (ff>maxRecord) {
        maxRecord=ff;
        maxV=pp.copy();
      }
      if (ff<minRecord) {
        minRecord=ff;
        minV=pp.copy();
      }
    }
    //println();
    fill(0, 0, 255);
    //circle(minV.x,minV.y,5);
    //circle(maxV.x,maxV.y,5);
    float[] result={minRecord, maxRecord};
    return result;
  }
}

class Spot extends BoxShape {
  //Transform transform;
  //boolean touch;
  //boolean drag;
  //boolean collision;
 
  Spot(float x, float y) {
    super(ShapeType.SPOT);
    transform=new Transform(); 

    transform.setPosition(new Vector2(x, y));
  }
  @Override
  void setPosition(Vector2 p){
    transform.setPosition(p);
  }
  @Override 
  void show() {
    Vector2 position=game.cam.transform.getPosition();
    Vector2 tposition=transform.getPosition();
    //println(tposition.x/146,tposition.y/146);
    float scl=game.getScl();
    if (touch)fill(255, 0, 0);
    else if (collision)fill(255, 255, 0);
    else fill(255);
    if (drag) stroke(0, 255, 0);
    else stroke(0);      
    circle(tposition.x/146*scl-position.x+width/2, tposition.y/146*scl-position.y+height/2,10);    
    
  }
  @Override 
    ShapeType getType() {
    return type;
  }
  @Override 
    void drag() {
  }
  @Override 
    void update() {
  }
  @Override 
    void setScale(Vector2 p) {
  }
  @Override
    float[] projectOnLineMaxAndMin(Vector2 p) {    
    return null;
  }
}


public enum ShapeType {
  CIRCLE, EDGE, POLYGON, CHAIN, BOX, SPOT;
}
