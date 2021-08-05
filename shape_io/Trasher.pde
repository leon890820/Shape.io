class Trasher extends Building{
  PImage createModeTrasherPicture;
  PImage trasherPicture;  
  boolean collide=false;
  Collider collider;    
  float cutSpeed=1;  
  Time cutTime;  
  
  
  
  
  
  float speed=2;
  Trasher(){
    super();
    createModeTrasherPicture=loadImage("res_raw/sprites/blueprints/trash.png");
    collider=new Collider(0,0,146,146,this);
    
    game.colliders.add(collider); 
     
    transform=new Transform();
    gateInit();
  }
  
  Trasher(Vector2 p,int r){   
    super();
    float scl=146;
    rotation=r;
    cutTime=new Time();
    transform=new Transform();
    transform.setPosition(p);
    trasherPicture=loadImage("res_raw/sprites/buildings/trash.png");
    colliderInit(p,r);
    gateInit();
    for(Gate g:gates)g.link(p);
    
   
    

  }
  
  
  
  void gateInit(){
    gates=new ArrayList<Gate>();
    Vector2 position=transform.getPosition();
    float[][] dir={{0,1},{-1,0},{0,-1},{1,0}};
    for(int i=0;i<4;i+=1){
      ImportGate ig=new ImportGate();
      ig.setRotation(rotation);
      ig.setTransform(new Vector2(position.x+dir[(i)%4][0], position.y+dir[(i)%4][1]));
      gates.add(ig);
    }
  
  }
  
  void colliderInit(Vector2 p,int r){
    float scl=146;    
    collider=new Collider(p.x*scl+scl/2,p.y*scl+scl/2,scl,scl,this);
    collider.setTag("Building");
    game.colliders.add(collider);    
  }
  
  @Override
  void removes(){
    game.colliders.remove(this.collider);
  }
  
  @Override
  void build(){
    if(collide) {
      game.invalidButton=true;
      game.setInvalidTransform(new Vector2(mouseX,mouseY));
      game.resetInvalid();
      return;
    }
    int x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl);
    int y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl);
    Vector2 v= new Vector2(x,y);
    game.buildings.add(new Trasher(v,rotation));
    removes();
    game.buildingMode=false;
    game.buildingSelect=null;
  }
  @Override
  void show(){
  
  }
  @Override
  void show(float x,float y){
    if (createMode) createModeShow(x, y);
    else normalShow();
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
  void run(){
    for(int i=0;i<gates.size();i+=1){
      if(gates.get(i).shapeItem!=null){
        gates.get(i).shapeItem=null;
      }
    }
    
  }
  
  
  void transport(){
    
  
  }
  
  
  void createModeShow(float x, float y) {
    imageMode(CENTER);
    collide=false;
    float r=map(rotation,0,4,0,2*PI);
    int _x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*146+146/2;
    int _y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*146+146/2;
    Vector2 gPosition=game.cam.transform.getPosition();
    float scl=game.getScl();
    
      
    Box b=new Box(_x,_y,146,146);
    ArrayList<Collider> found=new ArrayList<Collider>();      
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
    image(createModeTrasherPicture, x, y, scl, scl);
    
    for (Gate g : gates) {
      translate(x,y);
      rotate(PI/2);
      translate(-x,-y);
      g.show(x,y);      
    }
    popMatrix();
    
    updateCollider();
  }
  
  void normalShow(){
    
    Vector2 position=transform.getPosition();
    float scl=game.getScl();
    Vector2 gPosition=game.cam.transform.getPosition();
   
    float r=map(rotation,0,4,0,2*PI);
    float x=position.x*scl-gPosition.x+width/2+scl/2;
    float y=position.y*scl-gPosition.y+height/2+scl/2;
     
    if(!liteMap){
      imageMode(CORNER);
      pushMatrix();    
      translate(x,y);
      rotate(r);
      translate(-x,-y);
      tint(255,255-liteLerp);
      image(trasherPicture,position.x*scl-gPosition.x+width/2 , position.y*scl-gPosition.y+height/2, scl, scl);
      tint(255,255);
      popMatrix();
    }else{
      rectMode(CORNER);
      pushMatrix();    
      translate(x,y);
      rotate(r);
      translate(-x,-y);
      fill(255,0,0,liteLerp);
      noStroke();      
      rect(position.x*scl-gPosition.x+width/2 , position.y*scl-gPosition.y+height/2, scl*2/3, scl*2/3);
      rect(position.x*scl-gPosition.x+width/2+scl*1/3 , position.y*scl-gPosition.y+height/2+scl*1/3, scl*2/3, scl*2/3);
      
      popMatrix();
    
    
    }
    
    
    
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
