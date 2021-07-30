class Camera{
  Transform transform;
  Panel panel;
  Camera(){
    transform=new Transform();
    //transform.setPosition(new Vector2(width/2,height/2));
    panel=new Panel(width,height);
    loadPixels();
    for(int i=0;i<panel.panel.height;i+=1){
      for(int j=0;j<panel.panel.width;j+=1){
        int index=i*panel.panel.width+j;
        float distanceToOringin=pow(j-width/2,2)+pow(i-height/2,2);
        float maxDistanceToOringin=pow(width/2,2)+pow(height/2,2);
        float alpha=map(distanceToOringin,0,maxDistanceToOringin,0,255);
        panel.panel.pixels[index]=color(240,alpha);
      }
    }
    updatePixels();
  }
  void camSpotLight(){
    panel.show(0,0);
    
  }
  void effect(){
  
  
  
  }
  
  boolean notInCam(Vector2 p){
    Vector2 position=transform.getPosition();
    if(p.x<position.x+width/2 && p.x>position.x-width/2 && p.y<position.y+height/2 && p.y>position.y-height/2)return true;
    else return false;
  }
  boolean isInCamX(float x){
   Vector2 position=transform.getPosition();
   if(x<position.x+width/2 && x>position.x-width/2) return true;
   else return false;
  }
   boolean isInCamY(float y){
   Vector2 position=transform.getPosition();
   if(y<position.y+height/2 && y>position.x-height/2) return true;
   else return false;
  }


}
