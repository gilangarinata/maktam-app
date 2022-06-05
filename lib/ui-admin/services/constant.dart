class Constant {
  static const int cacheDurationHours = 24;

  static const int successCode = 200;
  static const List<int> clientError = [400, 499];
  static const List<int> serverError = [500, 599];

  static const int readTimeout = 6000;
  static const int writeTimeout = 7000;

  static const String summary = "/api/v1/admin/dashboard/summary";
  static const String products = "/api/v1/admin/master-data/items";
  static const String selling = "/api/v1/admin/dashboard/selling";
  static const String stock = "/api/v1/admin/dashboard/stock";
  static const String materialItem = "/api/v1/admin/master-data/materials";
  static const String materialData = "/api/v1/admin/dashboard/materials";
  static const String inventory = "/api/v1/admin/dashboard/inventory";
  static const String subcategory = "/api/v1/admin/master-data/subcategories";
  static const String category = "/api/v1/admin/master-data/categories";
  static const String users = "/api/v1/admin/master-data/users";
  static const String outlet = "/api/v1/admin/master-data/outlet";

  static const String baseUrl = "http://api.susumaktam.com";
  static const String login = "/login";

}
