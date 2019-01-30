import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

//Query Class (current version 2, Ciaran Coady)
//Connect to SQLite database and allows for multiple queries

class Query {

  //Connects to the fullReviews database
  private Connection connect() {
    String databaseLocation = "jdbc:sqlite:D:\\fullReviews.db";
    Connection connection = null;
    try {
      connection = DriverManager.getConnection(databaseLocation);
    } 
    catch (SQLException e) {
      ////println(e.getMessage());
    }
    return connection;
  }

  //Creates virtual table to allow for more advanced search functionality with FTS5
  //ONLY NEEDS TO BE DONE ONCE!! NO NEED TO CALL THIS AGAIN AS I HAVE CREATED ALL NECESSARY VIRTUAL TABLES
  private void createNewVirtualTable() {
    // SQL statement for creating a new virtual table
    String createVirtualTable = "CREATE VIRTUAL TABLE IF NOT EXISTS usersVirtual USING FTS5(user_id, name, review_count, yelping_since, friends, useful, funny, cool, average_stars);";
    // SQL statement for copying existing table into a virtual table to allow for test search
    String insertDataIntoVirtualTable = "INSERT INTO usersVirtual SELECT user_id, name, review_count, yelping_since, friends, useful, funny, cool, average_stars FROM users";
    try
    {
      Connection connection = connect(); 
      Statement statement = connection.createStatement();
      // create a new virtual table
      statement.execute(createVirtualTable);
      // copy data to virtual table
      statement.execute(insertDataIntoVirtualTable);
      //println("Data sucessfully inserted into virtual table");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
  }

  //selects all rows in the users table
  void selectAllRows() {
    String selection = "SELECT user_id, name, review_count FROM users";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      ResultSet resultSet = statement.executeQuery(selection);

      // loop through the result set and print
      while (resultSet.next()) {
        //println(resultSet.getString("user_id") +  "\t" + 
          //resultSet.getString("name") + "\t" +
          //resultSet.getInt("review_count"));
      }
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
  }

  //Returns details of the business by id
  Business getBusinessById(String businessId) {
    //Sql query command
    String getBusinessById = "SELECT business_id, name, neighborhood, address, city, state, " +
      "postal_code, latitude, longitude, stars, review_count, is_open, categories " +
      "FROM businessVirtual WHERE business_id MATCH " + "'\"" + businessId + "\"'";
    Business newBusiness = null;
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      ResultSet resultSet  = statement.executeQuery(getBusinessById);
      // loop through the result set and create business objects
      while (resultSet.next()) {
        //println("making business");
        String business_id = resultSet.getString("business_id");
        String name = resultSet.getString("name");
        String neighborhood = resultSet.getString("neighborhood");
        String address = resultSet.getString("address");
        String city = resultSet.getString("city");
        String state = resultSet.getString("state");
        String postalCode = resultSet.getString("postal_code");
        double latitude = resultSet.getDouble("latitude");
        double longitude = resultSet.getDouble("longitude");
        double stars = resultSet.getDouble("stars");
        int reviewCount = resultSet.getInt("review_count");
        int isOpen = resultSet.getInt("is_open");
        String categories = resultSet.getString("categories");
        newBusiness = new Business(business_id, name, neighborhood, address, 
          city, state, postalCode, latitude, longitude, stars, reviewCount, isOpen, categories);
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return newBusiness;
  }
  
  //Returns the name of the business by id
  String getBusinessNameById(String businessId) {
    //Sql query command
    String getBusinessNameById = "SELECT name FROM businessVirtual WHERE business_id MATCH " + "'\"" + businessId + "\"'";
    String businessName = "";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      ResultSet resultSet  = statement.executeQuery(getBusinessNameById);
      // loop through the result set and create business objects
      while (resultSet.next()) {
        //println("making business");
        businessName = resultSet.getString("name");
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return businessName;
  }

  // Allows you to search for a business by name,
  // returns results with a word match to query
  public ArrayList<Business> getBusinessByName(String businessName) {
    ArrayList<Business> businesses = new ArrayList<Business>();
    String getBusinessByName = "SELECT business_id, name, neighborhood, address, city, state, " +
      "postal_code, latitude, longitude, stars, review_count, is_open, categories " +
      "FROM businessVirtual WHERE name MATCH " + "'\"" + businessName + "\"'";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getBusinessByName);
      // loop through the result set and create business objects
      // adding them to the businesses ArrayList
      while (resultSet.next()) {
        String business_id = resultSet.getString("business_id");
        String name = resultSet.getString("name");
        String neighborhood = resultSet.getString("neighborhood");
        String address = resultSet.getString("address");
        String city = resultSet.getString("city");
        String state = resultSet.getString("state");
        String postalCode = resultSet.getString("postal_code");
        double latitude = resultSet.getDouble("latitude");
        double longitude = resultSet.getDouble("longitude");
        double stars = resultSet.getDouble("stars");
        int reviewCount = resultSet.getInt("review_count");
        int isOpen = resultSet.getInt("is_open");
        String categories = resultSet.getString("categories");
        Business newBusiness = new Business(business_id, name, neighborhood, address, 
          city, state, postalCode, latitude, longitude, stars, reviewCount, isOpen, categories);
        businesses.add(newBusiness);
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return businesses;
  }

  // searches for a user by name
  // seems a bit impractical as there are so many users with the same name
  public void getUserByName(String userName) {
    String getBusinessByName = "SELECT user_id, name FROM usersVirtual WHERE name MATCH " + "'\"" + userName + "\"'";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getBusinessByName);
      // loop through the result set
      while (resultSet.next()) {
        //println(resultSet.getString("user_id") +  "\t" + 
          //resultSet.getString("name") + "\t");
      }
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
  }

  // gets all businesses that match the restaurants category
  public ArrayList<Business> getRestaurants() {
    ArrayList<Business> businesses = new ArrayList<Business>();
    String getRestaurants = "SELECT business_id, name, neighborhood, address, city, state, " +
      "postal_code, latitude, longitude, stars, review_count, is_open, categories FROM businessVirtual WHERE categories MATCH 'RESTAURANTS'";// LIMIT 50";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getRestaurants);
      // loop through the result set
      while (resultSet.next()) {
        String business_id = resultSet.getString("business_id");
        String name = resultSet.getString("name");
        String neighborhood = resultSet.getString("neighborhood");
        String address = resultSet.getString("address");
        String city = resultSet.getString("city");
        String state = resultSet.getString("state");
        String postalCode = resultSet.getString("postal_code");
        double latitude = resultSet.getDouble("latitude");
        double longitude = resultSet.getDouble("longitude");
        double stars = resultSet.getDouble("stars");
        int reviewCount = resultSet.getInt("review_count");
        int isOpen = resultSet.getInt("is_open");
        String categories = resultSet.getString("categories");
        Business newBusiness = new Business(business_id, name, neighborhood, address, 
          city, state, postalCode, latitude, longitude, stars, reviewCount, isOpen, categories);
        businesses.add(newBusiness);
      }
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return businesses;
  }
  
  // gets all businesses that match the nightlife category
  public ArrayList<Business> getNightlife() {
    ArrayList<Business> businesses = new ArrayList<Business>();
    String getNightlife = "SELECT business_id, name, neighborhood, address, city, state, " +
      "postal_code, latitude, longitude, stars, review_count, is_open, categories FROM businessVirtual WHERE categories MATCH 'NIGHTLIFE'";//LIMIT 50";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getNightlife);
      // loop through the result set
      while (resultSet.next()) {
        String business_id = resultSet.getString("business_id");
        String name = resultSet.getString("name");
        String neighborhood = resultSet.getString("neighborhood");
        String address = resultSet.getString("address");
        String city = resultSet.getString("city");
        String state = resultSet.getString("state");
        String postalCode = resultSet.getString("postal_code");
        double latitude = resultSet.getDouble("latitude");
        double longitude = resultSet.getDouble("longitude");
        double stars = resultSet.getDouble("stars");
        int reviewCount = resultSet.getInt("review_count");
        int isOpen = resultSet.getInt("is_open");
        String categories = resultSet.getString("categories");
        Business newBusiness = new Business(business_id, name, neighborhood, address, 
          city, state, postalCode, latitude, longitude, stars, reviewCount, isOpen, categories);
        businesses.add(newBusiness);
      }
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return businesses;
  }
  
  // gets all businesses that match the current location
  public ArrayList<Business> getLocation(String location) {
    ArrayList<Business> businesses = new ArrayList<Business>();
    String getLocaton = "SELECT business_id, name, neighborhood, address, city, state, " +
      "postal_code, latitude, longitude, stars, review_count, is_open, categories FROM businessVirtual WHERE city MATCH " + "'\"" + location + "\"'" ;
      // latitude > 10 AND latitude > " + lowerLatitude + " And longitude < " + upperLongitude + " && longitude > " + lowerLongitude + " LIMIT 50"
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getLocaton);
      // loop through the result set
      while (resultSet.next()) {
        String business_id = resultSet.getString("business_id");
        String name = resultSet.getString("name");
        String neighborhood = resultSet.getString("neighborhood");
        String address = resultSet.getString("address");
        String city = resultSet.getString("city");
        String state = resultSet.getString("state");
        String postalCode = resultSet.getString("postal_code");
        double latitude = resultSet.getDouble("latitude");
        double longitude = resultSet.getDouble("longitude");
        double stars = resultSet.getDouble("stars");
        int reviewCount = resultSet.getInt("review_count");
        int isOpen = resultSet.getInt("is_open");
        String categories = resultSet.getString("categories");
        Business newBusiness = new Business(business_id, name, neighborhood, address, 
          city, state, postalCode, latitude, longitude, stars, reviewCount, isOpen, categories);
        businesses.add(newBusiness);
      }
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return businesses;
  }

  // gets all the reivews that are about a specified business
  //revision 2, now sorts reviews by date
  public ArrayList<Review> getReviews(String business_id) {
    ArrayList<Review> reviews = new ArrayList<Review>();
    String getReviews = "SELECT review_id, user_id, business_id, stars, date, text, " +
      "useful, funny, cool FROM reviewVirtual WHERE business_id MATCH " + "'\"" + business_id + "\"'" + " ORDER BY date DESC";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getReviews);
      // loop through the result set and make review objects
      // adding them to the reviews ArrayList
      while (resultSet.next()) {
        String reviewId = resultSet.getString("review_id");
        String userId = resultSet.getString("user_id");
        String businessId = resultSet.getString("business_id");
        double stars = resultSet.getDouble("stars");
        String date = resultSet.getString("date");
        String text = resultSet.getString("text");
        int useful = resultSet.getInt("useful");
        int funny = resultSet.getInt("funny");
        int cool = resultSet.getInt("cool");
        Review review = new Review(reviewId, userId, businessId, stars, date, text, useful, funny, cool);
        reviews.add(review);
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return reviews;
  }

  // returns an ArrayList of the specified most recent reviews
  // these are sorted by date, not ideal takes very long
  public ArrayList<Review> getRecentReviews(int numberOfReviews) {
    ArrayList<Review> reviews = new ArrayList<Review>();
    //String getReviews = "SELECT review_id, user_id, business_id, stars, date, text, " +
    //"useful, funny, cool FROM reviewVirtual WHERE date BETWEEN \"2017/01/01\" AND \"2018/03/21\" ORDER BY date DESC LIMIT " + numberOfReviews;
    String getReviews = "SELECT review_id, user_id, business_id, stars, date, text, " +
      "useful, funny, cool FROM reviewVirtual WHERE date(date) BETWEEN date('2017/01/01') AND date('2018/03/21') LIMIT 5";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getReviews);
      // loop through the result set and make review objects
      // adding them to the reviews ArrayList
      int count = numberOfReviews;
      while (resultSet.next() && count <= 20) {
        String reviewId = resultSet.getString("review_id");
        String userId = resultSet.getString("user_id");
        String businessId = resultSet.getString("business_id");
        double stars = resultSet.getDouble("stars");
        String date = resultSet.getString("date");
        String text = resultSet.getString("text");
        int useful = resultSet.getInt("useful");
        int funny = resultSet.getInt("funny");
        int cool = resultSet.getInt("cool");
        Review review = new Review(reviewId, userId, businessId, stars, date, text, useful, funny, cool);
        reviews.add(review);
        count++;
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return reviews;
  }

  // returns an ArrayList of highly rated reviews
  public ArrayList<Review> getHighlyRatedReviews(int numberOfReviews) {
    ArrayList<Review> reviews = new ArrayList<Review>();
    String getReviews = "SELECT review_id, user_id, business_id, stars, date, text, " +
      "useful, funny, cool FROM reviewVirtual WHERE stars MATCH 5 LIMIT " + "'" + numberOfReviews + "'" ;
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getReviews);
      // loop through the result set and make review objects
      // adding them to the reviews ArrayList
      while (resultSet.next()) {
        String reviewId = resultSet.getString("review_id");
        String userId = resultSet.getString("user_id");
        String businessId = resultSet.getString("business_id");
        double stars = resultSet.getDouble("stars");
        String date = resultSet.getString("date");
        String text = resultSet.getString("text");
        int useful = resultSet.getInt("useful");
        int funny = resultSet.getInt("funny");
        int cool = resultSet.getInt("cool");
        Review review = new Review(reviewId, userId, businessId, stars, date, text, useful, funny, cool);
        reviews.add(review);
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return reviews;
  }

  //gets a users name based on their user id
  public String getUserName (String id)
  {
    String getUserName= "SELECT name FROM usersVirtual WHERE user_id MATCH " + "'\"" + id + "\"'";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      //
      ResultSet resultSet  = statement.executeQuery(getUserName);
      return resultSet.getString("name");
    }
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return null;
  }

  // gets all the reivews that were made by a specific user
  public ArrayList<Review> getUserReviews(String user_id) {
    ArrayList<Review> reviews = new ArrayList<Review>();
    String getReviews = "SELECT review_id, user_id, business_id, stars, date, text, " +
      "useful, funny, cool FROM reviewVirtual WHERE user_id MATCH " + "'\"" + user_id + "\"'";
    try
    {
      Connection connection = this.connect();
      Statement statement = connection.createStatement();
      ResultSet resultSet  = statement.executeQuery(getReviews);
      // loop through the result set and make review objects
      // adding them to the reviews ArrayList
      while (resultSet.next()) {
        String reviewId = resultSet.getString("review_id");
        String userId = resultSet.getString("user_id");
        String businessId = resultSet.getString("business_id");
        double stars = resultSet.getDouble("stars");
        String date = resultSet.getString("date");
        String text = resultSet.getString("text");
        int useful = resultSet.getInt("useful");
        int funny = resultSet.getInt("funny");
        int cool = resultSet.getInt("cool");
        Review review = new Review(reviewId, userId, businessId, stars, date, text, useful, funny, cool);
        reviews.add(review);
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return reviews;
  }
  //Ciaran Coady
  //Fixed query errors, and now will return a result
  //Added extra return data, review_count, useful, funny and cool
  //Fixed bug where would not return results(requires database to be updated)
  User getUserById(String userId) {
    //print(userId);
    String getUserById = "SELECT user_id, name, " +
      "review_count, useful, funny, cool " +
      "FROM usersVirtual WHERE user_id MATCH " + "'\"" + userId + "\"'";
    User newUser = null;
    try
    {
      Connection connection = this.connect();
      Statement statement  = connection.createStatement();
      //results matching id
      ResultSet resultSet  = statement.executeQuery(getUserById);
      // loop through the result set and create user objects
      while (resultSet.next()) {
        String user_id = resultSet.getString("user_id");
        String userName = resultSet.getString("name");
        int reviewCount = resultSet.getInt("review_count");
        int useful = resultSet.getInt("useful");
        int funny = resultSet.getInt("funny");
        int cool = resultSet.getInt("cool");
        newUser = new User(user_id, userName, reviewCount, useful, funny, cool);
      }
      //println("operation sucessful");
    } 
    catch (SQLException e) {
      //println(e.getMessage());
    }
    return newUser;
  }
}