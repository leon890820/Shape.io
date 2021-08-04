abstract class Gate{
  PImage goodImportImage;
  PImage badImportImage;
  int rotation;
  ImportGate importGate;
  Transform transform;
  boolean death=false;
  ShapeItem shapeItem;
  Gate(){
    goodImportImage=loadImage("res_raw/sprites/misc/slot_good_arrow.png");
    badImportImage=loadImage("res_raw/sprites/misc/slot_bad_arrow.png");
    transform=new Transform();
  }
  abstract void show(float x,float y,int t);
  abstract void show(float x,float y);
  abstract int direction();
  abstract void link(Vector2 p);
  abstract void run(ShapeItemTransport sit);
  
  void setDeath(boolean b){
    death=b;
  }
  void setRotation(int x){
    rotation=x;
  }
  void setTransform(Vector2 p){
    transform.setPosition(p);
  }
}

class ImportGate extends Gate{
  int[] bias={0,0};
  ImportGate(){
    
  }
  void setBias(int[] bi){
    bias=bi;
  }
  @Override
  void run(ShapeItemTransport sit){
  
  }
  
  @Override
  void link(Vector2 p){
    Vector2 position=transform.getPosition();
    float scl=146;
    Box b=new Box(position.x*scl+scl/2,position.y*scl+scl/2,scl,scl);
    ArrayList<Collider> found=new ArrayList<Collider>();
    game.quadTree.query(b,found);
    for(Collider c:found){
      if(!c.tag.equals("Building")) continue;
      Building building=c.getBuilding();
      
      for(Gate g:building.gates){
        if(g.direction()==1 && g.transform.getPosition().equal(p)){          
          g.importGate=this;
        } 
      }
    }
  }
  @Override
  int direction(){
    return -1;
  }
  
  @Override  
  void show(float x,float y,int t){
    float scl=game.getScl();
    imageMode(CENTER);
    image(goodImportImage,x,y+scl*0.8,scl*0.5,scl*0.5);
  }
  
  @Override  
  void show(float x,float y){
    //Vector2 position=transform.getPosition();
    float scl=game.getScl();
    imageMode(CENTER);
    image(goodImportImage,x+bias[0]*scl,y+bias[1]*scl+scl*0.8,scl*0.5,scl*0.5);
  }

}

class ExportGate extends Gate{
  int[] bias={0,0};
  ExportGate(){
    importGate=null;
  }
  void setBias(int[] bi){
    bias=bi;
  }
  @Override
  void run(ShapeItemTransport sit){
    transExportToImport(sit);
    
  }
  void transExportToImport(ShapeItemTransport sit){
    if(shapeItem!=null && importGate!=null){
      if(!importGate.death || importGate.shapeItem==null){
        importGate.shapeItem=shapeItem;
        shapeItem=null;
        sit.clear();
      }
    }
  }
  boolean canTransport(){
    if(shapeItem!=null){
      return false;
    }
    if(importGate==null){
      return false;
    }else{
      if(importGate.death || importGate.shapeItem!=null){
        return false;
      }else{
        return true;
      }
    }    
  }
  
  @Override
  void link(Vector2 p){
    Vector2 position=transform.getPosition();
    float scl=146;
    Box b=new Box(position.x*scl+scl/2,position.y*scl+scl/2,scl,scl);
    ArrayList<Collider> found=new ArrayList<Collider>();
    game.quadTree.query(b,found);
    for(Collider c:found){
      if(!c.tag.equals("Building")) continue;
      Building building=c.getBuilding();
      for(Gate g:building.gates){
        if(g.direction()==-1 && g.transform.getPosition().equal(p)){          
          importGate=(ImportGate)g;          
        } 
      }
    }
    
    
  }
  
  @Override
  int direction(){
    return 1;
  }
  void show(float x,float y){
    //Vector2 position=transform.getPosition();
    float scl=game.getScl();
    imageMode(CENTER);
    image(goodImportImage,x+bias[0]*scl,y+bias[1]*scl-0.8*scl,scl*0.5,scl*0.5);
  }
  
  @Override
  void show(float x,float y,int t){
    float scl=game.getScl();
    translate(x,y);
    if(t==1) rotate(PI/2);      
    else if(t==2) rotate(-PI/2);
    translate(-x,-y);
    imageMode(CENTER);
    image(goodImportImage,x,y-scl*0.8,scl*0.5,scl*0.5);
  }
}
