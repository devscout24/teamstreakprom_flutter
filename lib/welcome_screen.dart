import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'constants/text_font_style.dart';
import 'gen/assets.gen.dart';

final class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late final Timer _timer;
  double _opacity = 1.0;

  final List<String> _sliderTexts = [
    "Rooted in community",
    "Discover Events Around You",
    "Earn Points Effortlessly",
    "Unlock Exclusive Rewards",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _sliderTexts.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (mounted) {
        setState(() {
          _opacity = 0.0;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 5000), () {
      if (!mounted) return;

      // Navigate to your next screen here
      // Example:
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      // );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // To ensure it fades to black
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 1000),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                Assets.gif.a2xSplashScreen.path,
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: SizedBox.expand(
                child: Column(
                  children: [
                    const Spacer(),
                    SizedBox(
                      height: 35.h,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _sliderTexts.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Center(
                              child: AnimatedSlideLeftToRight(
                                text: _sliderTexts[index],
                                animate: index == _currentPage,
                                style: TextFontStyle.textStyle20c232421SFPro590
                                    .copyWith(fontSize: 20),
                              ),
                            );
                          }
                          return Center(
                            child: TypewriterText(
                              text: _sliderTexts[index],
                              animate: index == _currentPage,
                              style: TextFontStyle.textStyle20c232421SFPro590
                                  .copyWith(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final Duration speed;
  final bool animate;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.speed = const Duration(milliseconds: 50),
    required this.animate,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText> {
  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(' ');
    int charIndexOffset = 0;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 6.w,
      runSpacing: 4.h,
      children: words.map((word) {
        final chars = word.split('');
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: chars.map((char) {
            final delay = Duration(
              milliseconds: charIndexOffset * widget.speed.inMilliseconds,
            );
            charIndexOffset++;
            return AnimatedCharacter(
              key: ValueKey('${widget.text}_${charIndexOffset}_$char'),
              char: char,
              delay: delay,
              animate: widget.animate,
              style: widget.style,
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class AnimatedCharacter extends StatefulWidget {
  final String char;
  final Duration delay;
  final bool animate;
  final TextStyle? style;

  const AnimatedCharacter({
    super.key,
    required this.char,
    required this.delay,
    required this.animate,
    this.style,
  });

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(
        -0.4,
        0.0,
      ), // Starts slightly to the left, slides to the right
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animate) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animate != widget.animate) {
      if (widget.animate) {
        _startAnimation();
      } else {
        _timer?.cancel();
        _controller.reset();
      }
    }
  }

  void _startAnimation() {
    _timer?.cancel();
    _controller.reset();
    _timer = Timer(widget.delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(widget.char, style: widget.style),
      ),
    );
  }
}

class AnimatedSlideLeftToRight extends StatefulWidget {
  final String text;
  final bool animate;
  final TextStyle? style;

  const AnimatedSlideLeftToRight({
    super.key,
    required this.text,
    required this.animate,
    this.style,
  });

  @override
  State<AnimatedSlideLeftToRight> createState() =>
      _AnimatedSlideLeftToRightState();
}

class _AnimatedSlideLeftToRightState extends State<AnimatedSlideLeftToRight>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // Starts from the left
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedSlideLeftToRight oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.forward(from: 0.0);
    } else if (!widget.animate && oldWidget.animate) {
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          widget.text,
          style: widget.style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
