class Timer {

  // Timer
  int lastTime;
  int timerLength;

  // Contructor
  Timer() {
  }

  void startTimer(int _timerLength) {
    lastTime = millis();
    timerLength = _timerLength;
  }

  boolean isTimerEnded() {
    if (millis() - lastTime >= timerLength) {
      return true;
    } else {
      return false;
    }
  }
}