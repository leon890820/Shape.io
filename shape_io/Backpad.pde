class Backpad{
  ArrayList<ShapeItemCount> shapeItemCounts;
  Backpad(){
    shapeItemCounts=new ArrayList<ShapeItemCount>();
    
  }
  
  void addNewShapeItem(ShapeItem si){
    for(ShapeItemCount sic:shapeItemCounts){
      if(sic.checkShapeItemIsEqual(si)){
        sic.plusCount();
        return;
      }
    }
    ShapeItemCount SIC=new ShapeItemCount();
    SIC.setShapeItem(si);
    shapeItemCounts.add(SIC);
    
    
  }
  
  int getShapeItemCount(ShapeItem si){
    for(ShapeItemCount sic:shapeItemCounts){
      if(sic.checkShapeItemIsEqual(si)) return sic.count;
    }
    
    return 0;   
  }


}
class ShapeItemCount{
  ShapeItem shapeItem;
  int count=0;
  ShapeItemCount(){
    
  }
  void plusCount(){
    count+=1;
  }
  void plusCount(int i){
    count+=i;
  }
  void setShapeItem(ShapeItem si){
    shapeItem=si.clone();
    count=0;
  }
  boolean checkShapeItemIsEqual(ShapeItem si){
    if(si==null)return false;
    else if(shapeItem.equal(si)){
      return true;
    }else{
      return false;
    }
  }
  
  
  

}

class HomeBuilding extends Building{
  PImage homeBuildingImage;
  Camera cam;
  Transform transform;
  Collider collider;
  
  HomeBuilding(Camera _cam,ArrayList colliders){
    homeBuildingImage=loadImage("res_raw/sprites/buildings/hub.png");
    transform=new Transform();
    transform.setPosition(new Vector2(0,0));
    cam=_cam;  
    gateInit();
    collider=new Collider(0,0,146*4,146*4,this);
    collider.setTag("Building");
    colliders.add(collider);
  }
  
  void gateInit(){
    gates=new ArrayList<Gate>();
    
    for(int i=0;i<4;i+=1){
      ImportGate importGate=new ImportGate();
      Vector2 p=new Vector2(-2+i,-2-1);
      importGate.setTransform(p);
      gates.add(importGate);
    }
    for(int i=0;i<4;i+=1){
      ImportGate importGate=new ImportGate();
      Vector2 p=new Vector2(1+1,-2+i);
      importGate.setTransform(p);
      gates.add(importGate);
    }
    for(int i=0;i<4;i+=1){
      ImportGate importGate=new ImportGate();
      Vector2 p=new Vector2(1-i,1+1);
      importGate.setTransform(p);
      gates.add(importGate);
    }
    for(int i=0;i<4;i+=1){
      ImportGate importGate=new ImportGate();
      Vector2 p=new Vector2(-2-1,1-i);
      importGate.setTransform(p);
      gates.add(importGate);
    }
    
    
    
  }
  Building getBuilding(){
    return this;
  }
  
  @Override
  void run(){
    transport();
  }
  void transport(){
    for(Gate g:gates){
      if(g.direction()==-1){
        if(g.shapeItem!=null){
           game.backpad.addNewShapeItem(g.shapeItem);
           g.shapeItem=null;         
        }
      }
    }
  
  }
  
  
  void destorySelf(){
  
  }
  void build(){
  
  }
  @Override
  void removes(){
  
  }
  @Override
  void rotateBuilding(){
  }
  @Override
  void setCreate(boolean b){
    
  }
  
  @Override
  void show(float x,float y){
     
  }
  
  void show(){
    imageMode(CENTER);
    tint(255,255-liteLerp);
    float scl=game.scl;
    Vector2 cPosition=game.cam.transform.getPosition();
    if (!liteMap)image(homeBuildingImage,transform.position.x-cPosition.x+width/2,transform.position.y-cPosition.y+height/2,scl*4.4,scl*4.4);
    else{
      rectMode(CENTER);
      fill(227,23,13,liteLerp);
      noStroke();
      rect(transform.position.x-cPosition.x+width/2,transform.position.y-cPosition.y+height/2,scl*4,scl*4);
    }
    tint(255);
  }
  
  void loadHomeBuildingImage(){
      colorMode(RGB);
   
    
    
      homeBuildingImage.loadPixels();      
      for(int i=0;i<homeBuildingImage.height;i+=1){
        for(int j=0;j<homeBuildingImage.width;j+=1){
          int index=i*homeBuildingImage.width+j;     
          int indexI=(i+1485)*allItemImage.width+j;
          homeBuildingImage.pixels[index]=allItemImage.pixels[indexI];
        }
      }
      homeBuildingImage.updatePixels();
    
  
  }


}
