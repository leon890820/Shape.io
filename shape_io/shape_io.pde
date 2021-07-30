import gifAnimation.*;
import processing.sound.*;
import processing.video.*;
import java.io.File;

PFont myFont;
float ratio=1.6;
int viewport_h = 850;
int viewport_w = int((float)viewport_h*ratio);
int viewport_x=(1920-viewport_w)/2;
int viewport_y=(1080-viewport_h)/2;

float INFINITY=1.0/0.0;

boolean menuMode=true;
boolean gameMode=false;
boolean debugMode=false;
boolean backpadMode=false;
boolean UIMode=false;

JSONObject language;

PImage allItemImage;
PImage cursor;

Menu menu;
Game game;

Time time;

void settings() {
  size(viewport_w, viewport_h,P2D);
}

void setup() {  
  surface.setLocation(viewport_x, viewport_y);
  surface.hideCursor();
  allItemImage=loadImage("res_built/atlas/atlas0_hq.png");
  cursor=loadImage("res_raw/sprites/misc/cursor.png");
  myFont = createFont("微軟正黑體", 100);
  textFont(myFont);
  language=loadJSONObject("language/zh.json");
  noiseSeed(0);
  menu=new Menu(this);
  game=new Game(this);
  time=new Time();
  
}

void draw() {
  background(250);
  if (menuMode) menu.run();
  else if (gameMode) game.run();
  showCursor();
  String txt_fps = String.format(getClass().getName()+ " [frame %d]   [fps %6.2f]", frameCount, frameRate);
  surface.setTitle(txt_fps);
  time.run();
}

boolean UIBOOL(){
  return backpadMode;
}

//void movieEvent(Movie m) {
  //m.read();
//}

void mouseDragged() {
  if (mouseButton == LEFT) {
    if (gameMode && !UIMode) {
      float deltaMouseX=pmouseX-mouseX;
      float deltaMouseY=pmouseY-mouseY;
      game.cam.transform.setPosition(Vector2.plus(game.cam.transform.getPosition(), new Vector2(deltaMouseX, deltaMouseY)));
    }
  }
}
void mouseWheel(MouseEvent event) {
  if (gameMode && !UIMode) {
    float e = event.getCount();  
    float ee=(game.getScl()*pow(0.95, e));
    if(ee>200) ee=200;
    if(ee<20) ee=20;
    game.setScl(ee);
  }
}
void mousePressed() {
  if (game.buildingMode) {
    if (mouseButton == LEFT) {
      game.buildingSelect.build();
    } else if (mouseButton == RIGHT) {
      game.buildingSelect.removes();
      game.buildingMode=false;
      game.buildingSelect=null;
    }
  } else {
    if (mouseButton == RIGHT && !UIMode) {
      game.cursor.destory();
    }
  }
}

void keyPressed() {
  if (game.buildingMode) {
    if (keyPressed) {
      if (key=='R'||key=='r') {       
        game.buildingSelect.rotateBuilding();
      }
    }
  }
  if (key=='P'||key=='p') {
    debugMode=!debugMode;
  }
  if(gameMode){
    if(key=='I' || key=='i'){
      backpadMode=!backpadMode;
      game.buildingMode=false;
      game.toolbox.set(!backpadMode);
    }
  }
}

void showCursor() {
  imageMode(CENTER);
  image(cursor, mouseX+8, mouseY+11, 23, 35);
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
