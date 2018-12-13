/*               R    G    B
   [0] vermelho  255  1    1
   [1] amarelo   255  225  30
   [2] laranja   255  175  15
   [3] verde     0    204  0
   [4] azul      51   204  204
   [5] roxo      190  116  202
   [6] cinzento  160  160  160
  */

class User{
  public int user_id;
  public int [] coloursStatistics;
  
  User(int id){
    user_id=id;
    coloursStatistics=new int [7];
    for (int j=0; j<7; j++)
      coloursStatistics[j]=0;
  }
  int[] getColoursStatistics(){
    return coloursStatistics;
  }
  void setColoursStatistics(int index){
    coloursStatistics[index]= coloursStatistics[index]+1; 
  }
}
