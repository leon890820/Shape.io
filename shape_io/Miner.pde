class Miner extends Building {
  
  PImage createModeMinerPicture;
  PImage minerPicture;
  
  boolean pressed=false;
  boolean collide=false;
  Collider collider;
  
  ExportGate exportGate;
  Mine mine;
  
  int MAXSHAPEITEMVALUME=20;
  float mineSpeed=1;
  ArrayList<ShapeItem> shapeItemsBackpad;
  Time mineTime;
  ShapeItemTransport shapeItemTransport;
  boolean tutorial1=false;
  
  Miner() {
    super();
    createModeMinerPicture=loadImage("res_raw/sprites/blueprints/miner.png");
    collider=new Collider(0,0,146,146,this);
    game.colliders.add(collider);
  }
  Miner(Vector2 p,int r){   
    super();
    float scl=146;
    rotation=r;
    mineTime=new Time();
    transform=new Transform();
    transform.setPosition(p);
    minerPicture=loadImage("res_raw/sprites/buildings/miner.png");
    collider=new Collider(p.x*scl+scl/2,p.y*scl+scl/2,scl,scl,this);
    collider.setTag("Building");
    game.colliders.add(collider);
    gateInit();
    for(Gate g:gates)g.link(p);
    linkMine(p);
    shapeItemsBackpad=new ArrayList<ShapeItem>();
    shapeItemTransportInit();

  }
  void shapeItemTransportInit(){
    shapeItemTransport=new ShapeItemTransport();
    float scl=146;
    float[][] dir= {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
    Vector2 position=transform.getPosition();
    Vector2 startPosition=new Vector2(position.x*scl+scl/2,position.y*scl+scl/2);
    Vector2 endPosition=new Vector2(position.x*scl+scl/2+dir[rotation][0]*scl/2,position.y*scl+scl/2+dir[rotation][1]*scl/2);
    shapeItemTransport.setTransform(startPosition,endPosition);
  }
  void linkMine(Vector2 p){
    float scl=146;
    Box b=new Box(p.x*scl+scl/2,p.y*scl+scl/2,scl,scl);
    ArrayList<Collider> found=new ArrayList<Collider>();
    game.quadTree.query(b,found);
    for(Collider c:found){
      if(c.tag.equals("Mine")){
        Mine m=c.getMine();
        if(m.transform.getPosition().equal(transform.getPosition())){
          if(!tutorial1){
            tutorial1=true;
            game.tutorialManager.addNewTutorial();
          }
          mine=m;
        }
      }
    }
  
  }
  void gateInit(){
    Vector2 position=transform.getPosition();
    gates=new ArrayList<Gate>();
    float[][] dir= {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}; 
    exportGate=new ExportGate();
    exportGate.setRotation(rotation);
    exportGate.setTransform(new Vector2(position.x+dir[(rotation+0)%4][0], position.y+dir[(rotation+0)%4][1]));
    gates.add(exportGate);
    
  }
  @Override
  void destorySelf(){
    if(collider.getDestory()){
      for(Gate g:gates){
        g.setDeath(true);
      }
      game.colliders.remove(this.collider);
      game.buildings.remove(this);
      
    }
  
  }
  @Override
  void removes(){
    
    game.colliders.remove(this.collider);
  }
  
  void setRotation(int a){
    rotation=a;
  }
  @Override
  void rotateBuilding(){
    rotation+=1;
    rotation%=4;
  }
  
  @Override
  void show(){
    
  }

  @Override
  void build() {
    if(collide) {
      game.invalidButton=true;
      game.setInvalidTransform(new Vector2(mouseX,mouseY));
      game.resetInvalid();
      return;
    }
    int x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl);
    int y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl);
    Vector2 v= new Vector2(x,y);
    game.buildings.add(new Miner(v,rotation));
    removes();
    game.buildingMode=false;
    game.buildingSelect=null;
  }

  @Override
  void run(){
    
    mineTheMine();
    transport();
    for(Gate g:gates) g.run(shapeItemTransport);
    
    
  }
  void mineTheMine(){
    if(mine!=null){
       if(shapeItemsBackpad.size()<MAXSHAPEITEMVALUME){
         mineTime.run();
         if(mineTime.time*mineSpeed>1){
           shapeItemsBackpad.add(mine.getShapeItem());
           mineTime.reset();
         }
       }    
    }
  }
  
  void transport(){
    
    if(shapeItemsBackpad.size()>0 && shapeItemTransport.shapeItem==null){
      shapeItemTransport.shapeItem=shapeItemsBackpad.remove(0);
      
    }
    
    if(shapeItemTransport.shapeItem!=null && exportGate.shapeItem==null){   
      shapeItemTransport.run();
      if(shapeItemTransport.getTime()>=1){
        
        if(exportGate.canTransport()) transShapItemToExport();
      }
      
    }
    shapeItemTransport.show();
  }
  void transShapItemToExport(){
    exportGate.shapeItem=shapeItemTransport.shapeItem;
    //shapeItemTransport.shapeItem=null;    
    shapeItemTransport.reset();
  
  }

  @Override
    void setCreate(boolean b) {
    createMode=b;
  }

  @Override
    void show(float x, float y) {
    if (createMode) createModeShow(x, y);
    else normalShow();

  }
  void createModeShow(float x, float y) {
    imageMode(CENTER);
    collide=false;
    float r=map(rotation,0,4,0,2*PI);
    int _x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*146+146/2;
    int _y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*146+146/2;
    Box b=new Box(_x,_y,146,146);
    //b.show();
    ArrayList<Collider> found=new ArrayList<Collider>();
    Vector2 gPosition=game.cam.transform.getPosition();
    float scl=game.getScl();
    game.quadTree.query(b,found);
    
    
    for(Collider c:found){
      if(c.tag.equals("Building")){
        collide=true;
      }
    }
    
    if(collide)stroke(255,0,0);
    else stroke(0,255,0);
    noFill();
    rect(floor((_x-146/2)/146)*scl-gPosition.x+width/2+scl*0.1,floor((_y-146/2)/146)*scl-gPosition.y+height/2+scl*0.1,scl*0.8,scl*0.8,scl*0.1); 
    pushMatrix();
    translate(x,y);
    rotate(r);
    translate(-x,-y);
    image(createModeMinerPicture, x, y, game.getScl(), game.getScl());
    popMatrix();
    
    updateCollider();
  }
  void normalShow() {
    Vector2 position=transform.getPosition();
    float scl=game.getScl();
    Vector2 gPosition=game.cam.transform.getPosition();
   
    float r=map(rotation,0,4,0,2*PI);
    float x=position.x*scl-gPosition.x+width/2+scl/2;
    float y=position.y*scl-gPosition.y+height/2+scl/2;
     
    imageMode(CORNER);
    pushMatrix();    
    translate(x,y);
    rotate(r);
    translate(-x,-y);
    image(minerPicture,position.x*scl-gPosition.x+width/2 , position.y*scl-gPosition.y+height/2, scl, scl);
    popMatrix();
    
    
    
    if(debugMode)collider.show();
  }
  
  void updateCollider(){
    float scl=146;
    float x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*146+scl/2;
    float y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*146+scl/2;
    
    collider.setPosition(new Vector2(x,y));
    if(debugMode)collider.show();
  }
  
  
}
