//Widget Class (current version 1.1, Jamie Coffey)
//Imported from week 6
//Contains functions to create widgets
//Can create standard, radio and checkbox widgets

class Widget {

  int x, y, width, height;
  String label; 
  int event;
  color widgetColor, widgetOverColor, labelColor;
  PFont widgetFont;
  float scroll;
  Business business;
  int start;
  boolean over = false;
  String address;

  Widget() {
  }

  Widget(int x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event) {
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor;
    this.widgetFont=widgetFont;
    labelColor= color(0);
    //System.out.print(widgetFont);
  }

  void draw() {
    fill(widgetColor);
    rect(x, y, width, height, 5);
    fill(labelColor);
    textFont(widgetFont);
    text(label, x+10, y+height-10);
  }

  int getEvent(int mX, int mY) {
    if (mX>x && mX < x+width && mY >y && mY <y+height)
      return event;
    return EVENT_NULL;
  }
}

class CheckBox extends Widget {

  CheckBox(int x, int y, int width, int height, String label, 
    color widgetColor, PFont widgetFont, int event) {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
  }

  void draw() {
    fill(widgetColor);
    rect(x, y, width, height);
    fill(labelColor);
    text(label, x + width + 10, y + height - 3);
  }
}

class Radio extends Widget {

  Radio(int x, int y, int width, int height, String label, 
    color widgetColor, PFont widgetFont, int event) {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
  }

  void draw() {
    fill(widgetColor);
    ellipse(x, y, width, height);
    fill(labelColor);
    text(label, x + width + 10, y + height/2);
  }

  int getEvent(int mX, int mY) {
    if (mX > x - 15 && mX < x + 15 && mY > y - 15 && mY < y + 15) {
      return event;
    }
    return EVENT_NULL;
  }
}
//Michael Black
class TextWidget extends Widget 
{

  int maxlen;
  TextWidget(int x, int y, int width, int height, 
    String label, color widgetColor, PFont font, int event, 
    int maxlen)
  {
    super(x, y, width, height, label, widgetColor, font, event);
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.label=label; 
    this.event=event;
    this.widgetColor=widgetColor; 
    this.widgetFont=font;
    labelColor=color(0); 
    this.maxlen=maxlen;
  }

  void append(char s)
  {
    if (label.equals("Enter business/location....")) {
      label=("");
    }
    if (s==BACKSPACE)
    {
      if (!label.equals(""))
        label=label.substring(0, label.length()-1);
    } else if (label.length() <maxlen)
      label=label+str(s);
  }

  public String getLabel() {
    return label;
  }
}
//Michael
//Standerd widgets with the ability to move & be functional in
//relation to the scroll bar. Differs only from standerd widgets by 
//adding the scrolled movement to the x and y values
class ScrollWidget extends Widget 
{
  ScrollWidget(int x, int y, int width, int height, String label, String address, color widgetColor, PFont widgetFont, int event, int start, Business business) {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    this.x=x; 
    this.y=y; 
    this.width = width; 
    this.height= height;
    this.label=label; 
    this.event=event; 
    this.widgetColor=widgetColor;
    this.widgetFont=widgetFont;
    this.business = business;
    this.address = address;
    labelColor= color(0);
    labelColor= color(0);
    labelColor= color(255);
    widgetOverColor = color(100);
  }

  void draw() {
    if (this.business != null)
    {
      scroll = screen1.getPos();
      if (over) fill(widgetOverColor);
      else fill (widgetColor);
      rect(x, -scroll+y, width, height, 10);
      fill(labelColor);
      text(label, x+10, -scroll+y+30);
      if (address != null) text(address, x+10, -scroll+y+60);

      switch((int) this.business.getStars()) {
      case 5:
        image(star, x + 1560, y - scroll);
      case 4:
        image(star, x + 1520, y - scroll);
      case 3:
        image(star, x + 1480, y - scroll);
      case 2:
        image(star, x + 1440, y - scroll);
      default:
        image(star, x + 1400, y - scroll);
      }
    }
    else
    {
      fill(100);
      text(label, x+10, -scroll+y+30);
    }
  }

  int getEvent(int mX, int mY) {
    if (mX>x && mX < x+width && mY >-scroll+y && mY <-scroll+y+height && mouseY > start)
      return event;
    return EVENT_NULL;
  }

  int getStart() {
    return start;
  }

  int getY() {
    return (int)-scroll+y;
  }

  void over(boolean bool) {
    if (bool) over = true;
    else over = false;
  }
}

// Jamie Coffey (V1.0)
class UserWidget extends Widget {

  User user;

  UserWidget(int x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event, User user) {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    this.user = user;
  }

  User getUser() {
    return this.user;
  }
}

// Jamie Coffey (V1.0)
class BusinessWidget extends Widget {

  Business thisBusiness;

  BusinessWidget(int x, int y, int width, int height, String label, color widgetColor, PFont widgetFont, int event, Business business) {
    super(x, y, width, height, label, widgetColor, widgetFont, event);
    thisBusiness = business;
  }

  Business getBusiness() {
    return thisBusiness;
  }
}

//Ciaran Coady
class ImageWidget extends Widget {
  PImage image;

  ImageWidget(int x, int y, PImage image, int event) {
    super();
    this.x = x;
    this.y = y;
    this.image = image;
    this.event = event;
  }


  void draw() {
    image(image, x, y);
  }
}