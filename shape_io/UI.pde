abstract class UI {
  UI() {
  }
  abstract void show(float x, float y);
}

class SkillTreeUI extends UI{
  SkillTreeUI(){
  
  }
  void show(float x,float y){
    
  }

}


class BackpadUI extends UI{
  Backpad backpad;
  PGraphics pGraph;
  int rows=5;
  Slider slider;
  int PWidth=width*7/8;
  int PHeight=height*7/8;
  JSONObject backpadLangue;
  BackpadUI(Backpad b,JSONObject _backpadLangue){
    backpadLangue=_backpadLangue;
    int sliderWidth=10;
    int sliderHeight=20;
    pGraph=createGraphics(PWidth,PHeight);
    backpad=b;
    slider=new Slider("slider", PWidth-sliderWidth*3,PHeight*0.05, PWidth-sliderWidth*3, PHeight*0.95, sliderWidth, sliderHeight, 0, 0);
  }
  
  @Override
  void show(float x,float y){
    rectMode(CORNER);
    fill(200,200);
    noStroke();
    rect(0,0,width,height);
    pGraph.beginDraw();
    
    
    pGraph.background(0,0);
    pGraph.rectMode(CENTER);
    pGraph.noStroke();
    pGraph.fill(250);
    pGraph.rect(PWidth/2,PHeight/2,PWidth,PHeight,20);
    //slider.show(pGraph);
    float value=slider.calcValue();
    slider.run(pGraph);
    
   
    
    backpadShow(pGraph,value);
    
    pGraph.endDraw();
    
    pGraph.textFont(myFont);
    
    imageMode(CENTER);
    image(pGraph,width/2,height/2);
    
    
    textSize(40);
    textAlign(CORNER,CORNER);
    fill(0);
    text(backpadLangue.getString("backpad"),(width-PWidth*0.95)/2,(height-PHeight*0.85)/2);
    
  }
  
  void backpadShow(PGraphics p,float v){
    int cols=ceil((float)backpad.shapeItemCounts.size()/5.0)+2;
    float wid=float(p.width)*0.9/float(rows);
    float hei=wid*1.3;
    p.rectMode(CENTER);
    p.fill(240);
    p.noStroke();
    float bais=(cols-2)*hei*v/100;
    for(int i=0;i<cols;i+=1){
      for(int j=0;j<rows;j+=1){        
        p.rect(p.width*0.45+(j-rows/2)*wid,p.height*0.1+hei/2+i*hei-bais,wid*0.8,hei*0.8);        
      }
    }
    String numLan=backpadLangue.getString("num");
    for(int i=0;i<backpad.shapeItemCounts.size();i+=1){
      ShapeItemCount sic=backpad.shapeItemCounts.get(i);
      int x=i%rows;
      int y=i/rows;
      sic.shapeItem.show(p.width*0.45+(x-rows/2)*wid,p.height*0.1+hei*0.8/2+y*hei-bais,wid*0.9,p);
      textAlign(CENTER,CENTER);
      p.text(numLan+ " : " + sic.count,p.width*0.45+(x-rows/2)*wid,p.height*0.1+hei*1.6/2+y*hei-bais);
    
    }
    
    
  }

}

class HintButton extends UI{
  Transform transform;
  String button;
  String name;
  Button background;
  PImage click;
  HintButton(String s,String _name,Vector2 p){
    transform=new Transform();
    transform.setPosition(p);
    button=s;
    name=_name;
    background=new Button(s,p.x,p.y,30,30,5);
    background.setBGC(color(245));
    background.setSelectable(false);
    background.setTextColor(color(150));
    background.setTextSize(25);
    if(s=="right"){
      click=loadImage("res/ui/icons/mouse_right.png");
    }else if(s=="left"){
      click=loadImage("res/ui/icons/mouse_left.png");
    }
  }
  void show(){
    Vector2 position=transform.getPosition();
    if(button=="right" || button=="left"){
      imageMode(CENTER);
      image(click,position.x,position.y,30,30);
      fill(0);
      textSize(20);
      textAlign(CORNER,CENTER);
      text(name,position.x+30,position.y-4);
    }else{
      background.show();      
      fill(0);
      textSize(20);
      textAlign(CORNER,CENTER);
      text(name,position.x+30,position.y-4);
    }
  }
  @Override
  void show(float x,float y){
    
  }
  

}


class Panel extends UI {
  PImage panel;
  int width;
  int height;
  Panel(int w, int h) {
    this.width=w;
    this.height=h;
    panel=createImage(w, h, 0);
  }

  @Override
  void show(float x, float y) {
    imageMode(CORNER);
    image(panel, x, y);
  }
  void show(float x, float y,float w,float h) {
    imageMode(CORNER);
    image(panel, x, y,w,h);
  }

  void setPanel(color c) {
    panel.loadPixels();
    for (int i=0; i<panel.pixels.length; i+=1) {
      panel.pixels[i]=c;
    }    
    panel.updatePixels();
  }
}

class Tutorial extends UI {
  Button button;
  String tutorialText;
  Gif tutorialGIF;
  JSONObject JSONOBjectLanguage;
  float lerpC=255;
  String cd="res/ui/interactive_tutorial.noinline/";
  String inform="inform1";
  boolean enable=false;
  PApplet p;
  Tutorial(JSONObject JO,String loadingString,PApplet _p) {
    JSONOBjectLanguage=JO;
    p=_p;
    tutorialGIF=new Gif(p,cd+loadingString);
    button=new Button("",width/10+width/40,height*5/8+height/30,width/5,height*2/5,0);
    button.setBGC(color(100));
    button.setBGCT(color(0,0,0,1));
    button.setSelectable(true);
    button.lerpable=true;
    tutorialGIF.loop();
    
  }
  void setNewTutorial(String loading ,String _inform){
    tutorialGIF=new Gif(p,cd+loading);
    inform=_inform;
    tutorialGIF.loop();
  }
  void setEnable(boolean b){
    enable=b;
  }
  
  
  @Override
    void show(float x, float y) {
      if(enable) return;
      button.show();
      button.run("");
      imageMode(CENTER);
      if(button.touch) lerpC=lerp(lerpC,0,0.1);
      else lerpC=lerp(lerpC,255,0.1);
      tint(255, lerpC);
      image(tutorialGIF,width/10+width/40,height*5/8+height/12,width*0.8/5,width*0.8/5);
      tint(255, 255);
      textAlign(CORNER,TOP);
      fill(255,lerpC);
      textSize(18);
      text(JSONOBjectLanguage.getString("tutor"),width/60+width/80,height*4/8-height/30);
      text(JSONOBjectLanguage.getString(inform),width/60+width/80,height*4/8);
  }
}



class Toolbox extends UI {
  Panel panel;
  int toolNumber=10;
  int tWidth;
  int tHeight;

  Tool belt;
  Tool balancer;
  Tool undergroundBelt;
  Tool miner;
  Tool cutter;
  Tool rotater;
  Tool stacker;
  Tool mixer;
  Tool painter;
  Tool trash;
  Tool[] tools=new Tool[toolNumber];
  PImage lock;

  Toolbox() {
    panel=new Panel(height/10*toolNumber, height/10);
    panel.setPanel(color(220, 200));
    tWidth=height/10*toolNumber;
    tHeight=height/10;
    createTool();
  }
  void set(boolean b){
    for(Tool t:tools){
      t.set(b);
    }
  
  }
  
  void createTool(){
    belt=new Tool("belt",0, this,true);
    balancer=new Tool("balancer",1, this,false);
    undergroundBelt=new Tool("underground_belt",2, this,false);
    miner=new Tool("miner",3, this,true);
    cutter=new Tool("cutter",4, this,false);
    rotater=new Tool("rotater",5, this,false);
    stacker=new Tool("stacker",6, this,false);
    mixer=new Tool("mixer",7, this,false);
    painter=new Tool("painter",8, this,false);
    trash=new Tool("trash",9, this,true);
    tools[0]=belt;
    tools[1]=balancer;
    tools[2]=undergroundBelt;
    tools[3]=miner;
    tools[4]=cutter;
    tools[5]=rotater;
    tools[6]=stacker;
    tools[7]=mixer;  
    tools[8]=painter;
    tools[9]=trash;     
    lock=loadImage("res/ui/locked_building.png");
  }
  
  
  @Override
  void show(float x, float y) {
    //panel.show(x, y);
    for(int i=0;i<tools.length;i+=1){
      tools[i].show(x+tHeight*i, y);
    }
  }
}

class Tool extends UI {
  PImage toolImage;
  Button button;
  Toolbox toolbox;
  Boolean useable=false;
  String name;
  Tool(String s,int i, Toolbox t,Boolean u) {
    name=s;
    toolImage=loadImage("res/ui/building_icons/"+s+".png");
    toolbox=t;
    button=new Button("",(width/2-t.tWidth/2+t.tHeight/2)+i*t.tHeight,height*18.5/20,toolbox.tHeight,toolbox.tHeight,0);
    button.setBGC(color(220,200));
    button.setBGCT(color(100,220));
    button.setSelectable(u);
    useable=u;
  }
  void set(boolean b){
    if(useable){
      button.setSelectable(b);
    }
  }
  
  @Override
  void show(float x, float y) {    
    imageMode(CORNER);
    button.show();
    button.run(name);
    if(useable)image(toolImage, x, y, toolbox.tHeight, toolbox.tHeight);
    else image(toolbox.lock,x,y,toolbox.tHeight, toolbox.tHeight);  
  }
}
