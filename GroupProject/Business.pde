//Matthew
//Updated Ciaran Coady
class Business {
  ArrayList<Review> businessReview;
  PFont title, categoryTitle, addressFont;
  Query query;
  private String businessId, businessName, neighborhood, address, city, state, postalCode, categories;
  private double latitude, longitude, stars;
  int reviewCount, isOpen, currentReview;

  // Matthew Flynn v1.0 business constructor.
  // Removed font loading from constructor for major speed improvements (Ciaran Coady)
  public Business(String businessId, String businessName, String neighborhood, String address, String city, 
    String state, String postalCode, double latitude, double longitude, double stars, int reviewCount, 
    int isOpen, String categories) {
    query = new Query();
    this.businessId = businessId;
    this.businessName = removeQuotationMarks(businessName);
    this.neighborhood = neighborhood;
    this.address = removeQuotationMarks(address);
    this.city = city;
    this.state = state;
    this.postalCode = postalCode;
    this.latitude = latitude;
    this.longitude = longitude;
    this.stars = stars;
    this.reviewCount = reviewCount;
    this.isOpen = isOpen;
    this.categories = categories;
    this.currentReview = 0;
    this.title = TITLEFONT;
    this.categoryTitle = STDFONT;
    this.addressFont = GOTHICFONT;
  }
  //moved to business as it means that quotation marks are removed for all business operations
  //(Ciaran coady), original author Michael Black
  String removeQuotationMarks(String string) {
    String[] splitString = string.split("\"");
    if (splitString.length != 0) {
      String result = splitString[1];
      return result;
    } else return null;
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
    System.out.println(businessReview.size());
    for (int i = 0; i < businessReview.size(); i++)
    {
      int counter = 0;
        while (counter < businessReview.size())
        {
          testReview = businessReview.get(i);
          compareReview = businessReview.get(counter);
          boolean swapDates = checkIfDateOfFirstIsOlder(testReview, compareReview);
          if (swapDates)
          {
            Review tmpReview = businessReview.get(i);
            businessReview.set(i, businessReview.get(counter));
            businessReview.set(counter, tmpReview);
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
    for (int i = 0; i < businessReview.size(); i++)
    {
      int counter = 0;
      while (counter < businessReview.size())
      {
        testReview = businessReview.get(i);
        compareReview = businessReview.get(counter);
        boolean swapDates = checkIfDateOfFirstIsOlder(testReview, compareReview);
        if (!swapDates)
        {
          Review tmpReview = businessReview.get(i);
          businessReview.set(i, businessReview.get(counter));
          businessReview.set(counter, tmpReview);
        }
        counter++;
      }
    }
    currentReview = 0;
  }

  // Matthew Flynn v1.0
  // sorts from highest to lowest.
  public void sortByHighestRating()
  {
    for (int i = 0; i < businessReview.size(); i++)
    {
      int tmp = 0;
      while (tmp < businessReview.size())
      {
        if (businessReview.get(i).getStars() > businessReview.get(tmp).getStars())
        {
          Review tmpReview = businessReview.get(i);
          businessReview.set(i, businessReview.get(tmp));
          businessReview.set(tmp, tmpReview);
        }
        tmp++;
      }
    }
    currentReview = 0;
  }

  // Matthew Flynn v1.0 
  // Sorts the reviews. starting with the lowest rating and going higher.
  public void sortByLowestRating()
  {
    for (int i = 0; i < businessReview.size(); i++)
    {
      int tmp = 0;
      while (tmp < businessReview.size())
      {
        if (businessReview.get(i).getStars() < businessReview.get(tmp).getStars())
        {
          Review tmpReview = businessReview.get(i);
          businessReview.set(i, businessReview.get(tmp));
          businessReview.set(tmp, tmpReview);
        }
        tmp++;
      }
    }
    currentReview = 0;
  }

  // Matthew Flynn v1.0 
  // Calculates the average star rating of the business.
  public double getAverageStar()
  {
    double currentTotal = 0;
    double tmp = 0;
    for (int i = 0; i < businessReview.size(); i++)
    {
      tmp = businessReview.get(i).getStars();
      currentTotal = tmp + currentTotal;
    }
    double average = currentTotal/ (businessReview.size()-1);
    return average;
  }

  // Jamie Coffey (V1.0)
  public void drawBarChart(int x, int y) {
    int[] reviewStars = designateStars();
    x= x + 500;
    y = y +300;
    fill(255);
    line(x + 20, y, x + 20, y + 150);
    line(x + 20, y + 150, x + 170, y + 150);
    fill(100);
    line(x + 20, y + 30, x + 170, y + 30);
    line(x + 20, y + 60, x + 170, y + 60);
    line(x + 20, y + 90, x + 170, y + 90);
    line(x + 20, y + 120, x + 170, y + 120);
    int highestStarValue = 0;
    for (int count = 0; count < 5; count++)
      if (reviewStars[count] > highestStarValue)
        highestStarValue = reviewStars[count];
    int highestRow = highestStarValue / 10;
    highestRow *= 10;
    highestRow += 10;
    textFont(stdFont);
    text(highestRow, x, y);
    text(highestRow * 4 / 5, x, y + 30);
    text(highestRow * 3 / 5, x, y + 60);
    text(highestRow * 2 / 5, x, y + 90);
    text(highestRow / 5, x, y + 120);
    text("0", x, y + 150);

    text("1", x + 35, y + 165);
    text("2", x + 65, y + 165);
    text("3", x + 95, y + 165);
    text("4", x + 125, y + 165);
    text("5", x + 155, y + 165);

    fill(255, 0, 0);
    rect(x + 21, y + 150 - (150 * ((float)reviewStars[0]/(float)highestRow)), 30, (150 * ((float)reviewStars[0]/(float)highestRow)));
    rect(x + 51, y + 150 - (150 * ((float)reviewStars[1]/(float)highestRow)), 30, 150 * ((float)reviewStars[1]/(float)highestRow));
    rect(x + 81, y + 150 - (150 * ((float)reviewStars[2]/(float)highestRow)), 30, 150 * ((float)reviewStars[2]/(float)highestRow));
    rect(x + 111, y + 150 - (150 * ((float)reviewStars[3]/(float)highestRow)), 30, 150 * ((float)reviewStars[3]/(float)highestRow));
    rect(x + 141, y + 150 - (150 * ((float)reviewStars[4]/(float)highestRow)), 30, 150 * ((float)reviewStars[4]/(float)highestRow));
  }

  // Jamie Coffey (V1.0)
  public void nextReview() {
    if (currentReview < businessReview.size() - 1)
      currentReview++;
    else
      currentReview = 0;
  }

  // Jamie Coffey (V1.0)
  public void lastReview() {
    if (currentReview > 0)
      currentReview--;
    else
      currentReview = businessReview.size() - 1;
  }

  public void drawReview(int count) {
    businessReview.get(count).draw(100, 400);
  }

  // Matthew flynn v1.0
  // Creates am array of the number of star ratings of a particular value there is for this business.   

  public int[] designateStars()
  {
    int[] reviewStars = new int[5];
    int currentStarValue = 0;
    for (int i = 0; i < businessReview.size(); i++)
    {
      currentStarValue = (int)businessReview.get(i).getStars();
      switch(currentStarValue)
      {
      case 1:
        reviewStars[0]++;
        break;

      case 2:
        reviewStars[1]++;
        break;

      case 3:
        reviewStars[2]++;
        break;

      case 4:
        reviewStars[3]++;
        break;

      default:
        reviewStars[4]++;
        break;
      }
    }
    return reviewStars;
  }


  // Matthew Flynn v1.3
  // Draws page for the business
  void draw()
  {
    textFont(title);
    text(this.getBusinessName(), 20, 100);
    textFont(addressFont);
    text(this.getAddress() + "\n" + this.getCity(), 20, 150);
    textFont(categoryTitle);
    drawBarChart(600, 100);
    drawReview(currentReview);
    drawPieChart();
  }
  // Matthew Flynn v1.2
  // draws pie chart of stars.
  void drawPieChart() 
  {
    image(pieChartKey, 1200, 600);
    int[] stars = designateStars();
    int x = 1200;
    int y = 775;
    float diameter = 250;
    float lastAngle = 0;
    color colour = 0;
    int sumOfStars = 0;
    for (int i = 0; i < stars.length; i++)
    {
      sumOfStars = stars[i] + sumOfStars;
    }
    float radianValue = TWO_PI / sumOfStars; 
    for (int i = 0; i < 5; i++) 
    {
      switch(i)
      {
      case 0:
        {
          colour = color(250, 25, 250);
          break;
        }
      case 1:
        {
          colour = color(0, 250, 250);
          break;
        }
      case 2:
        {
          colour = color(250, 0, 0);
          break;
        }
      case 3:
        {
          colour = color(0, 250, 0);
          break;
        }
      case 4:
        {
          colour = color(0, 0, 0);
          break;
        }
      }
      fill(colour);
      arc(x, y, diameter, diameter, lastAngle, lastAngle+(stars[i] * radianValue));
      lastAngle = stars[i] * radianValue + lastAngle;
    }
  }
  // Matthew Flynn v1.0
  //getters
  public ArrayList<Review> getBusinessReview() {
    return businessReview;
  }
  public String getBusinessId() {
    return businessId;
  }
  public String getBusinessName() {
    return businessName;
  }
  public String getNeighborhood() {
    return neighborhood;
  }
  public String getAddress() {
    return address;
  }
  public String getCity() {
    return city;
  }
  public String getState() {
    return state;
  }
  public String getPostalCode() {
    return postalCode;
  }
  public double getLatitude() {
    return latitude;
  }
  public double getLongitude() {
    return longitude;
  }
  public double getStars() {
    return stars;
  }
  public int getReviewCount() {
    return reviewCount;
  }
  public int getIsOpen() {
    return isOpen;
  }
  public String getCategories() {
    return categories;
  }
  // Matthew Flynn
  //setters
  public void setBusinessReview(ArrayList<Review> businessReview) {
    this.businessReview = businessReview;
  }
  public void setBusinessId(String businessId) {
    this.businessId = businessId;
  }
  public void setBusinessName(String businessName) {
    this.businessName = businessName;
  }
  public void setNeighborhood(String neighborhood) {
    this.neighborhood = neighborhood;
  }
  public void setAddress(String address) {
    this.address = address;
  }
  public void setCity(String city) {
    this.city = city;
  }
  public void setState(String state) {
    this.state = state;
  }
  public void setPostalCode(String postalCode) {
    this.postalCode = postalCode;
  }
  public void setLatitude(double latitude) {
    this.latitude = latitude;
  }
  public void setLongitude(double longitude) {
    this.longitude = longitude;
  }
  public void setStars(double stars) {
    this.stars = stars;
  }
  public void setReviewCount(int reviewCount) {
    this.reviewCount = reviewCount;
  }
  public void setIsOpen(int isOpen) {
    this.isOpen = isOpen;
  }
  public void setCategories(String categories) {
    this.categories = categories;
  }

  @Override
    public String toString() {
    return "Business [businessId=" + businessId + ", businessName=" + businessName + ", neighborhood="
      + neighborhood + ", address=" + address + ", city=" + city + ", state=" + state + ", postalCode="
      + postalCode + ", latitude=" + latitude + ", longitude=" + longitude + ", stars=" + stars
      + ", reviewCount=" + reviewCount + ", isOpen=" + isOpen + ", categories=" + categories + "]";
  }

  //Author: Jamie Coffey (V1.1)
  void drawReviews(int x, int y) {
    for (int counter = 0; counter < businessReview.size(); counter++)
    {
      fill(255);
      textFont(stdFont);

      text(query.getUserById(businessReview.get(counter).getUserId()).userName, x, y);

      char[] reviewChars = businessReview.get(counter).text.toCharArray();
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

      switch((int)businessReview.get(counter).getStars()) {
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
      text(businessReview.get(counter).getUseful(), x + 640, y + 32);
      text(businessReview.get(counter).getFunny(), x + 640, y + 64);
      text(businessReview.get(counter).getCool(), x + 640, y + 96);
      y = y + 64 + (reviewChars.length / 100);
    }
  }
}