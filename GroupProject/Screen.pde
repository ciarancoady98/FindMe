//Screen Class (current version 1.1, Jamie Coffey)
//Imported from week 6
//Contains functions to create screens

class Screen{
  //note: scroll bar refers to the actual bar, scroll widget refers to the 
  //widgets the scroll bar can manipulate(allows for screen to have stationary
  //widgets aswell)
  TextWidget focus;
  ArrayList<Widget> widgets = new ArrayList<Widget>();
  ArrayList<CheckBox> checkBoxes = new ArrayList<CheckBox>();
  ArrayList<Radio> radios = new ArrayList<Radio>();
  ArrayList<TextWidget> textBoxes = new ArrayList<TextWidget>();
  ArrayList<ScrollBar> scrollBars = new ArrayList<ScrollBar>();
  ArrayList<ScrollWidget> scrollWidgets = new ArrayList<ScrollWidget>();
  ArrayList<UserWidget> userWidgets = new ArrayList<UserWidget>();
  ArrayList<BusinessWidget> businessWidgets = new ArrayList<BusinessWidget>();
  float pos;
  
  Screen(){
  }
  
  void draw(){
    background(255);
    
    for(int i = 0; i < textBoxes.size(); i++){
      TextWidget aWidget = (TextWidget)textBoxes.get(i);
      fill(BACKGROUND_COLOR);
      rect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
      fill(255);
      if(aWidget.getEvent(mouseX,mouseY) > 0)
        stroke(255);
      else
        stroke(0);
      aWidget.draw();
    }
    for(int i = 0; i < checkBoxes.size(); i++){
      CheckBox aWidget = (CheckBox)checkBoxes.get(i);
      if(aWidget.getEvent(mouseX,mouseY) > 0)
        stroke(255);
      else
        stroke(0);
      aWidget.draw();
    }
    for(int i = 0; i < radios.size(); i++){
      Radio aWidget = (Radio)radios.get(i);
      if(aWidget.getEvent(mouseX,mouseY) > 0)
        stroke(255);
      else
        stroke(0);
      aWidget.draw();
    }
    for(int i = 0; i < scrollBars.size(); i++){
      ScrollBar aScrollBar = (ScrollBar)scrollBars.get(i);
      //if(aScrollBar.getEvent(mouseX,mouseY) > 0)
      //  stroke(255);
      //else
        stroke(0);
      aScrollBar.update();
      aScrollBar.display();
      pos = aScrollBar.getPos();
    }
    for(int i = 0; i < scrollWidgets.size(); i++){
      ScrollWidget aWidget = (ScrollWidget)scrollWidgets.get(i);
      if((aWidget.getEvent(mouseX,mouseY) > 0) && mouseY > aWidget.getStart())
        aWidget.over(true);
      else
        aWidget.over(false);
        stroke(0);
      aWidget.draw();
      fill(255);
      stroke(255);
      rect(0,0,SCREEN_WIDTH,70,5);
    }
    for(int i = 0; i < widgets.size(); i++){
      Widget aWidget = (Widget)widgets.get(i);
      if(aWidget.getEvent(mouseX,mouseY) > 0)
        stroke(255);
      else
        stroke(0);
      aWidget.draw();
      stroke(0);
    }
    for(int i = 0; i < userWidgets.size(); i++){
      UserWidget aWidget = (UserWidget)userWidgets.get(i);
      aWidget.draw();
      stroke(0);
    }
    for(int i = 0; i < businessWidgets.size(); i++){
      BusinessWidget aWidget = (BusinessWidget)businessWidgets.get(i);
      aWidget.draw();
      stroke(0);
    }
    
  }
  
  void addWidget(int x,int y, int width, int height, String label,
                color widgetColor, PFont widgetFont, int event){
    Widget newWidget = new Widget(x, y, width, height,label,widgetColor,widgetFont, event);
    widgets.add(newWidget);
  }
  
  void addScrollWidget(int x,int y, int width, int height, String label, String address,
                color widgetColor, PFont widgetFont, int event,int start, Business business){
    ScrollWidget newScrollWidget = new ScrollWidget(x, y, width, height,label, address, widgetColor,widgetFont, event, start, business);
    scrollWidgets.add(newScrollWidget);
  }

  //added text box & functionality
  //michael black
  void addTextBox(int x,int y, int width, int height, String label, color widgetColor, 
                  PFont font, int event,int maxlen){
    TextWidget newTextBox = new TextWidget(x, y, width, height,label,widgetColor, font,
    event, maxlen);
    textBoxes.add(newTextBox);
  }
  
  void addScrollBar(int x, int y, int width, int height, int loose){
    ScrollBar newScrollBar = new ScrollBar(x, y, width, height, loose);
    scrollBars.add(newScrollBar);
  }
  
  //Ciaran Coady, adds widgets with Images to the widget arrayList
  void addImageWidget(int x, int y, PImage image, int event){
    ImageWidget newImageWidget = new ImageWidget(x, y, image, event);
    widgets.add(newImageWidget);
  }
  
  void removeScrollWidgets(){
    for(int i = scrollWidgets.size()-1; i >= 0; i--){
      ScrollWidget aWidget = (ScrollWidget)scrollWidgets.get(i);
      scrollWidgets.remove(aWidget);
    }
  }
  void removeWidgets(){
    int size = widgets.size();
    for(int i = size-1; i >= size-2 && size != 0; i--){
      Widget aWidget = (Widget)widgets.get(i);
      widgets.remove(aWidget);
    }
  }
  
  //returns position of the scroll bar
  float getPos(){
    return pos;
  }

  int getEvent(){
    for(int count = 0; count < widgets.size(); count++)
    {
      if(widgets.get(count).getEvent(mouseX, mouseY) > 0)
        return widgets.get(count).event;
    }
  
    for(int count = 0; count < scrollWidgets.size(); count++)
    {
      if(scrollWidgets.get(count).getEvent(mouseX, mouseY) > 0)
        return scrollWidgets.get(count).event;
    }
    for(int count = 0; count < userWidgets.size(); count++)
    {
      if(userWidgets.get(count).getEvent(mouseX, mouseY) > 0)
        return userWidgets.get(count).event;
    }
    for(int count = 0; count < businessWidgets.size(); count++)
    {
      if(businessWidgets.get(count).getEvent(mouseX, mouseY) > 0)
        return businessWidgets.get(count).event;
    }
    return EVENT_NULL;
  }
  
  
  ArrayList getWidgets(){
    return widgets;
  }
  
  void text(){
    int event;
    for(int i = 0; i < textBoxes.size(); i++){
      TextWidget theTextWidget = (TextWidget)textBoxes.get(i);
      event = theTextWidget.getEvent(mouseX,mouseY);
      if(event == EVENT_TEXT) {
        focus= theTextWidget;
        break;
      }
      else {
        focus=null;
      }
    }
  }
  
  void key()
  {
    if(focus != null) {
    focus.append(key);
    }
  }
  
  void resetSearchResults(){
    scrollWidgets = new ArrayList<ScrollWidget>();
  }
}