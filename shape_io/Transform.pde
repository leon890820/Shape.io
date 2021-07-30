class Transform{
  Vector2 position;
  Vector2 oriented;
  float angle;
  Vector2 scale;
  Transform(){
    position=new Vector2();
    angle=0;
    oriented=new Vector2(cos(angle),sin(angle));
    scale=new Vector2(1,1);
  }
  void setPosition(Vector2 p){
    position.x=p.x;
    position.y=p.y;
  }
  void setOriented(float a){
    angle=a;
    oriented=new Vector2(cos(angle),sin(angle));    
  }
  void setScale(Vector2 s){
    scale.x=s.x;
    scale.y=s.y;
  }
  
  Vector2 getPosition(){
    return position.copy();
  }
  Vector2 getOriented(){
    return oriented.copy();
  }
  Vector2 getScale(){
    return scale.copy();
  }
  

}
