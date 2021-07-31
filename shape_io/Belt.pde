class Belt extends Building {
  boolean create=false;
  PImage createModeTopBeltPicture;
  PImage createModeRightBeltPicture;
  PImage createModeLeftBeltPicture;
  PImage[] topBeltPictures;
  PImage[] leftBeltPictures;
  PImage[] rightBeltPictures;
 
  int topBeltImageNum;
  float speed=50;

  boolean collide=false;
  ImportGate importGate;
  ExportGate exportGate;
  
  ShapeItemTransport[] shapeItemTransport=new ShapeItemTransport[2];

  int pictureType=0;
  int realRotation=0;

  Collider collider;
  Collider[] directorCollider=new Collider[4];

  Belt() {
    createModeTopBeltPicture=loadImage("res_raw/sprites/blueprints/belt_top.png");
    createModeRightBeltPicture=loadImage("res_raw/sprites/blueprints/belt_right.png");
    createModeLeftBeltPicture=loadImage("res_raw/sprites/blueprints/belt_left.png");
    transform=new Transform();
    colliderInit();   
    gateInit();
    
  }
  Belt(Vector2 p, int r, String s) {
    float scl=146;
    transform=new Transform();
    transform.setPosition(p);
    rotation=r;
    realRotation=r;
    loadBeltImage(s);
    if(s=="forward") pictureType=0;
    else if(s=="right") pictureType=1;
    else if(s=="left") pictureType=2;
    collider=new Collider(p.x*scl+scl/2, p.y*scl+scl/2, scl, scl, this);
    collider.setTag("Building");
    game.colliders.add(collider);
    gateInit();
    for(Gate g:gates){
      g.link(p);
    }
    ShapeItemTransportInit();
  }
  
  void ShapeItemTransportInit(){
    
    float[][] dir= {{0, -1}, {1, 0}, {0, 1}, {-1, 0}};
    int[] pc={0,1,3};
    for(int i=0;i<shapeItemTransport.length;i+=1) shapeItemTransport[i]=new ShapeItemTransport();
    Vector2 position=transform.getPosition();
    float scl=146;
    float centerX=position.x*scl+scl/2;
    float centerY=position.y*scl+scl/2;
    Vector2 startPosition1=new Vector2(centerX+dir[(rotation+2)%4][0]*scl/2,centerY+dir[(rotation+2)%4][1]*scl/2);     
    Vector2 endPosition1=new Vector2(centerX,centerY);     
    shapeItemTransport[0].setTransform(startPosition1,endPosition1); 
    
    Vector2 startPosition2=new Vector2(centerX,centerY);
    Vector2 endPosition2=new Vector2(centerX+dir[(rotation+pc[pictureType])%4][0]*scl/2,centerY+dir[(rotation+pc[pictureType])%4][1]*scl/2);
    
    shapeItemTransport[1].setTransform(startPosition2,endPosition2);
    
    
  }
  void colliderInit() {
    collider=new Collider(0, 0, 146, 146, this);
    for (int i=0; i<directorCollider.length; i+=1) {
      directorCollider[i]=new Collider(0, 0, 146, 146);
    }
    game.colliders.add(collider);
  }
  void gateInit() {
    Vector2 position=transform.getPosition();
    gates=new ArrayList<Gate>();
    float[][] dir= {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}; 
    importGate=new ImportGate();
    exportGate=new ExportGate();
    exportGate.setRotation(rotation);
    importGate.setRotation((rotation+2)%4);
    if(pictureType==0){
      exportGate.setTransform(new Vector2(position.x+dir[(rotation+0)%4][0], position.y+dir[(rotation+0)%4][1]));
      importGate.setTransform(new Vector2(position.x+dir[(rotation+2)%4][0], position.y+dir[(rotation+2)%4][1]));
    }else if(pictureType==1){
      exportGate.setTransform(new Vector2(position.x+dir[(rotation+1)%4][0], position.y+dir[(rotation+1)%4][1]));
      importGate.setTransform(new Vector2(position.x+dir[(rotation+2)%4][0], position.y+dir[(rotation+2)%4][1]));
    }else{
      exportGate.setTransform(new Vector2(position.x+dir[(rotation+3)%4][0], position.y+dir[(rotation+3)%4][1]));
      importGate.setTransform(new Vector2(position.x+dir[(rotation+2)%4][0], position.y+dir[(rotation+2)%4][1]));
    }
    //importGate.transform.getPosition().println();
    //exportGate.transform.getPosition().println();
    
    gates.add(importGate);
    gates.add(exportGate);
    
    
  }
  
  

  void loadBeltImage(String s) {
    String Path_name = sketchPath("");
    String forward="res_raw/sprites/belt/built/"+s;
    File files=new File(Path_name+"data/"+forward);   
    topBeltImageNum=files.listFiles().length;
    topBeltPictures=new PImage[topBeltImageNum];
    for (int i=0; i<topBeltImageNum; i+=1) {
      topBeltPictures[i]=loadImage(forward+"/"+s+"_"+i+".png");
    }
  }

  void removes() {
    game.colliders.remove(this.collider);
  }


  void setSpeed(float s) {
    speed=s;
  }


  @Override
    void rotateBuilding() {
    rotation+=1;
    rotation%=4;
  }
  @Override
  void run(){
    
    transport();
    for(Gate g:gates) g.run(shapeItemTransport[1]);
    
  }
  void transport(){
    
    for(Gate g:gates){
      if(g.direction()==-1){
        if(g.shapeItem!=null && shapeItemTransport[0].shapeItem==null){
          shapeItemTransport[0].shapeItem=g.shapeItem;
          
          
        }
      }
    }
   
    
    if(shapeItemTransport[0].shapeItem!=null ){
      shapeItemTransport[0].run();
    }
    if(shapeItemTransport[1].shapeItem!=null){      
      shapeItemTransport[1].run();
         
       
      
    }
    for(int i=0;i<shapeItemTransport.length;i+=1){
      shapeItemTransport[i].show();
    }
    
    if(shapeItemTransport[0].getTime()>=1){
        if(shapeItemTransport[1].shapeItem==null){
          shapeItemTransport[1].shapeItem=shapeItemTransport[0].shapeItem;
          shapeItemTransport[0].shapeItem=null;         
          if(importGate!=null) importGate.shapeItem=null;          
          shapeItemTransport[0].reset();
        }
    }
    if(shapeItemTransport[1].getTime()>=1){
        
        if(exportGate.canTransport()) transShapItemToExport();
      }
  
  
  }
  void transShapItemToExport(){
    exportGate.shapeItem=shapeItemTransport[1].shapeItem;
    
    shapeItemTransport[1].reset();
  
  }

  @Override
    void build() {
    if (collide) {
      game.invalidButton=true;
      game.setInvalidTransform(new Vector2(mouseX, mouseY));
      game.resetInvalid();
      return;
    }
    int x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl);
    int y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl);
    Vector2 v= new Vector2(x, y);
    
    String s="";
    if(pictureType==0) s="forward";
    else if(pictureType==1) s="right";
    else s="left";
    game.buildings.add(new Belt(v, realRotation, s));
    //removes();
    //game.buildingMode=false;
    //game.buildingSelect=null;
  }

  @Override
    void setCreate(boolean b) {
    create=b;
  }

  @Override
    void show(float x, float y) {
    if (create) createModeShow(x, y);
    else normalShow();
  }
  @Override
    void destorySelf() {
    if (collider.getDestory()) {
      for(Gate g:gates) g.setDeath(true);
      game.colliders.remove(this.collider);
      game.buildings.remove(this);
    }
  }

  void show() {
  }
  void createModeShow(float x, float y) {
    imageMode(CENTER);  
    updateCollider();

    checkDirectorCollider();

    collide=false;
    float r=map(realRotation, 0, 4, 0, 2*PI);
    int _x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*146+146/2;
    int _y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*146+146/2;
    Box b=new Box(_x, _y, 146, 146);
    //b.show();
    ArrayList<Collider> found=new ArrayList<Collider>();
    Vector2 gPosition=game.cam.transform.getPosition();
    float scl=game.getScl();
    game.quadTree.query(b, found);


    for (Collider c : found) {
      if (c.tag.equals("Building")) {
        collide=true;
      }
    }

    if (collide)stroke(255, 0, 0);
    else stroke(0, 255, 0);
    noFill();
    rect(floor((_x-146/2)/146)*scl-gPosition.x+width/2+scl*0.1, floor((_y-146/2)/146)*scl-gPosition.y+height/2+scl*0.1, scl*0.8, scl*0.8, scl*0.1); 

    pushMatrix();
    translate(x, y);
    rotate(r);
    translate(-x, -y);
    if (pictureType==0)image(createModeTopBeltPicture, x, y, game.getScl(), game.getScl());
    else if (pictureType==1)image(createModeRightBeltPicture, x, y, game.getScl(), game.getScl());
    else image(createModeLeftBeltPicture, x, y, game.getScl(), game.getScl());
    for (Gate g : gates) g.show(x, y,pictureType);
    popMatrix();
  }
  void normalShow() {
    Vector2 position=transform.getPosition();
    imageMode(CORNER);
    pushMatrix();
    float scl=game.scl;
    float r=map(rotation, 0, 4, 0, 2*PI);
    float x=position.x*game.getScl()-game.cam.transform.getPosition().x+width/2+scl/2;
    float y=position.y*game.getScl()-game.cam.transform.getPosition().y+height/2+scl/2;
    translate(x, y);
    rotate(r);
    translate(-x, -y);  
    if(!liteMap)image(topBeltPictures[(int)(time.time*speed)%topBeltImageNum], position.x*game.getScl()-game.cam.transform.getPosition().x+width/2, position.y*game.getScl()-game.cam.transform.getPosition().y+height/2, game.getScl(), game.getScl());
    else{
      fill(150,liteLerp);
      noStroke();
      rectMode(CENTER);
      if(pictureType==0){
        rect(x,y,scl*1/3,scl);
      }else if(pictureType==1){
        rectMode(CORNER);
        rect(x-scl/2+scl*1/3,y-scl/2+scl*1/3,scl*1/3,scl*2/3);
        rect(x-scl/2+scl*1/3,y-scl/2+scl*1/3,scl*2/3,scl*1/3);
      }else if(pictureType==2){
        rectMode(CORNER);
        rect(x-scl/2+scl*1/3,y-scl/2+scl*1/3,scl*1/3,scl*2/3);
        rect(x-scl/2,y-scl/2+scl*1/3,scl*2/3,scl*1/3);
      }
    
    }
    popMatrix();


    if (debugMode)collider.show();
  }

  void updateCollider() {
    float scl=146;
    float x=floor((mouseX+game.cam.transform.position.x-width/2)/game.scl)*scl+scl/2;
    float y=floor((mouseY+game.cam.transform.position.y-height/2)/game.scl)*scl+scl/2;
    collider.setPosition(new Vector2(x, y));
    directorCollider[0].setPosition(new Vector2(x, y-scl));
    directorCollider[1].setPosition(new Vector2(x+scl, y));
    directorCollider[2].setPosition(new Vector2(x, y+scl));
    directorCollider[3].setPosition(new Vector2(x-scl, y));
    if (debugMode)collider.show();
  }

  void checkDirectorCollider() {
    boolean[] booleanDirector={false, false, false, false};
    Building[] bs={null, null, null, null};
    for (int i=0; i<directorCollider.length; i+=1) {
      ArrayList<Collider> found=new ArrayList<Collider>();
      Vector2 position=directorCollider[i].collider.transform.getPosition();
      Box b=new Box(position.x, position.y, 146, 146);
      game.quadTree.query(b, found);      
      for (Collider c : found) {
        if (c.tag.equals("Building")) {
          booleanDirector[i]=true;
          
          bs[i]=c.getBuilding();
        }
      }
    }

    
    setRealRotationAndPicture(rotation, booleanDirector, bs);
    
  }
  void setRealRotationAndPicture(int r, boolean[] booleanDirector, Building[] bs) {
    
    if (booleanDirector[(1+r)%4]&&booleanDirector[(3+r)%4]) {
      int Lcount=checkGate(bs[(3+r)%4]);
      int Rcount=checkGate(bs[(1+r)%4]);          
      if (abs(Lcount)==abs(Rcount)) {
        realRotation=(0+r)%4;
        pictureType=0;
      } else if (Lcount==1) {
        realRotation=(1+r)%4;
        pictureType=2;
      } else if (Lcount==-1) {
        realRotation=(0+r)%4;
        pictureType=2;
      } else if (Rcount==1) {
        realRotation=(3+r)%4;
        pictureType=1;
      } else {
        realRotation=(0+r)%4;
        pictureType=1;
      }
    } else if (booleanDirector[(1+r)%4]) {
      int Rcount=checkGate(bs[(1+r)%4]);
      if (Rcount==1) {
        realRotation=(3+r)%4;
        pictureType=1;
      } else if (Rcount==-1) {
        realRotation=(0+r)%4;
        pictureType=1;
      } else {
        realRotation=(0+r)%4;
        pictureType=0;
      }
    } else if (booleanDirector[(3+r)%4]) {
      int Lcount=checkGate(bs[(3+r)%4]);
      
      if (Lcount==1) {
        realRotation=(1+r)%4;
        pictureType=2;
      } else if (Lcount==-1) {
        realRotation=(0+r)%4;
        pictureType=2;
      }else {
        realRotation=(0+r)%4;
        pictureType=0;
      }
    } else {
      
      realRotation=(0+r)%4;
      pictureType=0;
    }
  }


  int checkGate(Building bs) {
    Vector2 gPosition=game.cam.transform.getPosition();
    Vector2 position=new Vector2(floor((mouseX+gPosition.x-width/2)/game.scl), floor((mouseY+gPosition.y-height/2)/game.scl));
    
    for (Gate g : bs.gates) {
      if (g.transform.position.equal(position)) {
        return g.direction();
      }
    }
    return 0;
  }
}
