class Timer {

  int savedTime; // When Timer started
  int totalTime; // How long Timer should last

  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }

  void setTime(int t) {
    totalTime = t;
  }

  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis();
  }

  int getSavedTime(){
    return savedTime;
  }
  // The function isFinished() returns true if X ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    if (savedTime!=0){
      int passedTime = millis()- savedTime;
      if (passedTime > totalTime) {
        return true;
      } else {
        return false;
      }
     }else{
      return false;}
    }
  }
