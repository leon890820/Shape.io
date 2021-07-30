class MineManager{
  Transform transform;
  Vector2[] vertex=new Vector2[2];
  ArrayList<Mine> mines;
  int type;
  MineManager(Vector2[] v,int t,ArrayList colliders){
    vertex=v;
    transform=new Transform();
    Vector2 p=new Vector2((int)random(vertex[0].x,vertex[1].x),(int)random(vertex[0].y,vertex[1].y));    
    transform.setPosition(p);
    mines=new ArrayList<Mine>();
    type=t;
    createMine(colliders);
    
  }
 
  void createMine(ArrayList colliders){
    Vector2 position=transform.getPosition();
    int minx=(int)random(vertex[0].x+3,position.x);
    int maxx=(int)random(position.x,vertex[1].x-3);
    int miny=(int)random(vertex[0].y+3,position.y);
    int maxy=(int)random(position.y,vertex[1].y-3);
    float centerNoise=noise(position.x*0.1,position.y*0.1);    
    for(int i=minx;i<=maxx;i+=1){
      for(int j=miny;j<=maxy;j+=1){
        if(abs(noise((i)*0.1,(j)*0.1)-centerNoise)>0.03) continue;
        mines.add(new Mine(new Vector2(i,j),type,colliders));        
      }
    }
  }
  void show(){
    if(!(game.cam.isInCamX(vertex[0].x*game.scl) || game.cam.isInCamX(vertex[1].x*game.scl)  || game.cam.isInCamY(vertex[0].y*game.scl) || game.cam.isInCamY(vertex[1].y*game.scl))) return;    
    for(int i=0;i<mines.size();i+=1){
      mines.get(i).show();      
    }
  }

}



class Mine{
  ShapeItem shapeItem;
  Transform transform;
  Panel panel;
  Collider collider;
  Mine(Vector2 p,int n,ArrayList colliders){
    float scl=146;
    shapeItem=new ShapeItem();
    shapeItem.transform.setPosition(p);
    transform=new Transform();
    transform.setPosition(p);   
    collider=new Collider(p.x*scl+scl/2,p.y*scl+scl/2,scl,scl,this);
    collider.setTag("Mine");
    colliders.add(collider);
    panel=new Panel(146,146);
    panel.setPanel(color(220));  
    switch(n){
      case 0:
        shapeItem.setAllCircle();
        break;
      case 1:
        shapeItem.setAllRectangle();
        break;
    }
  }
  
  void show(){
    fill(220);
    stroke(200,200);
    strokeWeight(game.scl/48);
    rect(transform.position.x*game.scl-game.cam.transform.getPosition().x+width/2,transform.position.y*game.scl-game.cam.transform.getPosition().y+height/2,game.scl,game.scl);
    //panel.show();
    shapeItem.show();
    if(debugMode)collider.show();
  }
  
  ShapeItem getShapeItem(){   
    return this.shapeItem.clone();
  }
}
