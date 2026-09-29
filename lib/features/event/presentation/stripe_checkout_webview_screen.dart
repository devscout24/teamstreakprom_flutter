import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class StripeCheckoutWebViewScreen extends StatefulWidget {
  final String url;
  final String successUrl;
  final String cancelUrl;

  const StripeCheckoutWebViewScreen({
    super.key,
    required this.url,
    required this.successUrl,
    required this.cancelUrl,
  });

  @override
  State<StripeCheckoutWebViewScreen> createState() =>
      _StripeCheckoutWebViewScreenState();
}

class _StripeCheckoutWebViewScreenState
    extends State<StripeCheckoutWebViewScreen> {
  late final WebViewController _controller;
  int _loadingProgress = 0;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF13161C))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            if (mounted) {
              setState(() {
                _loadingProgress = progress;
              });
            }
          },
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _hasError = false;
                _errorMessage = null;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _loadingProgress = 100;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (error.isForMainFrame ?? true) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _errorMessage = error.description;
                });
              }
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = request.url;

            if (uri.startsWith(widget.successUrl)) {
              _handleSuccess();
              return NavigationDecision.prevent;
            }

            if (uri.startsWith(widget.cancelUrl)) {
              _handleCancel();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    try {
      controller.loadRequest(Uri.parse(widget.url));
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
    }

    _controller = controller;
  }

  void _handleSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            UIHelper.horizontalSpace(10.w),
            const Expanded(
              child: Text(
                "Payment successful!",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );

    Navigator.of(context).pop(true);
  }

  void _handleCancel() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          "Payment cancelled.",
          style: TextStyle(fontFamily: "SF Pro Rounded"),
        ),
        backgroundColor: const Color(0xFFEAB308),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );

    Navigator.of(context).pop(false);
  }

  Future<bool> _showExitConfirmationDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E222B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          "Leave Checkout?",
          style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "You haven't completed the payment. Are you sure you want to leave?",
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Continue",
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Leave",
              style: TextStyle(
                color: Color(0xFFFF5252),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final shouldLeave = await _showExitConfirmationDialog();
        if (shouldLeave && context.mounted) {
          Navigator.of(context).pop(false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () async {
                  final shouldLeave = await _showExitConfirmationDialog();
                  if (shouldLeave && context.mounted) {
                    Navigator.of(context).pop(false);
                  }
                },
              ),
              centerTitle: true,
              title: Text(
                "Checkout",
                style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                  onPressed: () {
                    _controller.reload();
                  },
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            if (_hasError)
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        color: const Color(0xFFFF5252),
                        size: 54.sp,
                      ),
                      UIHelper.verticalSpace(16.h),
                      Text(
                        "Unable to load checkout",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(8.h),
                      Text(
                        _errorMessage ?? "Please check your internet connection.",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13.sp,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      UIHelper.verticalSpace(24.h),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _hasError = false;
                            _errorMessage = null;
                            _loadingProgress = 0;
                          });
                          _controller.loadRequest(Uri.parse(widget.url));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 12.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF635BFF),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: const Text(
                            "Try Again",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro Rounded",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              WebViewWidget(controller: _controller),

            if (_loadingProgress < 100 && !_hasError)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: _loadingProgress / 100.0,
                  backgroundColor: Colors.transparent,
                  color: const Color(0xFF635BFF),
                  minHeight: 2.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
