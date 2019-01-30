//User Class (current version 1.2, Jamie Coffey)
//Stores all the relevant data for a user
//Contains getters and setters to access data
//ToString method prints the review to the console
//getNumberOfReviews returns the number of reviews made by this user
//getReviewRatings returns an array with the number of useful, funny and cool responses

class User {

  private String userId, userName;
  private int review_count, useful, funny, cool;
  private ArrayList<Review> userReviews;
  Query query;
  PFont title, categoryTitle;
  public int currentReview;

  User(String userId, String userName, int review_count, int useful, int funny, int cool) {
    this.userId = userId;
    this.userName = userName;
    this.review_count = review_count;
    this.useful = useful;
    this.funny = funny;
    this.cool = cool;
    query = new Query();
    userReviews = query.getUserReviews(userId);
    this.title = GOTHICFONT;
    categoryTitle = STDFONT;
    this.currentReview = 0;
  }
  
  // getters and setters
  public String getUserId() {
    return this.userId;
  }
  public void setUserId(String userId) {
    this.userId = userId;
  }
  public String getUserName() {
    return this.userName;
  }
  public int getUserReviewCount() {
    return this.review_count;
  }
  public int getUseful() {
    return this.useful;
  }
  public int getFunny() {
    return this.funny;
  }
  public int getCool() {
    return this.cool;
  }
  public void setUserName(String userName) {
    this.userName = userName;
  }
  public int getNumberOfReviews() {
    return this.userReviews.size();
  }

  public int[] getReviewRatings() {
    int[] ratings = new int[3];
    for (int count = 0; count < this.userReviews.size(); count++) {
      ratings[0] += this.userReviews.get(count).getUseful();
      ratings[1] += this.userReviews.get(count).getFunny();
      ratings[2] += this.userReviews.get(count).getCool();
    }
    return ratings;
  }

  String toString() {
    return "user+id: " + userId + "\nuser_name: " + userName;
  }

  // Jamie Coffey (V1.0)
  public void nextReview() {
    if (currentReview < userReviews.size() - 1)
      currentReview++;
    else
      currentReview = 0;
  }

  // Jamie Coffey (V1.0)
  public void lastReview() {
    if (currentReview > 0)
      currentReview--;
    else
      currentReview = userReviews.size() - 1;
  }

  //Author: Jamie Coffey (V1.1)
  void drawReviews(int x, int y) {
    for (int counter = 0; counter < userReviews.size(); counter++)
    {
      fill(255);
      textFont(stdFont);

      text(query.getBusinessNameById(userReviews.get(counter).getBusinessId()), x, y);

      char[] reviewChars = userReviews.get(counter).text.toCharArray();
      int count = 0;
      boolean finished;
      String reviewString;
      String reviewString2;
      String reviewString3;

      while (reviewChars.length - count > 100)
      {
        count += 100;
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
      text(reviewString, x, y + 32);

      switch((int)userReviews.get(counter).getStars()) {
      case 5:
        image(star, x + 440, y - 20);
      case 4:
        image(star, x + 480, y - 20);
      case 3:
        image(star, x + 520, y - 20);
      case 2:
        image(star, x + 560, y - 20);
      default:
        image(star, x + 600, y - 20);
      }
      image(usefulImage, x + 600, y + 32);
      image(funnyImage, x + 600, y + 64);
      image(coolImage, x + 600, y + 96);
      text(userReviews.get(counter).getUseful(), x + 640, y + 32);
      text(userReviews.get(counter).getFunny(), x + 640, y + 64);
      text(userReviews.get(counter).getCool(), x + 640, y + 96);
      y = y + 64 + (reviewChars.length / 100);
    }
  }

  public void drawReview(int count) {
    userReviews.get(count).draw(100, 400);
  }
  public void draw() {
    textFont(gothicFont);
    text("User Name: " + this.userName, 25, 175);
    text("UserID: " + this.userId, 25, 225);
    text("Total number of reviews: " + this.getNumberOfReviews(), 25, 275);
    drawReview(currentReview);
  }
  // Matthew Flynn v1.0 (Updated to V2.0 by Jamie Coffey)
  // Returns whether the first inputed review is more recient or not. 
  public boolean checkIfDateOfFirstIsOlder(Review testReview, Review compareReview)
  {
    boolean swapDates = false;
    String[] currentYear = testReview.getDate().split("-");
    int currentYearValue = Integer.parseInt(currentYear[0]);
    String[] compareYear = compareReview.getDate().split("-");
    int compareYearValue = Integer.parseInt(compareYear[0]);
    if (currentYearValue < compareYearValue)
    {
      swapDates = true;
    } else if(currentYearValue == compareYearValue)
    {
      int currentMonthValue = Integer.parseInt(currentYear[1]);
      int compareMonthValue = Integer.parseInt(compareYear[1]);
      if (currentMonthValue < compareMonthValue)
      {
        swapDates = true;
      } 
      else if(currentMonthValue == compareMonthValue)
      {
        int currentDayValue = Integer.parseInt(currentYear[2]);
        int compareDayValue = Integer.parseInt(currentYear[2]);
        if (currentDayValue < compareDayValue)
        {
          swapDates = true;
        }
      }
    }
    return swapDates;
  }

  // Matthew Flynn v1.0
  // Sorts from the oldest review to the newest review.
  public void sortByOldest()
  {
    Review testReview;
    Review compareReview;
    System.out.println(userReviews.size());
    for (int i = 0; i < userReviews.size(); i++)
    {
      int counter = 0;
        while (counter < userReviews.size())
        {
          testReview = userReviews.get(i);
          compareReview = userReviews.get(counter);
          boolean swapDates = checkIfDateOfFirstIsOlder(testReview, compareReview);
          if (swapDates)
          {
            Review tmpReview = userReviews.get(i);
            userReviews.set(i, userReviews.get(counter));
            userReviews.set(counter, tmpReview);
          }
          counter++;
        }
      }
      currentReview = 0; 
    }
     

  // Matthew Flynn v1.1
  // Sorts from the latest review first to the oldest review.
  public void sortByNewest()
  {
    Review testReview;
    Review compareReview;
    for (int i = 0; i < userReviews.size(); i++)
    {
      int counter = 0;
      while (counter < userReviews.size())
      {
        testReview = userReviews.get(i);
        compareReview = userReviews.get(counter);
        boolean swapDates = checkIfDateOfFirstIsOlder(testReview, compareReview);
        if (!swapDates)
        {
          Review tmpReview = userReviews.get(i);
          userReviews.set(i, userReviews.get(counter));
          userReviews.set(counter, tmpReview);
        }
        counter++;
      }
    }
    currentReview = 0;
  }

  public void sortByFunniest()
  {
    this.currentReview = 0;
    System.out.print(userReviews.size());
    for (int i = 0; i < this.userReviews.size(); i++)
    {
      int tmp = 0;
      while (tmp < this.userReviews.size())
      {
        if (this.userReviews.get(i).getFunny() > this.userReviews.get(tmp).getFunny())
        {
          Review tmpReview = this.userReviews.get(i);
          this.userReviews.set(i, this.userReviews.get(tmp));
          this.userReviews.set(tmp, tmpReview);
        }
        tmp++;
      }
    }
  }

  public void sortByMostUseful()
  {
    this.currentReview = 0;
    for (int i = 0; i < userReviews.size(); i++)
    {
      int tmp = 0;
      while (tmp < userReviews.size())
      {
        if (userReviews.get(i).getUseful() > userReviews.get(tmp).getUseful())
        {
          Review tmpReview = userReviews.get(i);
          userReviews.set(i, userReviews.get(tmp));
          userReviews.set(tmp, tmpReview);
        }
        tmp++;
      }
    }
  }

  public void sortByCoolest()
  {
    this.currentReview = 0;
    for (int i = 0; i < userReviews.size(); i++)
    {
      int tmp = 0;
      while (tmp < userReviews.size())
      {
        if (userReviews.get(i).getCool() > userReviews.get(tmp).getCool())
        {
          Review tmpReview = userReviews.get(i);
          userReviews.set(i, userReviews.get(tmp));
          userReviews.set(tmp, tmpReview);
        }
        tmp++;
      }
    }
  }
}