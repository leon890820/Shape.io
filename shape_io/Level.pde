class LevelManager{
  LevelManager(){
  
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
