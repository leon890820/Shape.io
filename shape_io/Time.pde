class Time{
  float time;
  float deltaTime;
  boolean fix;
  Time(){
    time=0;
    deltaTime=1/frameRate;
  }
  
  void run(){
    if(fix)deltaTime=1/frameRate;
    time+=deltaTime;
  }
  void reset(){
    time=0;
  }



}
