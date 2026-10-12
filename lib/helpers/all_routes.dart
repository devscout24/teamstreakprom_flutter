// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:teamstreakpromo/features/host_features/profile/presentation/host_edit_profile_screen.dart';
import 'package:teamstreakpromo/features/notification/presentation/notification_screen.dart';
import 'package:teamstreakpromo/features/rewards/presentation/rewards_point_details_screen.dart';
import 'package:teamstreakpromo/navigation_screen.dart';
import '../features/auth/presentation/choose_account_type_screen.dart';
import '../features/auth/presentation/signin_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';
import '../features/auth/presentation/create_new_password_screen.dart';
import '../features/onboarding/presentation/pick_interest_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/host_features/auth/presentation/personal_account_information.dart';
import '../features/host_features/auth/presentation/business_details.dart';
import '../features/host_features/auth/presentation/verify_identity.dart';
import '../features/host_features/auth/presentation/upload_business_documents.dart';
import '../features/host_features/subscription_screen/presentation/subscription_screen.dart';
import '../features/host_features/bottom_nav_bar/presentation/host_navigation_screen.dart';
import '../features/host_features/host_home/presentation/all_events_screen.dart';
import '../features/host_features/host_earning/presentation/earning_overview_screen.dart';
import '../features/host_features/host_events/presentation/create_event_wizard.dart';
import '../features/host_features/host_scan/presentation/qr_scanner_screen.dart';
import '../features/host_features/host_scan/presentation/scan_result_screen.dart';
import 'package:teamstreakpromo/features/host_employee_feature/profile/presentation/host_employee_profile_screen.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_navbar_screen.dart';
import '../features/settings/presentation/account_settings_screen.dart';
import '../features/settings/presentation/edit_profile_screen.dart';
import '../features/settings/presentation/notification_settings_screen.dart';
import '../features/settings/presentation/security_screen.dart';
import '../features/settings/presentation/invite_friend_screen.dart';
import '../features/settings/presentation/terms_condition_screen.dart';
import '../features/settings/presentation/help_support_screen.dart';
import '../features/settings/presentation/support_options_screen.dart';
import '../features/settings/presentation/submit_problem_screen.dart';
import '../features/settings/presentation/support_chat_screen.dart';
import '../features/settings/presentation/manage_team_screen.dart';
import '../features/settings/presentation/stripe_connect_screen.dart';
import '../features/settings/presentation/stripe_webview_screen.dart';
import '../features/event/presentation/event_details_screen.dart';
import '../features/my_ticket/presentation/ticket_details_screen.dart';
import '../features/rewards/presentation/marketplace_reward_details_screen.dart';

final class Routes {
  static final Routes _routes = Routes._internal();
  Routes._internal();
  static Routes get instance => _routes;

  // Auth Routes
  static const String chooseAccountTypeScreen = '/chooseAccountType';
  static const String loginScreen = '/logIn';
  static const String signUpScreen = '/signUp';
  static const String signInScreen = '/signIn';
  static const String forgotPWScreen = '/ForgotPWScreen';
  static const String otpScreen = '/OtpScreen';
  static const String createNewPasswordScreen = '/CreateNewPassword';
  static const String setPassword = '/SetPassword';
  // Host Auth Routes
  static const String personalAccountInformationScreen =
      '/personalAccountInformation';
  static const String businessDetailsScreen = '/businessDetails';
  static const String verifyIdentityScreen = '/verifyIdentity';
  static const String uploadBusinessDocumentsScreen =
      '/uploadBusinessDocuments';
  static const String subscriptionScreen = '/subscriptionScreen';
  static const String hostNavigationScreen = '/hostNavigation';
  static const String allEventsScreen = '/allEvents';
  static const String createEventScreen = '/createEvent';
  static const String earningOverviewScreen = '/earningOverview';
  static const String qrScannerScreen = '/qrScanner';
  static const String scanResultScreen = '/scanResult';
  static const String hostEmployeeProfileScreen = '/hostEmployeeProfile';
  static const String businessPartnerNavbarScreen = '/businessPartnerNavbar';

  //products_with_pagination
  static const String productsWithPagination = '/ProductsWithPagination';
  //ProductsScreen
  static const String productsScreen = '/ProductsScreen';
  //ProductDetailsScreen
  static const String productDetailsScreen = '/ProductDetailsScreen';
  //EventDetailsScreen
  static const String eventDetailsScreen = '/EventDetailsScreen';

  // Main App Routes
  static const String pickInterestScreen = '/PickInterest';
  static const String homeScreen = '/home_screen';
  static const String navigationScreen = '/NavigationScreen';
  static const String profile = '/Profile';
  static const String notificationScreen = '/notificationScreen';
  static const String accountSettingsScreen = '/accountSettingsScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String notificationSettingsScreen =
      '/notificationSettingsScreen';
  static const String securityScreen = '/securityScreen';
  static const String inviteFriendScreen = '/inviteFriendScreen';
  static const String termsConditionScreen = '/termsConditionScreen';
  static const String helpSupportScreen = '/helpSupportScreen';
  static const String supportOptionsScreen = '/supportOptionsScreen';
  static const String submitProblemScreen = '/submitProblemScreen';
  static const String supportChatScreen = '/supportChatScreen';
  static const String rewardsPointDetailsScreen = '/rewardsPointDetailsScreen';
  static const String manageTeamScreen = '/manageTeamScreen';
  static const String stripeConnectScreen = '/stripeConnectScreen';
  static const String stripeWebViewScreen = '/stripeWebViewScreen';

  static const String hostEditProfileScreen = '/hostEditProfileScreen';
  static const String businessPartnerNavigationScreen =
      '/businessPartnerNavigationScreen';
  static const String ticketDetailsScreen = '/ticketDetailsScreen';
  static const String marketplaceRewardDetailsScreen =
      '/marketplaceRewardDetailsScreen';
}

final class RouteGenerator {
  static final RouteGenerator _routeGenerator = RouteGenerator._internal();
  RouteGenerator._internal();
  static RouteGenerator get instance => _routeGenerator;

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.hostEditProfileScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const HostEditProfileScreen(),
              )
            : _FadedTransitionRoute(
                widget: const HostEditProfileScreen(),
                settings: settings,
              );
      case Routes.pickInterestScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const PickInterestScreen(),
              )
            : _FadedTransitionRoute(
                widget: const PickInterestScreen(),
                settings: settings,
              );
      case Routes.chooseAccountTypeScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final isSignUp = args?['isSignUp'] as bool? ?? false;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => ChooseAccountTypeScreen(isSignUp: isSignUp),
              )
            : _FadedTransitionRoute(
                widget: ChooseAccountTypeScreen(isSignUp: isSignUp),
                settings: settings,
              );

      case Routes.eventDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => EventDetailsScreen(
                  title: args?['title'] as String? ?? '',
                  location: args?['location'] as String? ?? '',
                  date: args?['date'] as String? ?? '',
                  price: args?['price'] as String? ?? '',
                  imageUrl: args?['imageUrl'] as String? ?? '',
                  description: args?['description'] as String? ?? '',
                  eventId: args?['eventId'] as String? ?? '',
                ),
              )
            : _FadedTransitionRoute(
                widget: EventDetailsScreen(
                  title: args?['title'] as String? ?? '',
                  location: args?['location'] as String? ?? '',
                  date: args?['date'] as String? ?? '',
                  price: args?['price'] as String? ?? '',
                  imageUrl: args?['imageUrl'] as String? ?? '',
                  description: args?['description'] as String? ?? '',
                  eventId: args?['eventId'] as String? ?? '',
                ),
                settings: settings,
              );

      case Routes.signInScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final accountType = args?['accountType'] as AccountType?;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => SigninScreen(accountType: accountType),
              )
            : _FadedTransitionRoute(
                widget: SigninScreen(accountType: accountType),
                settings: settings,
              );

      case Routes.notificationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const NotificationScreen(),
              )
            : _FadedTransitionRoute(
                widget: const NotificationScreen(),
                settings: settings,
              );

      case Routes.businessPartnerNavigationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const BusinessPartnerNavbarScreen(),
              )
            : _FadedTransitionRoute(
                widget: const BusinessPartnerNavbarScreen(),
                settings: settings,
              );
      case Routes.manageTeamScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ManageTeamScreen())
            : _FadedTransitionRoute(
                widget: const ManageTeamScreen(),
                settings: settings,
              );

      case Routes.signUpScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const SignupScreen())
            : _FadedTransitionRoute(
                widget: const SignupScreen(),
                settings: settings,
              );

      case Routes.forgotPWScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const ForgotPasswordScreen(),
              )
            : _FadedTransitionRoute(
                widget: const ForgotPasswordScreen(),
                settings: settings,
              );

      case Routes.hostEmployeeProfileScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const HostEmployeeProfileScreen(),
              )
            : _FadedTransitionRoute(
                widget: const HostEmployeeProfileScreen(),
                settings: settings,
              );

      case Routes.otpScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final type = args?['type'] as String?;
        final email = args?['email'] as String? ?? "jessicawilson@examle.com";
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) =>
                    OtpVerificationScreen(type: type, email: email),
              )
            : _FadedTransitionRoute(
                widget: OtpVerificationScreen(type: type, email: email),
                settings: settings,
              );

      case Routes.createNewPasswordScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final email = args?['email'] as String?;
        final resetToken = args?['resetToken'] as String?;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => CreateNewPasswordScreen(
                  email: email,
                  resetToken: resetToken,
                ),
              )
            : _FadedTransitionRoute(
                widget: CreateNewPasswordScreen(
                  email: email,
                  resetToken: resetToken,
                ),
                settings: settings,
              );

      case Routes.personalAccountInformationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const PersonalAccountInformationScreen(),
              )
            : _FadedTransitionRoute(
                widget: const PersonalAccountInformationScreen(),
                settings: settings,
              );

      case Routes.businessDetailsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const BusinessDetailsScreen(),
                settings: settings,
              )
            : _FadedTransitionRoute(
                widget: const BusinessDetailsScreen(),
                settings: settings,
              );

      case Routes.verifyIdentityScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const VerifyIdentityScreen(),
                settings: settings,
              )
            : _FadedTransitionRoute(
                widget: const VerifyIdentityScreen(),
                settings: settings,
              );

      case Routes.uploadBusinessDocumentsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const UploadBusinessDocumentsScreen(),
                settings: settings,
              )
            : _FadedTransitionRoute(
                widget: const UploadBusinessDocumentsScreen(),
                settings: settings,
              );

      case Routes.subscriptionScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final accountType = args?['accountType'] as AccountType?;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) =>
                    SubscriptionScreen(accountType: accountType),
              )
            : _FadedTransitionRoute(
                widget: SubscriptionScreen(accountType: accountType),
                settings: settings,
              );

      case Routes.businessPartnerNavbarScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const BusinessPartnerNavbarScreen(),
              )
            : _FadedTransitionRoute(
                widget: const BusinessPartnerNavbarScreen(),
                settings: settings,
              );

      case Routes.hostNavigationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const HostNavigationScreen(),
              )
            : _FadedTransitionRoute(
                widget: const HostNavigationScreen(),
                settings: settings,
              );

      case Routes.allEventsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const AllEventsScreen())
            : _FadedTransitionRoute(
                widget: const AllEventsScreen(),
                settings: settings,
              );

      case Routes.createEventScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final rawEventData = args?['eventData'];
        dynamic resolvedEventData;
        if (rawEventData is List && rawEventData.isNotEmpty) {
          resolvedEventData = rawEventData.first;
        } else {
          resolvedEventData = rawEventData;
        }

        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) =>
                    CreateEventWizard(eventData: resolvedEventData),
              )
            : _FadedTransitionRoute(
                widget: CreateEventWizard(eventData: resolvedEventData),
                settings: settings,
              );

      case Routes.earningOverviewScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const EarningOverviewScreen(),
              )
            : _FadedTransitionRoute(
                widget: const EarningOverviewScreen(),
                settings: settings,
              );

      case Routes.qrScannerScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const QrScannerScreen())
            : _FadedTransitionRoute(
                widget: const QrScannerScreen(),
                settings: settings,
              );

      case Routes.scanResultScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const ScanResultScreen())
            : _FadedTransitionRoute(
                widget: const ScanResultScreen(),
                settings: settings,
              );

      // Main App Routes
      case Routes.homeScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const HomeScreen())
            : _FadedTransitionRoute(
                widget: const HomeScreen(),
                settings: settings,
              );

      case Routes.navigationScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const NavigationScreen())
            : _FadedTransitionRoute(
                widget: const NavigationScreen(),
                settings: settings,
              );

      case Routes.accountSettingsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const AccountSettingsScreen(),
              )
            : _FadedTransitionRoute(
                widget: const AccountSettingsScreen(),
                settings: settings,
              );

      case Routes.editProfileScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const EditProfileScreen(),
              )
            : _FadedTransitionRoute(
                widget: const EditProfileScreen(),
                settings: settings,
              );

      case Routes.notificationSettingsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const NotificationSettingsScreen(),
              )
            : _FadedTransitionRoute(
                widget: const NotificationSettingsScreen(),
                settings: settings,
              );

      case Routes.securityScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(builder: (context) => const SecurityScreen())
            : _FadedTransitionRoute(
                widget: const SecurityScreen(),
                settings: settings,
              );

      case Routes.inviteFriendScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const InviteFriendScreen(),
              )
            : _FadedTransitionRoute(
                widget: const InviteFriendScreen(),
                settings: settings,
              );

      case Routes.termsConditionScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const TermsConditionScreen(),
              )
            : _FadedTransitionRoute(
                widget: const TermsConditionScreen(),
                settings: settings,
              );

      case Routes.helpSupportScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const HelpSupportScreen(),
              )
            : _FadedTransitionRoute(
                widget: const HelpSupportScreen(),
                settings: settings,
              );

      case Routes.supportOptionsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const SupportOptionsScreen(),
              )
            : _FadedTransitionRoute(
                widget: const SupportOptionsScreen(),
                settings: settings,
              );

      case Routes.rewardsPointDetailsScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const RewardsPointDetailsScreen(),
              )
            : _FadedTransitionRoute(
                widget: const RewardsPointDetailsScreen(),
                settings: settings,
              );

      case Routes.submitProblemScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final topic = args?['topic'] as String? ?? 'Others';
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => SubmitProblemScreen(topic: topic),
              )
            : _FadedTransitionRoute(
                widget: SubmitProblemScreen(topic: topic),
                settings: settings,
              );

      case Routes.supportChatScreen:
        final argsChat = settings.arguments as Map<String, dynamic>?;
        final topicChat = argsChat?['topic'] as String? ?? '';
        final problemChat = argsChat?['problem'] as String? ?? '';
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) =>
                    SupportChatScreen(topic: topicChat, problem: problemChat),
              )
            : _FadedTransitionRoute(
                widget: SupportChatScreen(
                  topic: topicChat,
                  problem: problemChat,
                ),
                settings: settings,
              );

      case Routes.stripeConnectScreen:
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => const StripeConnectScreen(),
              )
            : _FadedTransitionRoute(
                widget: const StripeConnectScreen(),
                settings: settings,
              );

      case Routes.stripeWebViewScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        final url = args?['url'] as String? ?? '';
        final stripeAccountId = args?['stripeAccountId'] as String?;
        final returnUrl = args?['returnUrl'] as String? ??
            'https://yourfrontend.com/host/stripe/return';
        final refreshUrl = args?['refreshUrl'] as String? ??
            'https://yourfrontend.com/host/stripe/refresh';
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => StripeWebViewScreen(
                  url: url,
                  stripeAccountId: stripeAccountId,
                  returnUrl: returnUrl,
                  refreshUrl: refreshUrl,
                ),
              )
            : _FadedTransitionRoute(
                widget: StripeWebViewScreen(
                  url: url,
                  stripeAccountId: stripeAccountId,
                  returnUrl: returnUrl,
                  refreshUrl: refreshUrl,
                ),
                settings: settings,
              );

      case Routes.ticketDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => TicketDetailsScreen(
                  orderId: args?['orderId'] as String?,
                ),
              )
            : _FadedTransitionRoute(
                widget: TicketDetailsScreen(
                  orderId: args?['orderId'] as String?,
                ),
                settings: settings,
              );

      case Routes.marketplaceRewardDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return defaultTargetPlatform == TargetPlatform.iOS
            ? CupertinoPageRoute(
                builder: (context) => MarketplaceRewardDetailsScreen(
                  orderId: (args?['orderId'] ?? args?['id'] ?? args?['rewardId'])
                      as String?,
                ),
              )
            : _FadedTransitionRoute(
                widget: MarketplaceRewardDetailsScreen(
                  orderId: (args?['orderId'] ?? args?['id'] ?? args?['rewardId'])
                      as String?,
                ),
                settings: settings,
              );

      default:
        return null;
    }
  }
}

class _FadedTransitionRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;

  _FadedTransitionRoute({required this.widget, required this.settings})
    : super(
        settings: settings,
        reverseTransitionDuration: const Duration(milliseconds: 1),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return widget;
            },
        transitionDuration: const Duration(milliseconds: 1),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: animation, curve: Curves.ease),
                child: child,
              );
            },
      );
}

class ScreenTitle extends StatelessWidget {
  final Widget widget;

  const ScreenTitle({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: .5, end: 1),
      duration: const Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: widget,
    );
  }
}
