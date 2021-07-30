class Game{
  Camera cam;
  float scl=146;
  int rows;
  int cols;
  boolean buildingMode=false;
  HomeBuilding homeBuilding;
  Toolbox toolbox;
  ArrayList<MineManager> mineManagers;
  ArrayList<Building> buildings;
  ArrayList<HintButton> hintButtonNormal;
  ArrayList<HintButton> hintButtonCreate;
  ArrayList<Collider> colliders;
  Building buildingSelect;  
  JSONObject gameLanguage;
  
  boolean invalidButton=false;
  Invalid invalid;
  QuadTree quadTree;
  Cursor cursor;
  Backpad backpad;
  BackpadUI backpadUI;
  Tutorial tutorial;
  TutorialManager tutorialManager;
  
  Game(PApplet p){
    gameLanguage=language.getJSONObject("game");
    cam=new Camera();
    rows=width/(int)scl;
    cols=height/(int)scl;
    colliders=new ArrayList<Collider>();
    homeBuilding=new HomeBuilding(cam,colliders);
    toolbox=new Toolbox();
    mineManagers=new ArrayList<MineManager>();
    buildings=new ArrayList<Building>();
    hintButtonNormal=new ArrayList<HintButton>();
    hintButtonCreate=new ArrayList<HintButton>();    
    createMineMangers(colliders);
    createHintButton();
    cursor=new Cursor(mouseX,mouseY);
    colliders.add(cursor.collider);
    backpad=new Backpad();
    quadTree=new QuadTree(0,0,20000000,20000000);
    createInvalid();
    backpadUI=new BackpadUI(backpad,gameLanguage.getJSONObject("Backpad"));
    tutorial=new Tutorial(gameLanguage.getJSONObject("Tutorial"),"1_1_extractor.gif",p);
    tutorialManager=new TutorialManager(tutorial);
    
    
  }
  void createInvalid(){
    JSONObject invalidLanguage=gameLanguage.getJSONObject("InvalidWord");
    invalid=new Invalid(invalidLanguage.getString("collide"));
  }
  void createHintButton(){
    JSONObject hintLanguage=gameLanguage.getJSONObject("HintButton");
    hintButtonNormal.add(new HintButton("left",hintLanguage.getString("move"),new Vector2(30,30)));
    hintButtonNormal.add(new HintButton("right",hintLanguage.getString("delete"),new Vector2(30,70)));
    hintButtonNormal.add(new HintButton("I",hintLanguage.getString("backpad"),new Vector2(30,110)));
    
    hintButtonCreate.add(new HintButton("R",hintLanguage.getString("rotate"),new Vector2(30,30)));
    hintButtonCreate.add(new HintButton("right",hintLanguage.getString("stop"),new Vector2(30,70)));
    hintButtonCreate.add(new HintButton("left",hintLanguage.getString("put"),new Vector2(30,110)));
    
  
  }
  
  
  void createMineMangers(ArrayList collider){
    for(int i=-2;i<=2;i+=1){
      for(int j=-2;j<=2;j+=1){
        if (i==0 && j==0) continue;
        Vector2[] v={new Vector2(i*20-10,j*20-10),new Vector2(i*20+10,j*20+10)};
        mineManagers.add(new MineManager(v,(int)random(2),collider));
      }
    }
    
    
  }
  
  float getScl(){
    return scl;
  }
  void setBuildingMode(boolean b){
    buildingMode=b;
  }
  void setScl(float s){
    scl=s;
    rows=width/(int)scl;
    cols=height/(int)scl;
  }
  
  void run(){ 
    quadTree=new QuadTree(0,0,20000000,20000000);
    for(Collider c:colliders) quadTree.insert(c);
    
    backgroundNet();
    
    
    for(MineManager mm:mineManagers) mm.show();    
    for(Building bb:buildings) bb.show(0,0);
    for(Building bb:buildings) bb.run();
    homeBuilding.run();
    homeBuilding.show();
    
    cursor.run(new Vector2((mouseX+cam.transform.getPosition().x-width/2)/scl*146,(mouseY+cam.transform.getPosition().y-height/2)/scl*146));    
    cam.camSpotLight();
    if(buildingMode) {
      buildingSelect.show(mouseX,mouseY);
      for(HintButton hh:hintButtonCreate) hh.show();
    }else{
      for(HintButton hh:hintButtonNormal) hh.show();
    }
     
    toolbox.show(width/2-toolbox.panel.width/2,height*18.5/20-toolbox.panel.height/2); 
    invalidBuilding();
    for(int i=buildings.size()-1;i>=0;i-=1){
      buildings.get(i).destorySelf();
    }
    
    tutorial.show(0,0);
    if(backpadMode) backpadUI.show(0,0);
    UIMode=UIBOOL();
  }
  
  void backgroundNet(){
    Vector2 camPosition=cam.transform.getPosition();    
    for(int i=int(camPosition.x/scl-rows/2)-2;i<(int)camPosition.x/scl+rows/2+2;i+=1){
      for(int j=int(camPosition.y/scl-cols/2)-2;j<(int)camPosition.y/scl+cols/2+2;j+=1){
        noFill();
        stroke(200,200);
        strokeWeight(scl/36.5);
        rectMode(CORNER);
        rect(i*scl-camPosition.x+width/2,j*scl-camPosition.y+height/2,scl,scl);
      }
    }
  
  }
  void invalidBuilding(){
    if(invalidButton){
      invalid.run();
    }
  
  }
  void resetInvalid(){
    invalid.reset();
  }
  void setInvalidTransform(Vector2 p){
    invalid.setTransform(p);
  }
}

class Invalid{
  Time time;
  Transform transform;
  String word;
  float speed=100;
  Invalid(String s){
    time=new Time();  
    transform=new Transform();
    transform.setPosition(new Vector2(mouseX,mouseY));
    word=s;
  }
  void setTransform(Vector2 p){
    transform.setPosition(p);
  }
  void run(){
    Vector2 position=transform.getPosition();
    time.run();
    fill(255,0,0);
    textSize(20);
    text(word,position.x,position.y-time.time*speed);
    if(time.time>1) game.invalidButton=false;
    
  
  }
  void reset(){
    time.reset();
  }


}
