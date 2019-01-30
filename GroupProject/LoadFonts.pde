//Ciaran Coady
//loads all the fonts at the start of the program which optimises speed
//then saves these fonts to public variables in the constants page to allow for
//easy access across all classes

class LoadFonts{
  
  PFont stdFont, gothicFont, titleFont;
  
  LoadFonts(){
    gothicFont=loadFont("CenturyGothic-Italic-30.vlw");
    stdFont = loadFont("ArialMT-12.vlw");
    titleFont = loadFont("Arial-BoldMT-48.vlw");
    STDFONT = stdFont;
    GOTHICFONT = gothicFont;
    TITLEFONT = titleFont;
    //println("fonts loaded");
  }
  
  public PFont getStdFont(){
    return stdFont;
  }
  
  public PFont getGothicFont(){
    return gothicFont;
  }
}