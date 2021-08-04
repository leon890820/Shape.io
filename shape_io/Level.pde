class LevelManager{
  ShapeItem targetShapeItem;
  int tagetNumber;
  int currentNumber;
  int level=1;
  String nextItem;
  JSONObject levelManagerLanguage;
  JSONObject levelTargetLanguage;
  Backpad backpad;
  boolean finish=false;
  boolean tutorial=false;
  BigTutorial bigTutorial;
  LevelManager(JSONObject lml,Backpad b,JSONObject tl){
    ShapeItem si=new ShapeItem();
    si.setAllCircle();
    int tn=30;    
    targetShapeItem=si;
    tagetNumber=tn;
    levelManagerLanguage=lml;
    levelTargetLanguage=levelManagerLanguage.getJSONArray("level").getJSONObject(0);
    nextItem=levelTargetLanguage.getString("nextItem");
    backpad=b;
    bigTutorial=new BigTutorial(tl);
    
  }
  
  void setNextLevel(){
    levelTargetLanguage=levelManagerLanguage.getJSONArray("level").getJSONObject(level);
    currentNumber=0;
    level+=1;
    switch(level){
      case 2:
        int[] in={-1,1,1,-1};
        tagetNumber=150;        
        targetShapeItem.setShapeItem(in);
        game.tutorial.setEnable(true);
        game.toolbox.setEnable(true);
        tutorial=true;
        game.tutorial.setNewTutorial("2_1_place_cutter.gif","inform3");
        game.toolbox.trash.setUseable(true);
        game.toolbox.cutter.setUseable(true);
        break;
      case 3:
        finished();
        break;
        
    
    }
  
  }
  void finished(){
    finish=true;
    tagetNumber=999999999;
    currentNumber=0;
  
  }
  
  void run(){
    checkBackpad();
    if(!liteMap){
      if(!finish)normalShow();
      else finishShow();
    }
    ckeckIsTargeted();
    if(tutorial) bigTutorial.show();
  }
  
  void ckeckIsTargeted(){
    if(tagetNumber<=currentNumber) setNextLevel();  
  }
  
  void checkBackpad(){
    currentNumber=backpad.getShapeItemCount(targetShapeItem);
  }
  void finishShow(){
    float scl=game.scl;
    Vector2 position=game.cam.transform.getPosition();
    textAlign(CENTER,TOP);
    fill(255);
    textSize(30*scl/146);
    float x=-190;
    float y=-240;
    text("LV",x/146.0*scl-position.x+width/2,y/146.0*scl-position.y+height/2);
    text("∞",x/146.0*scl-position.x+width/2,(y+45)/146.0*scl-position.y+height/2);
    
    fill(0);
    text(levelManagerLanguage.getString("finish"),(x+200)/146.0*scl-position.x+width/2,(y+200)/146.0*scl-position.y+height/2);
  
  }
  
  void normalShow(){
    float scl=game.scl;
    Vector2 position=game.cam.transform.getPosition();
    textAlign(CENTER,TOP);
    fill(255);
    textSize(30*scl/146);
    float x=-190;
    float y=-240;
    text("LV",x/146.0*scl-position.x+width/2,y/146.0*scl-position.y+height/2);
    text(level,x/146.0*scl-position.x+width/2,(y+45)/146.0*scl-position.y+height/2);
    targetShapeItem.show((x+100)/146.0*scl-position.x+width/2,(y+200)/146.0*scl-position.y+height/2,2);
    textSize(60*scl/146);
    fill(50);textAlign(LEFT,TOP);
    text(currentNumber,(x+220)/146.0*scl-position.x+width/2,(y+130)/146.0*scl-position.y+height/2);
    textSize(50*scl/146);
    fill(150);
    text("/ "+tagetNumber,(x+220)/146.0*scl-position.x+width/2,(y+200)/146.0*scl-position.y+height/2);
    fill(50);
    textSize(40*scl/146);
    text(levelManagerLanguage.getString("give"),(x+180)/146.0*scl-position.x+width/2,(y+20)/146.0*scl-position.y+height/2);
    textAlign(CENTER,TOP);
    text(levelManagerLanguage.getString("unlock"),(x+190)/146.0*scl-position.x+width/2,(y+320)/146.0*scl-position.y+height/2);
    fill(255,0,0);
    textSize(40*scl/146);
    text(levelTargetLanguage.getString("nextItem"),(x+190)/146.0*scl-position.x+width/2,(y+370)/146.0*scl-position.y+height/2);
  
  }



}

class TutorialManager{
  int count=0;
  Tutorial tutorial;
  TutorialManager(Tutorial t){
    tutorial=t;
  
  }
  void addNewTutorial(){
    count+=1;
    
    switch(count){
      case 1:
        tutorial.setNewTutorial("1_2_conveyor.gif","inform2");
        break;
      
      case 2:
      
        break;
    
    
    }
  
  }


}
