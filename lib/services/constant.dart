class Constant {
  static const int cacheDurationHours = 24;

  static const int successCode = 200;
  static const List<int> clientError = [400, 499];
  static const List<int> serverError = [500, 599];

  static const int readTimeout = 6000;
  static const int writeTimeout = 7000;
  static const String baseUrl = "http://api.susumaktam.com";
  static const String login = "/login";
  static const String selling = "/api/v1/outlet/selling";
  static const String stock = "/api/v1/outlet/stock";
  static const String material = "/api/v1/outlet/materials";
  static const String materialItem = "/api/v1/outlet/materials/list";
  static const String categoryItems = "/api/v1/outlet/categories-and-items";
  static const String categoryOutletItems = "/api/v1/outlet/outlet_items";
}
