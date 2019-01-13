class bouncyWord {
  String word;
  float px, py, vx, vy;
  
  bouncyWord(String title, float ipx) {
    word = title;
    px = ipx;
    vx = 0;
    py = height/2;
    vy = random(1,2);    
  }
  
  void draw() {
    px += vx;
    py += vy;
    if (py < height/2-height/6) {
      py = height/2-height/6;
      vy = -vy;
    } else if (py > height/2-height/12) {
      py = height/2-height/12;
      vy = -vy;      
    }
    
    text(word, px, py);
  }
}
