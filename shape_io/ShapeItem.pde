class ShapeItem extends SaveableItem{
  Shape[] shapes=new Shape[4];
  Transform transform;
  
  ShapeItem(){
    transform=new Transform();
    
  }
  ShapeItem clone(){
    ShapeItem si=new ShapeItem();
    for(int i=0;i<si.shapes.length;i+=1){
      si.shapes[i]=this.shapes[i].clone();
    }
    si.transform.position=transform.position.copy();
    return si;
  }
  void setAllCircle(){
    for(int i=0;i<shapes.length;i+=1){
      shapes[i]=new CircleShape(i);
    }
  }
  
  void setAllRectangle(){
    for(int i=0;i<shapes.length;i+=1){
      shapes[i]=new RectangleShape(i);
    }
  }
  boolean equal(ShapeItem si){
    for(int i=0;i<shapes.length;i+=1){
      if(shapes[i].getClass()!=si.shapes[i].getClass()){
        return false;
      }
    }
    
    return true;
  }
  
  void show(){
    fill(200,220);
    noStroke();
    Vector2 position=transform.getPosition();
    
    circle(position.x*game.scl+game.scl/2-game.cam.transform.getPosition().x+width/2,position.y*game.scl+game.scl/2-game.cam.transform.getPosition().y+height/2,game.scl*1.2/2);
    for(Shape s:shapes){  
      if(s==null)continue;
      s.show(position.x*game.scl+game.scl/2-game.cam.transform.getPosition().x+width/2,position.y*game.scl+game.scl/2-game.cam.transform.getPosition().y+height/2,0.9);
    }
  }
  
  void show(float x,float y){
    fill(200,240);
    noStroke();
    
    
    circle(x,y,game.scl*0.9/2);
    for(Shape s:shapes){  
      if(s==null)continue;
      s.show(x,y,0.9*3/4);
    }
  }
  void show(float x,float y,float r){
    fill(200,220);
    noStroke();
    
    
    circle(x,y,r/2*game.scl);
    for(Shape s:shapes){  
      if(s==null)continue;
      s.show(x,y,r*3/4);
    }
  }
  
  void show(float x,float y,float r,PGraphics p){
    p.fill(200,220);
    p.noStroke();
    
    
    p.circle(x,y,r/2);
    for(Shape s:shapes){  
      if(s==null)continue;
      s.show(x,y,r*3/4,p);
    }
  }
}



abstract class Shape{
  Shape(){
  
  }
  abstract void show(float x,float y,float r);
  abstract void show(float x,float y,float r,PGraphics p);
  abstract Shape clone();
}
class CircleShape extends Shape{
  int quarter;
  CircleShape(int q){
    quarter=q;
  }
  
  
  @Override
  Shape clone(){
    return new CircleShape(quarter);
  }
  @Override
  void show(float x,float y,float r){
    fill(130,200);
    stroke(50,255);
    strokeWeight(game.scl/48);
    switch(quarter){
      case 0:        
        arc(x,y,game.scl*r/2,game.scl*r/2,0,PI/2,PIE);
        break;
      case 1:        
        arc(x,y,game.scl*r/2,game.scl*r/2,PI/2,PI,PIE);
        break;
      case 2:        
        arc(x,y,game.scl*r/2,game.scl*r/2,PI,PI*3/2,PIE);
        break;
      case 3:        
        arc(x,y,game.scl*r/2,game.scl*r/2,PI*3/2,PI*2,PIE);
        break;
    
    }
    
  }
  
  void show(float x,float y,float r,PGraphics p){
    p.fill(130,200);
    p.stroke(110,200);
    p.strokeWeight(5);
    switch(quarter){
      case 0:        
        p.arc(x,y,r/2,r/2,0,PI/2,PIE);
        break;
      case 1:        
        p.arc(x,y,r/2,r/2,PI/2,PI,PIE);
        break;
      case 2:        
        p.arc(x,y,r/2,r/2,PI,PI*3/2,PIE);
        break;
      case 3:        
        p.arc(x,y,r/2,r/2,PI*3/2,PI*2,PIE);
        break;
    
    }
    
  }



}
class RectangleShape extends Shape{
  int quarter;
  RectangleShape(int q){
    quarter=q;
  }
   @Override
  Shape clone(){
    return new RectangleShape(quarter);
  }
  
  @Override
  void show(float x,float y,float r){
    fill(130,200);
    stroke(50,255);
    strokeWeight(game.scl/48);
    rectMode(CORNER);
    switch(quarter){
      case 0:
        rect(x,y,game.scl*r/4,game.scl*r/4);
        break;
      case 1:
        rect(x-game.scl*r/4,y,game.scl*r/4,game.scl*r/4);
        break;
      case 2:
        rect(x-game.scl*r/4,y-game.scl*r/4,game.scl*r/4,game.scl*r/4);
        break;
      case 3:
        rect(x,y-game.scl*r/4,game.scl*r/4,game.scl*r/4);
        break;
    
    }
  }
  void show(float x,float y,float r,PGraphics p){
    p.fill(130,200);
    p.stroke(110,200);
    p.strokeWeight(5);
    p.rectMode(CORNER);
    switch(quarter){
      case 0:
        p.rect(x,y,r/4,r/4);
        break;
      case 1:
        p.rect(x-r/4,y,r/4,r/4);
        break;
      case 2:
        p.rect(x-r/4,y-r/4,r/4,r/4);
        break;
      case 3:
        p.rect(x,y-r/4,r/4,r/4);
        break;
    
    }
  }
}
