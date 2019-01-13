/*              R    G    B
 [0] red       239  51   64
 [1] yellow    243  207  85
 [2] orange    255  108  47
 [3] green     136  176  75
 [4] blue      87   140  169
 [5] purple    173  94   153
 [6] grey      129  131  135
 */

class User {
  public int user_id;
  public int [] coloursStatistics;
  color lastColor; 

  User(int id) {
    user_id=id;
    coloursStatistics=new int [7];
    for (int j=0; j<7; j++)
      coloursStatistics[j]=0;
  }
  int[] getColoursStatistics() {
    return coloursStatistics;
  }
  void setColoursStatistics(int index) {
    coloursStatistics[index]= coloursStatistics[index]+1;
  }

  color getLastUserColor() {
    return lastColor;
  }

  void setLastUserColor(color _color)
  {
    lastColor=_color;
  }
}
