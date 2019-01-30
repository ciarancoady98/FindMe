//Review Class (current version 1.2, Ciaran Coady)
//Stores all the relevant data for a review
//Contains getters and setters to access data
//ToString method prints the review to the console

class Review {
  private String reviewId, userId, businessId, date, text;
  private double stars;
  private int useful, funny, cool;
  Query query;
  BusinessWidget businessButton;
  UserWidget userButton;
  
  Review(String reviewId, String userId, String businessId, double stars, String date, String text, 
    int useful, int funny, int cool) {
    query = new Query();
    this.reviewId = reviewId;
    this.userId = userId;
    this.businessId = businessId;
    this.stars = stars;
    this.date = date;
    this.text = text;
    this.useful = useful;
    this.funny = funny;
    this.cool = cool;
    this.businessButton = null;
    this.userButton = null;
  }

  //getters
  public String getReviewId() {
    return reviewId;
  }
  public String getUserId() {
    return userId;
  }
  public String getBusinessId() {
    return businessId;
  }
  public double getStars() {
    return stars;
  }
  public String getDate() {
    return date;
  }
  public String getText() {
    return text;
  }
  public int getUseful() {
    return useful;
  }
  public int getFunny() {
    return funny;
  }
  public int getCool() {
    return cool;
  }

  //setters
  public void setReviewId(String reviewId) {
    this.reviewId = reviewId;
  }
  public void setUserId(String userId) {
    this.userId = userId;
  }
  public void setBusinessId(String businessId) {
    this.businessId = businessId;
  }
  public void setStars(double stars) {
    this.stars = stars;
  }
  public void setDate(String date) {
    this.date = date;
  }
  public void setText(String text) {
    this.text = text;
  }
  public void setUseful(int useful) {
    this.useful = useful;
  }
  public void setFunny(int funny) {
    this.funny = funny;
  }
  public void setCool(int cool) {
    this.cool = cool;
  }

  @Override
    public String toString() {
    return "cheating [reviewId=" + reviewId + ", userId=" + userId + ", businessId=" + businessId + ", stars="
      + stars + ", date=" + date + ", text=" + text + ", useful=" + useful + ", funny=" + funny + ", cool="
      + cool + "]";
  }
  
// Jamie Coffey (V1.2)
  void draw(int x, int y) {
    fill(255);
    textFont(stdFont);
    Business businessLink = query.getBusinessById(this.businessId);
    String businessName = businessLink.getBusinessName();
    businessButton = new BusinessWidget(x, y, 200, 32, businessName, 200, stdFont, EVENT_GOTO_BUSINESS, businessLink);
    businessButton.draw();
    
    //println(query.getUserName(this.userId));
    User userLink = query.getUserById(this.userId);
    String userName = userLink.getUserName();
    userButton = new UserWidget(x, y + 32, 200, 32, userName, 200, stdFont , EVENT_GOTO_USER, userLink);
    userButton.draw();
    
    text("Date Published: " + this.date, x + 250, y + 48);
    char[] reviewChars = this.text.toCharArray();
    int count = 0;
    boolean finished;
    String reviewString;
    String reviewString2;
    String reviewString3;

    while (reviewChars.length - count > 90)
    {
      count += 90;
      finished = false;
      while (!finished)
      {
        if (reviewChars[count] == ' ')
        {
          finished = true;
          reviewString = new String(reviewChars);
          reviewString2 = reviewString.substring(0, count + 1);
          reviewString3 = reviewString.substring(count + 1, reviewString.length());
          reviewString2 += "\n";
          reviewString = reviewString2 + reviewString3;
          reviewChars = reviewString.toCharArray();
        } else
          count--;
      }
    }

    reviewString = new String(reviewChars);
    text(reviewString, x, y + 96);

    switch((int)getStars()) {
    case 5:
      image(star, x + 340, y - 10);
    case 4:
      image(star, x + 380, y - 10);
    case 3:
      image(star, x + 420, y - 10);
    case 2:
      image(star, x + 460, y - 10);
    default:
      image(star, x + 500, y - 10);
    }
    image(usefulImage, x + 550, y + 32);
    image(funnyImage, x + 550, y + 64);
    image(coolImage, x + 550, y + 96);
    text(this.useful, x + 590, y + 52);
    text(this.funny, x + 590, y + 84);
    text(this.cool, x + 590, y + 116);
  }
  
  // Jamie Coffey (V1.0)
  int getEvent(int mX, int mY){
    if(userButton.getEvent(mX, mY) != 0)
      return userButton.getEvent(mX, mY);
    else if(businessButton.getEvent(mX, mY) != 0)
      return businessButton.getEvent(mX, mY);
    else
      return 0;
  }
}