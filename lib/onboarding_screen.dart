import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'common_widgets/custom_gradient_button.dart';
import 'constants/app_constants.dart';
import 'constants/text_font_style.dart';
import 'gen/colors.gen.dart';
import 'helpers/di.dart';
import 'helpers/ui_helpers.dart';
import 'helpers/navigation_service.dart';
import 'helpers/all_routes.dart';

class OnboardingPageData {
  final String imagePath;
  final String title;
  final String description;
  final String buttonText;

  const OnboardingPageData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      imagePath: 'assets/images/discover_event_image.jpg',
      title: "Discover Events Around You",
      description:
          "Explore exciting events happening near you and never miss your next experience.",
      buttonText: "Next",
    ),
    OnboardingPageData(
      imagePath: 'assets/images/earn_point_image.jpg',
      title: "Earn Points Effortlessly",
      description:
          "Buy tickets, attend events, and invite friends to earn valuable reward points.",
      buttonText: "Next",
    ),
    OnboardingPageData(
      imagePath: 'assets/images/exclusive_rewards_image.jpg',
      title: "Unlock Exclusive Rewards",
      description:
          "Redeem points for rewards from event hosts and local businesses.",
      buttonText: "Next",
    ),
    OnboardingPageData(
      imagePath: 'assets/images/eco_system_image.jpg',
      title: "Welcome to the STREAK Community",
      description: "Now it is time to connect to the eco system.",
      buttonText: "Connect To Community",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save that user has completed onboarding
      appData.write(kKeyfirstTime, false);
      // Navigate to SigninScreen using NavigationService
      NavigationService.navigateToReplacement(Routes.signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background images and text PageView (sliding content)
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Image.asset(
                    _pages[index].imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.85),
                            ],
                            stops: const [0.0, 0.4, 0.95],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24.w,
                    right: 24.w,
                    bottom: 140.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: _pages.length,
                            effect: ExpandingDotsEffect(
                              expansionFactor: 4,
                              spacing: 8.w,
                              radius: 3.r,
                              dotWidth: 6.w,
                              dotHeight: 6.h,
                              activeDotColor: AppColors.primaryColorSecond,
                              dotColor: Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        UIHelper.verticalSpace(24),
                        Text(
                          _pages[index].title,
                          style: TextFontStyle.textStyle24cFFFFFFSFPro590
                              .copyWith(
                                fontWeight: FontWeight.w600,
                                fontFamily: "SF Pro Rounded",
                              ),
                        ),
                        UIHelper.verticalSpace(12),
                        Text(
                          _pages[index].description,
                          style: TextFontStyle.textStyle14cFFFFFFSFPro590
                              .copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w400,
                                fontFamily: "SF Pro Rounded",
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          Positioned(
            left: 24.w,
            right: 24.w,
            bottom: 40.h,
            child: CustomGradientButton(
              onPressed: _onNextPressed,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _pages[_currentIndex].buttonText,
                  key: ValueKey<String>(_pages[_currentIndex].buttonText),
                  style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
