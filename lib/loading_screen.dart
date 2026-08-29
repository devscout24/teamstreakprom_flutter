import 'package:flutter/material.dart';
import 'package:teamstreakpromo/features/auth/presentation/choose_account_type_screen.dart';
import 'package:teamstreakpromo/features/auth/presentation/signin_screen.dart';
import 'package:teamstreakpromo/features/business_partner/business_partner_navbar_screen.dart';
import 'package:teamstreakpromo/features/host_features/bottom_nav_bar/presentation/host_navigation_screen.dart';
import 'package:teamstreakpromo/navigation_screen.dart';

import 'constants/app_constants.dart';
import 'helpers/di.dart';
import 'helpers/helper_methods.dart';
import 'helpers/post_login.dart';
import 'networks/dio/dio.dart';
import 'onboarding_screen.dart';
import 'welcome_screen.dart';

final class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    try {
      await setInitValue();
      bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;

      if (isLoggedIn) {
        final String token = appData.read(kKeyAccessToken) ?? '';
        DioSingleton.instance.update(token);
        await performPostLoginActions();
      } else {
        DioSingleton.instance.update("");
      }
    } catch (e) {
      debugPrint('Loading Error: $e');
    }

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const WelcomeScreen();
    }

    bool isLoggedIn = appData.read(kKeyIsLoggedIn) ?? false;
    String token = appData.read(kKeyAccessToken) ?? '';

    if (isLoggedIn && token.isNotEmpty) {
      String role = appData.read(kAccountType) ?? '';
      if (role == 'HOST') {
        return const HostNavigationScreen();
      } else if (role == 'BUSINESS') {
        return const BusinessPartnerNavbarScreen();
      } else {
        return const NavigationScreen();
      }
    }

    // Otherwise, show onboarding
    if (appData.read(kKeyfirstTime) ?? true) {
      return const OnBoardingScreen();
    }

    return const SigninScreen();
  }
}
