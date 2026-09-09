// ignore_for_file: constant_identifier_names
const String url = "https://teamstreakpromo-mern-express-indol.vercel.app";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();
  //backend_url
  static String signUp() => "/api/auth/register";
  static String verifyRegisterOtp() => "/api/auth/verify-register-otp";
  static String resendRegisterOtp() => "/api/auth/resend-activation-otp";
  static String logIn() => "/api/auth/login";
  static String logOut() => "/api/auth/logout";
  static String refreshToken() => "/api/auth/refresh-token";
  static String forgotPassword() => "/api/auth/forgot-password";
  static String verifyForgotPasswordOtp() =>
      "/api/auth/verify-forgot-password-otp";
  static String resetPassword() => "/api/auth/reset-password";

  ///profile
  static String profile() => "/api/user/profile";
  static String updateProfile() => "/api/auth/profile";

  // static String getShopByCategories(String slug) =>
  //     "/api/shop-categories/$slug/";

  static String example() => "/api/";

  static String products(int pageNum, int perPage) =>
      "/products?page=$pageNum&per_page=$perPage";
  static String productDetails(int id) => "/products/$id";

  static String categories() => "/api/categories";
  static String rewardCategories() => "/api/reward-categories";
  static String rewardSubcategories(String categoryId) => 
      "/api/reward-subcategories?rewardCategory=$categoryId";
  static String marketplaces() => "/api/marketplaces";
  static String subcategories(String parentId) =>
      "/api/categories?parentCategory=$parentId";
  static String createEvent() => "/api/events";
  static String getEvents({String? hostId}) {
    if (hostId != null && hostId.isNotEmpty) {
      return "/api/events?hostId=$hostId";
    }
    return "/api/events";
  }

  static String getEventDetails(String id) => "/api/events/$id";
  static String deleteEvent(String id) => "/api/events/$id";
  static String updateEvent(String id) => "/api/events/$id";
  static String authMe() => "/api/auth/me";
  static String marketplaceDetails(String id) => "/api/marketplaces/$id";
}
