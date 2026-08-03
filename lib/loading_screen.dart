import 'dart:async';

import 'package:flutter/material.dart';
import 'package:teamstreakpromo/features/auth/presentation/choose_account_type_screen.dart';
import 'package:teamstreakpromo/features/home/presentation/home_screen.dart';

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
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(const Duration(seconds: 0), () {
      if (_isLoading) {
        loadInitialData();
      }
    });
  }

  Future<void> loadInitialData() async {
    try {
      await setInitValue();

      if (appData.read(kKeyIsLoggedIn) == true) {
        final String token = appData.read(kKeyAccessToken) ?? '';
        DioSingleton.instance.update(token);
        await performPostLoginActions();
      }
    } catch (e) {
      debugPrint('Loading Error: $e');
    }

    _timer?.cancel();

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const WelcomeScreen();
    }

    if (appData.read(kKeyIsLoggedIn) == true) {
      if (appData.read(kKeyIsFirstLoggedIn) == true) {
        HomeScreen();
      }
    }

    if (appData.read(kKeyfirstTime) == true) {
      return const OnBoardingScreen();
    }

    return const ChooseAccountTypeScreen();
  }
}
