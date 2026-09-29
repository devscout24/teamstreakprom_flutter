import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/gradient_container.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/di.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/api_acess.dart';
import '../model/stripe_account_status_model.dart';
import 'stripe_webview_screen.dart';

class StripeConnectScreen extends StatefulWidget {
  const StripeConnectScreen({super.key});

  @override
  State<StripeConnectScreen> createState() => _StripeConnectScreenState();
}

class _StripeConnectScreenState extends State<StripeConnectScreen> {
  bool _isConnected = false;
  bool _isLoading = false;
  bool _isFetchingStatus = false;
  String _accountId = "";
  StripeAccountStatusData? _statusData;

  @override
  void initState() {
    super.initState();
    _loadConnectionStatus();
    _fetchAccountStatus();
  }

  void _loadConnectionStatus() {
    final connected = appData.read(kKeyStripeConnected) as bool? ?? false;
    final accountId = appData.read(kKeyStripeAccountId) as String? ?? "";
    setState(() {
      _isConnected = connected;
      _accountId = accountId;
    });
  }

  Future<void> _fetchAccountStatus() async {
    setState(() {
      _isFetchingStatus = true;
    });

    try {
      final response = await getStripeAccountStatusRxObj
          .getStripeAccountStatus();
      if (response.success == true && response.data != null) {
        final data = response.data!;
        if (!mounted) return;
        setState(() {
          _statusData = data;
          _isConnected = data.isStripeConnected ?? false;
          if (data.stripeAccountId != null &&
              data.stripeAccountId!.isNotEmpty) {
            _accountId = data.stripeAccountId!;
            appData.write(kKeyStripeAccountId, data.stripeAccountId);
          }
          appData.write(kKeyStripeConnected, _isConnected);
        });
      }
    } catch (e) {
      debugPrint("Error fetching stripe account status: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingStatus = false;
        });
      }
    }
  }

  Color _getStatusColor() {
    final status = _statusData?.stripeAccountStatus?.toUpperCase();
    if (status == "ACTIVE" || _isConnected) {
      return const Color(0xFF10B981);
    } else if (status == "PENDING") {
      return Colors.amber;
    } else if (status == "RESTRICTED") {
      return const Color(0xFFFF5252);
    }
    return Colors.amber;
  }

  Future<void> _toggleConnection() async {
    if (_isConnected && _statusData?.stripeDetailsSubmitted != false) {
      _showDisconnectDialog();
    } else {
      setState(() {
        _isLoading = true;
      });

      const refreshUrl = "https://yourfrontend.com/host/stripe/refresh";
      const returnUrl = "https://yourfrontend.com/host/stripe/return";
      const country = "US";
      const businessType = "individual";

      try {
        final response = await createStripeConnectRxObj.createConnectAccount(
          refreshUrl: refreshUrl,
          returnUrl: returnUrl,
          country: country,
          businessType: businessType,
        );

        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

        final redirectUrl = response?.data?.url;
        final stripeAccountId = response?.data?.stripeAccountId;

        if (response != null &&
            (response.success ?? false) &&
            redirectUrl != null &&
            redirectUrl.isNotEmpty) {
          // Open in-app webview
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => StripeWebViewScreen(
                url: redirectUrl,
                stripeAccountId: stripeAccountId,
                returnUrl: returnUrl,
                refreshUrl: refreshUrl,
              ),
            ),
          );

          if (result == true && mounted) {
            _loadConnectionStatus();
            _fetchAccountStatus();
          }
        } else {
          final errorMsg =
              response?.message ?? "Failed to generate Stripe onboarding link.";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMsg,
                style: const TextStyle(fontFamily: "SF Pro Rounded"),
              ),
              backgroundColor: const Color(0xFFC72C2C),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "An error occurred: $e",
              style: const TextStyle(fontFamily: "SF Pro Rounded"),
            ),
            backgroundColor: const Color(0xFFC72C2C),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    }
  }

  void _showDisconnectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Disconnect Stripe",
            style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to disconnect your Stripe payment account? You will not be able to receive automated payouts until reconnected.",
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14.sp,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(this.context);
                Navigator.pop(context);
                setState(() {
                  _isLoading = true;
                });
                await Future.delayed(const Duration(milliseconds: 800));
                await appData.write(kKeyStripeConnected, false);
                await appData.remove(kKeyStripeAccountId);

                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _isConnected = false;
                    _accountId = "";
                    _statusData = null;
                  });

                  messenger.showSnackBar(
                    SnackBar(
                      content: const Text(
                        "Stripe account disconnected.",
                        style: TextStyle(fontFamily: "SF Pro Rounded"),
                      ),
                      backgroundColor: const Color(0xFFC72C2C),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  );
                }
              },
              child: const Text(
                "Disconnect",
                style: TextStyle(
                  color: Color(0xFFFF5252),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = userProfileRxObj.userProfileData.valueOrNull?.data;
    final userEmail = userProfile?.email ?? "user@teamstreak.com";

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            centerTitle: true,
            title: Text(
              "Stripe Payment",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: _isFetchingStatus ? null : _fetchAccountStatus,
              ),
            ],
          ),
        ),
      ),
      body: _isFetchingStatus
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: _fetchAccountStatus,
              color: AppColors.primaryColorFirst,
              backgroundColor: const Color(0xFF1E222B),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Stripe Card
                    GradientContainer(
                      padding: EdgeInsets.all(20.w),
                      borderRadius: BorderRadius.circular(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48.w,
                                    height: 48.w,
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF635BFF,
                                      ).withValues(alpha: 0.18),
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: const Color(
                                          0xFF635BFF,
                                        ).withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.stripe,
                                        color: const Color(0xFF635BFF),
                                        size: 28.sp,
                                      ),
                                    ),
                                  ),
                                  UIHelper.horizontalSpace(12.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Stripe Connect",
                                        style: TextStyle(
                                          fontFamily: "SF Pro Rounded",
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        "Payouts & Payments",
                                        style: TextStyle(
                                          fontFamily: "SF Pro",
                                          fontSize: 12.sp,
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor().withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(100.r),
                                  border: Border.all(
                                    color: _getStatusColor(),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _isConnected
                                          ? Icons.check_circle_rounded
                                          : Icons.info_outline_rounded,
                                      size: 13.sp,
                                      color: _getStatusColor(),
                                    ),
                                    UIHelper.horizontalSpace(4.w),
                                    Text(
                                      _statusData?.stripeAccountStatus ??
                                          (_isConnected
                                              ? "Connected"
                                              : "Not Linked"),
                                      style: TextStyle(
                                        fontFamily: "SF Pro Rounded",
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          UIHelper.verticalSpace(16.h),
                          Divider(
                            color: Colors.white.withValues(alpha: 0.08),
                            thickness: 1,
                          ),
                          UIHelper.verticalSpace(12.h),
                          Text(
                            _isConnected
                                ? "Your Stripe account is connected (${_statusData?.stripeAccountStatus ?? 'Active'}). Payouts: ${_statusData?.stripePayoutsEnabled == true ? 'Enabled' : 'Disabled'}, Charges: ${_statusData?.stripeChargesEnabled == true ? 'Enabled' : 'Disabled'}."
                                : "Connect your Stripe account to receive direct payouts, sell tickets, and manage transactions securely.",
                            style: TextStyle(
                              fontFamily: "SF Pro",
                              fontSize: 13.sp,
                              color: Colors.white.withValues(alpha: 0.75),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_isConnected || _statusData != null) ...[
                      UIHelper.verticalSpace(20.h),
                      // Connected Account Details
                      Text(
                        "Account Details",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                      ),
                      UIHelper.verticalSpace(12.h),
                      GradientContainer(
                        padding: EdgeInsets.all(16.w),
                        borderRadius: BorderRadius.circular(16.r),
                        child: Column(
                          children: [
                            if (_statusData?.stripeAccountId?.isNotEmpty ==
                                    true ||
                                _accountId.isNotEmpty) ...[
                              _buildDetailRow(
                                "Account ID",
                                _statusData?.stripeAccountId?.isNotEmpty == true
                                    ? _statusData!.stripeAccountId!
                                    : _accountId,
                              ),
                              _buildDetailDivider(),
                            ],
                            _buildDetailRow("Linked Email", userEmail),
                            _buildDetailDivider(),
                            _buildDetailRow(
                              "Account Status",
                              _statusData?.stripeAccountStatus ??
                                  (_isConnected ? "Connected" : "UNLINKED"),
                              valueColor: _getStatusColor(),
                            ),
                            _buildDetailDivider(),
                            _buildDetailRow(
                              "Verification",
                              _statusData?.isStripeVerified == true
                                  ? "Verified"
                                  : "Unverified",
                              valueColor: _statusData?.isStripeVerified == true
                                  ? const Color(0xFF10B981)
                                  : Colors.amber,
                            ),
                            _buildDetailDivider(),
                            _buildDetailRow(
                              "Payouts",
                              _statusData?.stripePayoutsEnabled == true
                                  ? "Enabled"
                                  : "Disabled",
                              valueColor:
                                  _statusData?.stripePayoutsEnabled == true
                                  ? const Color(0xFF10B981)
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                            _buildDetailDivider(),
                            _buildDetailRow(
                              "Charges",
                              _statusData?.stripeChargesEnabled == true
                                  ? "Enabled"
                                  : "Disabled",
                              valueColor:
                                  _statusData?.stripeChargesEnabled == true
                                  ? const Color(0xFF10B981)
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                            _buildDetailDivider(),
                            _buildDetailRow(
                              "Details Submitted",
                              _statusData?.stripeDetailsSubmitted == true
                                  ? "Yes"
                                  : "No",
                              valueColor:
                                  _statusData?.stripeDetailsSubmitted == true
                                  ? const Color(0xFF10B981)
                                  : Colors.white.withValues(alpha: 0.7),
                            ),
                            _buildDetailDivider(),
                            _buildDetailRow("Payout Schedule", "Daily Rolling"),
                            _buildDetailDivider(),
                            _buildDetailRow("Currency", "USD (\$)"),
                          ],
                        ),
                      ),
                    ],

                    UIHelper.verticalSpace(24.h),
                    Text(
                      "Why connect Stripe?",
                      style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                          .copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                    ),
                    UIHelper.verticalSpace(12.h),

                    _buildFeatureTile(
                      icon: Icons.flash_on_rounded,
                      title: "Direct & Instant Payouts",
                      description:
                          "Receive funds directly into your verified bank account without delays.",
                    ),
                    _buildFeatureTile(
                      icon: Icons.shield_rounded,
                      title: "Bank-Level Security",
                      description:
                          "Stripe is certified PCI Service Provider Level 1, the most stringent security certification.",
                    ),
                    _buildFeatureTile(
                      icon: Icons.credit_card_rounded,
                      title: "Universal Payment Methods",
                      description:
                          "Accept major credit cards, debit cards, Apple Pay, and Google Pay seamlessly.",
                    ),
                    _buildFeatureTile(
                      icon: Icons.analytics_outlined,
                      title: "Automated Reports & Invoicing",
                      description:
                          "Track transactions, download invoices, and monitor financial analytics anytime.",
                    ),

                    UIHelper.verticalSpace(32.h),

                    // Action Button
                    if (!_isConnected ||
                        _statusData?.stripeDetailsSubmitted == false)
                      CustomGradientButton(
                        onPressed: _isLoading ? null : _toggleConnection,
                        height: 52.h,
                        borderRadius: BorderRadius.circular(100.r),
                        child: _isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.stripe,
                                    color: const Color(0xFF1B1C1A),
                                    size: 24.sp,
                                  ),
                                  UIHelper.horizontalSpace(8.w),
                                  Text(
                                    "Connect with Stripe",
                                    style: TextFontStyle
                                        .textStyle14cFFFFFFSFProRounded400
                                        .copyWith(
                                          color: const Color(0xFF1B1C1A),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                        ),
                                  ),
                                ],
                              ),
                      ),
                    UIHelper.verticalSpace(24.h),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: "SF Pro",
              fontSize: 13.sp,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailDivider() {
    return Divider(
      color: Colors.white.withValues(alpha: 0.06),
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GradientContainer(
        padding: EdgeInsets.all(14.w),
        borderRadius: BorderRadius.circular(14.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: const Color(0xFFD39A3D).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFD39A3D), size: 18.sp),
            ),
            UIHelper.horizontalSpace(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "SF Pro Rounded",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  UIHelper.verticalSpace(2.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: "SF Pro",
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
