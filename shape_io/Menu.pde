class Menu{
  //Movie menuBackground;
  SoundFile menuSound;
  PImage menuBackgroundlogo;
  Panel panel;
  Button startButtonBackground;
  Button startButton;
  JSONObject menuLanguage;
  Menu(PApplet p){
    menuLanguage=language.getJSONObject("menu");
    //menuSound=new SoundFile(p,"res_raw/sounds/music/menu.wav");
    //menuSound.loop();
    //thread("loadMenuBackground");
    //loadMenuBackground(p);
    menuBackgroundlogo=loadImage("res/logo.png");
    panel=new Panel(width,height);
    panel.setPanel(color(220,220));
    startButtonBackground=new Button("",width/2,height/2,width/3,height/5,10);
    startButton=new Button(menuLanguage.getString("start"),startButtonBackground.position.x,startButtonBackground.position.y,startButtonBackground.len*0.6,startButtonBackground.hei*0.6,10);
    colorMode(HSB);
    startButton.setBGC(color(100,255,200));
    startButton.setBGCT(color(100,255,150));
    startButton.setSelectable(true);
    colorMode(RGB);
  }
  void loadMenuBackground(PApplet p){
    //menuBackground=new Movie(p,"res/bg_render.mp4");
    //menuBackground.loop();
  }
  
  
  void run(){
    imageMode(CORNER);
    //if(menuBackground!=null)image(menuBackground,0,0);    
    //panel.show(0,0);
    rectMode(CORNER);
    fill(220,220);
    noStroke();
    rect(0,0,width,height);
    imageMode(CENTER);
    image(menuBackgroundlogo,width/2,height/5,menuBackgroundlogo.width*1920/width,menuBackgroundlogo.height*1080/height);
    startButtonBackground.show();
    startButton.show();
    startButton.run("start");
    
    pushMatrix();
    translate(width/2+menuBackgroundlogo.width*1920/width/2-200,height/4+menuBackgroundlogo.height*1080/height/2);
    rectMode(CENTER);
    rotate(-PI/6);
    fill(255,153,18);
    text("v"+menuLanguage.getString("verson")+"!",0,0);
    
    popMatrix();
    
  }







}
