//Updated Ciaran Coady //<>// //<>// //<>// //<>// //<>// //<>// //<>//
ArrayList<Review> reviewsList;
ArrayList<Screen> screensList;
PFont stdFont, gothicFont;
PImage star, usefulImage, funnyImage, coolImage, homeScreenLogo, pieChartKey;
int currentScreen;
int reviewPage;
boolean searched, searchedResturant, searchedNight;
boolean popUp;
int count;
LoadFonts fonts;
Business currentBusiness;
User currentUser;
Query query;
TextWidget textWidget;
Widget search, widget3, widget4;
Screen screen0, screen1, screen2, screen3;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT);
}

void setup()
{
  frameRate(60);
  currentUser = null;
  currentBusiness = null;
  //create a connection to the database
  query = new Query();
  //load fonts
  fonts = new LoadFonts();
  stdFont = STDFONT;
  gothicFont = GOTHICFONT;
  popUp = false;

  //load images
  star = loadImage("star.png");
  usefulImage = loadImage("useful.png");
  funnyImage = loadImage("funny.png");
  coolImage = loadImage("cool.png");
  homeScreenLogo = loadImage("ProgrammingProject Logo.png");
  pieChartKey = loadImage("pieChartKey.png");
  homeScreenLogo.resize(SCREEN_WIDTH/3, SCREEN_HEIGHT/3);
  reviewPage = 1;

  //setup screens
  initialiseScreens();
}

// Jamie Coffey (V1.2)
void draw()
{
  if (currentScreen == HOME_SCREEN)
  {
    screensList.get(currentScreen).draw();
  } else if (currentScreen == RESULTS_SCREEN)
  {
    screensList.get(currentScreen).draw();
  } else if (currentScreen == BUSINESS_SCREEN)
  {
    screensList.get(currentScreen).draw();
    currentBusiness.draw();
  } else if (currentScreen == USER_SCREEN)
  {
    screensList.get(currentScreen).draw();
    currentUser.draw();
  }
}
void mousePressed() {
  screensList.get(currentScreen).text();
  int event = screensList.get(currentScreen).getEvent();
  if (event == 0 && currentBusiness != null && currentBusiness.businessReview.get(currentBusiness.currentReview).getEvent(mouseX, mouseY) == EVENT_GOTO_USER)
  {
    currentUser = query.getUserById(currentBusiness.businessReview.get(currentBusiness.currentReview).getUserId());
    currentBusiness = null;
    currentScreen = USER_SCREEN;
  } else if (event == 0 && currentUser != null && currentUser.userReviews.get(currentUser.currentReview).getEvent(mouseX, mouseY) == EVENT_GOTO_BUSINESS)
  {
    currentBusiness = query.getBusinessById(currentUser.userReviews.get(currentUser.currentReview).getBusinessId());
    System.out.print("\n"+ currentBusiness.getBusinessName());
    currentBusiness.businessReview = query.getReviews(currentBusiness.businessId);
    currentUser = null;
    currentScreen = BUSINESS_SCREEN;
  }

  if (event == EVENT_SEARCH) {
    query = new Query();
    searched = true; 
    searchedResturant = false; 
    searchedNight =false;
    reviewPage = 1;
    ArrayList<Business> businesses = query.getBusinessByName(screen0.textBoxes.get(0).getLabel());
    addResultsToScreen(businesses, reviewPage);
    screen1.scrollBars.get(0).setPos(0);                                                  //returns scroll bar to top at every search
    currentScreen = RESULTS_SCREEN;
  } 


  //
  //handles next and previous reviews page widget, action takes into account business size
  else if (event == EVENT_NEXT_REVIEWS_PAGE) {

    if (searched) {
      ArrayList<Business> businesses = query.getBusinessByName(screen0.textBoxes.get(0).getLabel());
      if (reviewPage*PAGE_LENGTH < businesses.size()) {
        page(businesses, UP);
      }
    } else if (searchedResturant) {
      ArrayList<Business> businesses = query.getRestaurants();
      if (reviewPage*PAGE_LENGTH < businesses.size()) {
        page(businesses, UP);
      }
    } else if (searchedNight) {
      ArrayList<Business> businesses = query.getNightlife();
      if (reviewPage*PAGE_LENGTH < businesses.size()) {
        page(businesses, UP);
      }
    } else {
      ArrayList<Business> businesses = query.getLocation(screen0.textBoxes.get(0).getLabel());
      if (reviewPage*PAGE_LENGTH < businesses.size()) {
        page(businesses, UP);
      }
    }
  } else if (event == EVENT_PREV_REVIEWS_PAGE) {

    if (searched) {
      ArrayList<Business> businesses = query.getBusinessByName(screen0.textBoxes.get(0).getLabel());
      if (reviewPage >= 2) {
        page(businesses, DOWN);
      }
    } else if (searchedResturant) {
      ArrayList<Business> businesses = query.getRestaurants();
      if (reviewPage >= 2) {
        page(businesses, DOWN);
      }
    } else if (searchedNight) {
      ArrayList<Business> businesses = query.getNightlife();
      if (reviewPage >= 2) {
        page(businesses, DOWN);
      }
    } else {
      ArrayList<Business> businesses = query.getLocation(screen0.textBoxes.get(0).getLabel());
      if (reviewPage >= 2) {
        page(businesses, DOWN);
      }
    }
  } else if (event == EVENT_EXPAND) {
    if (count % 2 == 0) {
      screen0.addWidget(1150, 450, 260, 99, "", color(100), gothicFont, EVENT_NULL);
      screen0.addWidget(1160, 460, 240, 40, "By Location", color(255, 0, 0), gothicFont, EVENT_LOCATION);
    } else {
      screen0.removeWidgets();
    }
    count++;
  } else if (event == EVENT_BUSINESS) {
    selectBusiness();
  } else if (event == EVENT_BACK) {
    currentScreen = HOME_SCREEN;
    screen1.resetSearchResults();
  } else if (event == EVENT_NEXT_REVIEW) {
    if (currentUser != null)
      currentUser.nextReview();
    if (currentBusiness != null)
      currentBusiness.nextReview();
  } else if (event == EVENT_PREV_REVIEW) {
    if (currentUser != null)
      currentUser.lastReview();
    if (currentBusiness != null)
      currentBusiness.lastReview();
  } else if (event == EVENT_SORT_OLD) {
    if (currentUser != null)
      currentUser.sortByOldest();
    if (currentBusiness != null)
      currentBusiness.sortByOldest();
  } else if (event == EVENT_SORT_NEW) {
    if (currentUser != null)
      currentUser.sortByNewest();
    if (currentBusiness != null)
      currentBusiness.sortByNewest();
  } else if (event == EVENT_SORT_FUNNY) {
    currentUser.sortByFunniest();
  } else if (event == EVENT_SORT_USEFUL) {
    currentUser.sortByMostUseful();
  } else if (event == EVENT_SORT_COOL) {
    currentUser.sortByCoolest();
  } else if (event == EVENT_RESTAURANTS) {
    println("now searching for restaurants");
    query = new Query();
    reviewPage = 1;
    searched = false; 
    searchedResturant = true; 
    searchedNight =false;
    ArrayList<Business> businesses = query.getRestaurants();
    addResultsToScreen(businesses, reviewPage);
    currentScreen = RESULTS_SCREEN;
  } else if (event == EVENT_NIGHTLIFE) {
    println("now searching for nightclubs");
    query = new Query();
    reviewPage = 1;
    searched = false; 
    searchedResturant = false; 
    searchedNight =true;
    ArrayList<Business> businesses = query.getNightlife();
    addResultsToScreen(businesses, reviewPage);
    currentScreen = RESULTS_SCREEN;
  } else if (event == EVENT_LOCATION) {
    println("now searching in a specified location");
    query = new Query();
    reviewPage = 1;
    searched = false; 
    searchedResturant = false; 
    searchedNight =false;
    ArrayList<Business> businesses = query.getLocation(screen0.textBoxes.get(0).getLabel());
    println("returned results");
    addResultsToScreen(businesses, reviewPage);
    currentScreen = RESULTS_SCREEN;
  } else if (event == EVENT_SORT_HIGH) {
    currentBusiness.sortByHighestRating();
  } else if (event == EVENT_SORT_LOW) {
    currentBusiness.sortByLowestRating();
  }
}

void keyPressed() {
  screensList.get(currentScreen).key();
}

//adds the business search results to the search screen
void addResultsToScreen(ArrayList<Business> businesses, int page) {
  if (businesses.size() == 0)
  {
    screen1.removeScrollWidgets();
    screen1.addScrollWidget(10, 150, SCREEN_WIDTH-40, 110, "No Results Found", "", BACKGROUND_COLOR, stdFont, -10, 70, null);
  } else {
    screen1.addScrollBar(width-10, 72, 20, height - 70, 4);
    for (int i = (PAGE_LENGTH*page)-PAGE_LENGTH, c = 0; i < PAGE_LENGTH * page && c < PAGE_LENGTH; i++, c++)
    {
      if (businesses.size() > i)
      {
        String businessName = businesses.get(i).getBusinessName();
        String businessAddress = businesses.get(i).getAddress();
        screen1.addScrollWidget(10, 150 + (115*c), SCREEN_WIDTH-40, 110, businessName, businessAddress, BACKGROUND_COLOR, stdFont, EVENT_BUSINESS, 70, businesses.get(i));
      }
    }
  }
}


//intialises all the UI for each screen
void initialiseScreens() {
  //setup homescreen
  screen0 = new Screen();
  screen0.addTextBox(300, 550, 950, 40, "Enter business/location....", color(255), gothicFont, EVENT_TEXT, 55);
  screen0.addWidget(1250, 550, 120, 40, "search", color(255, 0, 0), gothicFont, EVENT_SEARCH);
  screen0.addWidget(1370, 550, 40, 40, "^", color(100), gothicFont, EVENT_EXPAND);
  screen0.addWidget(650, 610, 185, 40, "Restaurants", color(255, 0, 0), gothicFont, EVENT_RESTAURANTS);
  screen0.addWidget(850, 610, 140, 40, "Nightlife", color(255, 0, 0), gothicFont, EVENT_NIGHTLIFE);
  screen0.addImageWidget(550, 200, homeScreenLogo, 0);
  //setup results screen
  screen1 = new Screen();
  screen1.addWidget(10, 10, 120, 40, "home", color(255, 0, 0), gothicFont, EVENT_BACK);
  screen1.addWidget(1500, 10, 100, 40, "next", color(255, 0, 0), gothicFont, EVENT_NEXT_REVIEWS_PAGE);
  screen1.addWidget(1300, 10, 100, 40, "prev", color(255, 0, 0), gothicFont, EVENT_PREV_REVIEWS_PAGE);
  //screen1.addScrollBar(width-10, 72, 20, height - 70, 4);
  //setup business screen
  screen2 = new Screen();
  screen2.addWidget(0, 0, width, 300, "", BACKGROUND_COLOR, gothicFont, EVENT_NULL);
  screen2.addWidget(10, 10, 120, 40, "home", color(255, 0, 0), gothicFont, EVENT_BACK);
  screen2.addWidget(25, 450, 65, 35, "Previous", color(255, 0, 0), stdFont, EVENT_PREV_REVIEW);
  screen2.addWidget(725, 450, 50, 35, "Next", color(255, 0, 0), stdFont, EVENT_NEXT_REVIEW);
  screen2.addWidget(100, 350, 60, 35, "Oldest", color(255, 0, 0), stdFont, EVENT_SORT_OLD);
  screen2.addWidget(175, 350, 60, 35, "Newest", color(255, 0, 0), stdFont, EVENT_SORT_NEW);
  screen2.addWidget(250, 350, 70, 35, "Highest", color(255, 0, 0), stdFont, EVENT_SORT_HIGH);
  screen2.addWidget(325, 350, 70, 35, "Lowest", color(255, 0, 0), stdFont, EVENT_SORT_LOW);
  //setup reviews screen
  screen3 = new Screen();

  screen3.addWidget(0, 0, width, 300, "", BACKGROUND_COLOR, gothicFont, EVENT_NULL);
  screen3.addWidget(10, 10, 120, 40, "home", color(255, 0, 0), gothicFont, EVENT_BACK);
  screen3.addWidget(25, 450, 65, 35, "Previous", color(255, 0, 0), stdFont, EVENT_PREV_REVIEW);
  screen3.addWidget(725, 450, 50, 35, "Next", color(255, 0, 0), stdFont, EVENT_NEXT_REVIEW);
  screen3.addWidget(100, 350, 60, 35, "Oldest", color(255, 0, 0), stdFont, EVENT_SORT_OLD);
  screen3.addWidget(175, 350, 60, 35, "Newest", color(255, 0, 0), stdFont, EVENT_SORT_NEW);
  screen3.addWidget(250, 350, 70, 35, "Funniest", color(255, 0, 0), stdFont, EVENT_SORT_FUNNY);
  screen3.addWidget(325, 350, 85, 35, "Most Useful", color(255, 0, 0), stdFont, EVENT_SORT_USEFUL);
  screen3.addWidget(425, 350, 60, 35, "Coolest", color(255, 0, 0), stdFont, EVENT_SORT_COOL);

  // set current screen to home
  currentScreen = 0;
  //add all screens to the screens array list
  screensList = new ArrayList<Screen>();
  screensList.add(screen0); 
  screensList.add(screen1); 
  screensList.add(screen2); 
  screensList.add(screen3);
}


void selectBusiness() {
  boolean finished2 = false;
  for (int i = 0; i < PAGE_LENGTH && !finished2; i++)
  {
    int x = screen1.scrollWidgets.get(i).x;
    int y = screen1.scrollWidgets.get(i).getY();                                             //collision error now fixed using getY function
    int width = screen1.scrollWidgets.get(i).width;
    int height = screen1.scrollWidgets.get(i).height;
    println("");
    println(screen1.scrollWidgets.get(i).x + " " + screen1.scrollWidgets.get(i).y + " " +  screen1.scrollWidgets.get(i).width + " " + screen1.scrollWidgets.get(i).height);

    if (mouseX >= x && mouseX < x + width && mouseY >= y && mouseY < y + height)
    {
      finished2 = true;
      currentBusiness = screen1.scrollWidgets.get(i).business;
      currentBusiness.businessReview = query.getReviews(currentBusiness.businessId);
      System.out.print("\n" + currentBusiness.businessName);
    }
    currentScreen = BUSINESS_SCREEN;
    currentUser = null;
  }
}

void page(ArrayList<Business> businesses, boolean bool) {

  screen1.removeScrollWidgets();
  if (bool) reviewPage++;
  else reviewPage--;
  addResultsToScreen(businesses, reviewPage);
  screen1.scrollBars.get(0).setPos(0);
}