class Button {
  private PVector position;
  private PVector pp;
  private float len=150;
  private float hei=50;
  private String name;
  private int num;
  private float r;
  public boolean touch=false;
  public boolean pressed=false;
  private color backgroundColor=color(255);
  private color backgroundColorT=color(220);
  private color textColor=color(255);
  private color lerpColor;
  private boolean selectable=false;
  private int textSizes=40;
  private boolean lerpable=false;
  Button(String _name, float _x, float _y,  float _len, float _hei,float _r) {
    name=_name;
    position=new PVector(_x, _y);
    len=_len;
    hei=_hei;
    r=_r;
    pp=position.copy();
  }
  void setTextColor(color c){
    textColor=c;
  }
  void setBGC(color c){
    backgroundColor=c;
  }
  void setBGCT(color c){
    backgroundColorT=c;
  }
  void setSelectable(boolean b){
    selectable=b;
  }
  void setTextSize(int s){
    textSizes=s;
  }
  void setPosition(PVector p){
    position=p;
    pp=p.copy();
  }
  
  void show() {
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    if (touch==false) fill(backgroundColor);
    else fill(backgroundColorT);
    if(lerpable){
      if(touch)lerpColor=lerpColor(lerpColor,backgroundColorT,0.2);
      else lerpColor=lerpColor(lerpColor,backgroundColor,0.2);
      fill(lerpColor);
    }
    //stroke(255);
    //strokeWeight(3);
    noStroke();
    smoothRect(position.x, position.y, len, hei,r);
    fill(textColor);
    textSize(textSizes);
    text(name, position.x, position.y-3);
  }
  
  void smoothRect(float x,float y,float l,float h,float r){
    float prx=x+l/2-r;
    float nrx=x-l/2+r;
    float pry=y+h/2-r;
    float nry=y-h/2+r;
    
    
    beginShape();
    vertex(nrx,nry-r);
    vertex(prx,nry-r);
    quarterCircle(prx,nry,-PI/2,0,r);
    vertex(prx+r,nry);
    vertex(prx+r,pry);
    quarterCircle(prx,pry,0,PI/2,r);
    vertex(prx,pry+r);
    vertex(nrx,pry+r);
    quarterCircle(nrx,pry,PI/2,PI,r);
    vertex(nrx-r,pry);
    vertex(nrx-r,nry);
    quarterCircle(nrx,nry,PI,3*PI/2,r);
    endShape(CLOSE);
  
  
  }
  void quarterCircle(float x,float y,float sa,float ea,float r){
    for(int i=0;i<=90;i+=1){
      float theda=map(i,0,90,sa,ea);
      
      vertex(x+(r)*cos(theda),y+(r)*sin(theda));
    }
  }
  
  void sliderShow(){
    rectMode(CENTER);
    textAlign(CENTER, CENTER);
    if (touch==false) fill(backgroundColor);
    else fill(backgroundColorT);
    noStroke();
    rect(position.x,position.y,len,hei);
    fill(255);
    textSize(20);
    text(name,position.x,position.y-3);
  }
  void sliderShow(PGraphics p){
    p.rectMode(CENTER);
    p.textAlign(CENTER, CENTER);
    if (touch==false) p.fill(backgroundColor);
    else p.fill(backgroundColorT);
    
    p.noStroke();
    p.rect(position.x,position.y,len,hei);
    p.fill(255);
    p.textSize(20);
    p.text(name,position.x,position.y-3);
  }
  
  
  PVector sliderSelect(){
    if(mouseX>position.x-len/2 && mouseX<position.x+len/2 && mouseY>position.y-hei/2 && mouseY<position.y+hei/2){
      touch=true;
    }
    
    
    if (touch==true && mousePressed == true){
      position.x=mouseX;
      position.y=mouseY;
    }
    else touch=false;
    return position;
    
  }
  
  PVector sliderSelect(PGraphics p){
    float mx=mouseX-(width-p.width)/2;
    float my=mouseY-(height-p.height)/2;
    if(mx>position.x-len/2 && mx<position.x+len/2 && my>position.y-hei/2 && my<position.y+hei/2){
      touch=true;
    }
    
    
    if (touch==true && mousePressed == true){
      position.x=mx;
      position.y=my;
    }
    else touch=false;
    return position;
    
  }
  
  
  void run(String s) {
    if(selectable==false)return;
    if (mouseX>pp.x-len/2 && mouseX<pp.x+len/2 && mouseY>pp.y-hei/2 && mouseY<pp.y+hei/2) {
      touch=true;
    } else touch=false;     
    if (touch==true && mousePressed == true) {
      if (pressed==false) {
        
        // here the code
        switch(s){
          case "start":
            startGame();
            break;
          case "belt":
            createBelt();
            break;
          case "miner":
            createMiner();
            break;
          case "cutter":
            createCutter();
            break;
           case "trash":
             createTrasher();
              break;
            
          
          case "next":
            next();
        }
        
        
        
        pressed=true;
      }
    } else pressed=false;
  }
  void next(){
    game.tutorial.setEnable(false);
    game.toolbox.setEnable(false);
    game.levelManager.tutorial=false;
  
  }
  
  void startGame(){
    gameMode=true;
    menuMode=false;
  }
  
  void createBelt(){
   
   game.setBuildingMode(true);
   game.buildingSelect=new Belt();
   game.buildingSelect.setCreate(true);
  }
  void createCutter(){
    game.setBuildingMode(true);
    game.buildingSelect=new Cutter();
    game.buildingSelect.setCreate(true);
  
  }
  void createMiner(){
   game.setBuildingMode(true);
   game.buildingSelect=new Miner();
   game.buildingSelect.setCreate(true);
  }
   void createTrasher(){
   game.setBuildingMode(true);
   game.buildingSelect=new Trasher();
   game.buildingSelect.setCreate(true);
  }
  
  
  
}


class Slider{
  PVector startposition;
  PVector  endposition;
  PVector position;
  float value=0;
  float len;
  float hei;
  float max;
  float min;
  float v;
  boolean touch=false;
  String name;
  Button sliderButton;
  Slider(String _name,float startpx,float startpy,float endpx,float endpy,float _len,float _hei,float _min,float _max){
    name=_name;
    startposition=new PVector(startpx,startpy);
    endposition=new PVector(endpx,endpy);
    position=startposition.copy();
    len=_len;
    hei=_hei;
    max=_max;
    min=_min;
    sliderButton=new Button("",startposition.x,startposition.y,_len,_hei,0);
    sliderButton.setBGC(color(0));
    sliderButton.setBGCT(color(100));
    v=(max-min)*value/100+min;  
}
  void run(){
    position=sliderButton.sliderSelect();
    constrainbutton();
    calcValue();
    show();
  }
  void run(PGraphics p){
    position=sliderButton.sliderSelect(p);
    constrainbutton();
    calcValue();
    show(p);
  }
  void constrainbutton(){
    if(position.x<startposition.x) position.x=startposition.x;
    if(position.y<startposition.y) position.y=startposition.y;
    if(position.x>endposition.x) position.x=endposition.x;
    if(position.y>endposition.y) position.y=endposition.y;
    sliderButton.position=position;
  }
  float calcValue(){    
    float d=dist(startposition.x,startposition.y,endposition.x,endposition.y);
    float v=dist(position.x,position.y,startposition.x,startposition.y);
    value=v/d*100;
    return value;
  }
  void show(){
    rectMode(CENTER);
    fill(200);
    v=(max-min)*value/100+min;
    rect((startposition.x+endposition.x)/2,(startposition.y+endposition.y)/2,endposition.x-startposition.x+len,endposition.y-startposition.y+hei);
    sliderButton.sliderShow();
      
  }
  void show(PGraphics p){
    p.rectMode(CENTER);
    p.fill(200);
    v=(max-min)*value/100+min;
    p.rect((startposition.x+endposition.x)/2,(startposition.y+endposition.y)/2,endposition.x-startposition.x+len,endposition.y-startposition.y+hei);
    sliderButton.sliderShow(p);
   
      
  }
  void showtext(float _x,float _y,int a){
    textSize(16);
    float v=(max-min)*value/100+min;
    text(name+" : "+str((int)v),_x,_y);
    
  }
  void showtext(float _x,float _y){
    textSize(16);
    
    text(name+" : "+str(v),_x,_y);
    
  }
  
  
}
