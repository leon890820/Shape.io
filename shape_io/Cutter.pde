class Cutter extends Building{
  PImage createModeCutterPicture;
  PImage cutterPicture;  
  boolean collide=false;
  Collider[] collider=new Collider[2];  
  int[][][] direction={{{0,0},{1,0}},{{0,0},{0,1}},{{0,0},{-1,0}},{{0,0},{0,-1}}};  
  float cutSpeed=1;  
  Time cutTime;  
  ShapeItemTransport[] shapeItemTransport=new ShapeItemTransport[2];
  ShapeItem cutBash;
  ImportGate ig=new ImportGate();
  ExportGate eg1=new ExportGate();
  ExportGate eg2=new ExportGate();
  float speed=2;
  Cutter(){
    super();
    createModeCutterPicture=loadImage("res_raw/sprites/blueprints/cutter.png");
    collider[0]=new Collider(0,0,146,146,this);
    collider[1]=new Collider(146,0,146,146,this);
    game.colliders.add(collider[0]); 
    game.colliders.add(collider[1]); 
    transform=new Transform();
    gateInit();
  }
  
  Cutter(Vector2 p,int r){   
    super();
    float scl=146;
    rotation=r;
    cutTime=new Time();
    transform=new Transform();
    transform.setPosition(p);
    cutterPicture=loadImage("res_raw/sprites/buildings/cutter.png");
    colliderInit(p,r);
    gateInit();
    for(Gate g:gates)g.link(p);
    
   
    shapeItemTransportInit();

  }
   void shapeItemTransportInit(){
    
    float[][] dir= {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
    float[][] secondDir={{1, 0}, {0, 1}, {-1, 0}, {0, -1}};;
    
    for(int i=0;i<shapeItemTransport.length;i+=1) shapeItemTransport[i]=new ShapeItemTransport();
    Vector2 position=transform.getPosition();
    float scl=146;
    float centerX=position.x*scl+scl/2;
    float centerY=position.y*scl+scl/2;
    Vector2 startPosition1=new Vector2(centerX,centerY);   
    Vector2 endPosition1=new Vector2(centerX+dir[rotation][0]*scl/2,centerY+dir[rotation][1]*scl/2);     
    shapeItemTransport[0].setTransform(startPosition1,endPosition1); 
    
    Vector2 startPosition2=new Vector2(centerX+secondDir[rotation][0]*scl,centerY+secondDir[rotation][1]*scl);
    Vector2 endPosition2=new Vector2(centerX+secondDir[rotation][0]*scl+dir[rotation][0]*scl/2,centerY+secondDir[rotation][1]*scl+dir[rotation][1]*scl/2);
    shapeItemTransport[1].setTransform(startPosition2,endPosition2);
    
    
  }
  
  
  void gateInit(){
    Vector2 position=transform.getPosition();
    gates=new ArrayList<Gate>();
    float[][] dir= {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}; 
    float[][] edir= {{1, -1}, {1, 1}, {-1, 1}, {-1, -1}}; 
    
    ig.setRotation(rotation);
    ig.setTransform(new Vector2(position.x+dir[(rotation+2)%4][0], position.y+dir[(rotation+2)%4][1]));
    eg1.setRotation(rotation);
    eg1.setTransform(new Vector2(position.x+dir[(rotation+0)%4][0], position.y+dir[(rotation+0)%4][1]));
    eg2.setRotation(rotation);
    eg2.setTransform(new Vector2(position.x+edir[(rotation+0)%4][0], position.y+edir[(rotation+0)%4][1]));
    int[] bi={1,0};
    eg2.setBias(bi);
    gates.add(ig);
    gates.add(eg1);
    gates.add(eg2);
  
  }
  
  void colliderInit(Vector2 p,int r){
    float scl=146;
    for(int i=0;i<collider.length;i+=1){
      collider[i]=new Collider(p.x*scl+scl/2+direction[rotation][i][0]*146,p.y*scl+scl/2+direction[rotation][i][1]*146,scl,scl,this);
      collider[i].setTag("Building");
      game.colliders.add(collider[i]);
    }
    
    
    
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
    game.buildings.add(new Cutter(v,rotation));
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
    
      if(collider[0].getDestory()||collider[1].getDestory()){
        for(Gate g:gates){
          g.setDeath(true);
        }
        game.colliders.remove(this.collider[0]);
        game.colliders.remove(this.collider[1]);
        game.buildings.remove(this);
        
      }
    
   
  
  }
  @Override
  void run(){
    cut();
    transport();
    eg1.run(shapeItemTransport[0]);
    eg2.run(shapeItemTransport[1]);
    //for(Gate g:gates) g.run(shapeItemTransport);
  }
  
  void cut(){
    for(Gate g:gates){
      if(g.direction()==-1){
        if(g.shapeItem!=null && cutBash==null){
          cutBash=g.shapeItem;          
        }
      }
    }    
    if(cutBash!=null && shapeItemTransport[0].shapeItem==null && shapeItemTransport[1].shapeItem==null){
      cutTime.run();
      if(cutTime.time*speed>=1){
        ShapeItem leftShapeItem=cutBash.getLeft();
        ShapeItem rightShapeItem=cutBash.getRight();
        cutBash=null;
        ig.shapeItem=null;
        
        shapeItemTransport[0].shapeItem=leftShapeItem;
        shapeItemTransport[1].shapeItem=rightShapeItem;
        cutTime.reset();
      }
      
    }
    
    
  
  
  }
  void transport(){
    for(int i=0;i<shapeItemTransport.length;i+=1){
      if(shapeItemTransport[i]!=null){
        shapeItemTransport[i].run();
      }
    }
    for(ShapeItemTransport sit : shapeItemTransport){
      //sit.show();
    }
    if(shapeItemTransport[0].getTime()>=1){
      if(eg1.canTransport()) {
        eg1.shapeItem=shapeItemTransport[0].shapeItem;
        shapeItemTransport[0].reset();
      }
    }
    if(shapeItemTransport[1].getTime()>=1){
      if(eg2.canTransport()) {
        eg2.shapeItem=shapeItemTransport[1].shapeItem;
        shapeItemTransport[1].reset();
      }
    }
  
  }
  
  
  void createModeShow(float x, float y) {
    imageMode(CENTER);
    collide=false;
    float r=map(rotation,0,4,0,2*PI);
    int _x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*146+146/2;
    int _y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*146+146/2;
    Vector2 gPosition=game.cam.transform.getPosition();
    float scl=game.getScl();
    for(int i=0;i<collider.length;i+=1){
      
      Box b=new Box(_x+direction[rotation][i][0]*146,_y+direction[rotation][i][1]*146,146,146);
      ArrayList<Collider> found=new ArrayList<Collider>();      
      game.quadTree.query(b,found);
      
      for(Collider c:found){
        if(c.tag.equals("Building")){          
            collide=true;
        }
      }
    }
    
    if(collide)stroke(255,0,0);
    else stroke(0,255,0);
    noFill();
    rect(floor((_x-146/2)/146)*scl-gPosition.x+width/2+scl*0.1,floor((_y-146/2)/146)*scl-gPosition.y+height/2+scl*0.1,scl*0.8,scl*0.8,scl*0.1);
    rect(floor((_x-146/2)/146)*scl-gPosition.x+width/2+scl*0.1+direction[rotation][1][0]*scl,floor((_y-146/2)/146)*scl-gPosition.y+height/2+scl*0.1+direction[rotation][1][1]*scl,scl*0.8,scl*0.8,scl*0.1);
    pushMatrix();
    translate(x,y);
    rotate(r);
    translate(-x,-y);
    image(createModeCutterPicture, x+scl*0.5, y, scl*2, scl);
    for (Gate g : gates) g.show(x,y);
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
      image(cutterPicture,position.x*scl-gPosition.x+width/2 , position.y*scl-gPosition.y+height/2, scl*2, scl);
      tint(255,255);
      popMatrix();
    }else{
      rectMode(CORNER);
      pushMatrix();    
      translate(x,y);
      rotate(r);
      translate(-x,-y);
      fill(153,53,250,liteLerp);
      noStroke();      
      rect(position.x*scl-gPosition.x+width/2 , position.y*scl-gPosition.y+height/2, scl, scl);
      fill(220,liteLerp);
      noStroke();
      rect(position.x*scl-gPosition.x+width/2+scl*0.33 , position.y*scl-gPosition.y+height/2+scl*0.33, scl*0.33, scl*0.33);
      popMatrix();
    
    
    }
    
    
    
    if(debugMode)for(Collider c:collider)c.show();
  }


  void updateCollider(){
    float scl=146;
    
    for(int i=0;i<collider.length;i+=1){
      float x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*146+scl/2+direction[rotation][i][0]*146;
      float y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*146+scl/2+direction[rotation][i][1]*146;
      collider[i].setPosition(new Vector2(x,y));
      if(debugMode)collider[i].show();
    }
  }

}
