class SaveableItem{
  SaveableItem(){
  
  
  }





}



abstract class Building extends SaveableItem{
  boolean createMode=false;
  int rotation=0;
  Transform transform;
  ArrayList<Gate> gates;
  Building(){
    
  }
  abstract void removes();
  abstract void rotateBuilding();
  abstract void build();
  abstract void show();
  abstract void show(float x,float y);
  abstract void setCreate(boolean b);
  abstract void destorySelf();
  abstract void run();
}

class ShapeItemTransport{
  ShapeItem shapeItem;
  Time time;
  Transform startTranform;
  Transform endTransform;
  float speed=2;
  ShapeItemTransport(){
    startTranform=new Transform();
    endTransform=new Transform();
    time=new Time();
  }
  void run(){
    if(time.time<1){
      time.run();
    }
    
    
    //println(shapeItem);
    //if(time.time>1) time.reset();
  
  }
  void clear(){
    shapeItem=null;
  }
  void show(){
    if(shapeItem==null)return;
    Vector2 position=game.cam.transform.getPosition();
    float x=map(time.time,0,1,startTranform.getPosition().x,endTransform.getPosition().x);
    float y=map(time.time,0,1,startTranform.getPosition().y,endTransform.getPosition().y);
    x=x/146*game.scl-position.x+width/2;
    y=y/146*game.scl-position.y+height/2;    
    shapeItem.show(x,y);
  
  }
  void setTransform(Vector2 st,Vector2 et){
    startTranform.setPosition(st);
    endTransform.setPosition(et);
  }
  float getTime(){
    return time.time;
  }
  void reset(){
    time.reset();
  }


}
