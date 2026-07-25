import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import '../../../../common_widgets/app_network_image.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../common_widgets/gradient_container.dart';
import '../../../../constants/text_font_style.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';

class HostEditProfileScreen extends StatelessWidget {
  const HostEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomAppBar(title: "Profile", customAction: _buildEditAction()),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 2.w,
                ),
              ),
              child: const AppNetworkImage(
                imageUrl:
                    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=300&auto=format&fit=crop",
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
            ),
            UIHelper.verticalSpace(16.h),

            // Name
            Text(
              "Kimberly Gilbert",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            UIHelper.verticalSpace(12.h),

            // Email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/gmail_icon.png',
                  height: 16.w,
                  width: 16.w,
                  color: AppColors.cBCBCBB,
                ),
                UIHelper.horizontalSpace(8.w),
                Text(
                  "kimberlygil052@gmail.com",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.cBCBCBB,
                        fontSize: 13.w,
                        fontFamily: "SF Pro",
                      ),
                ),
              ],
            ),
            UIHelper.verticalSpace(8.h),

            // Phone
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_outlined,
                  color: AppColors.cBCBCBB,
                  size: 16.w,
                ),
                UIHelper.horizontalSpace(8.w),
                Text(
                  "+88014788582852895",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: AppColors.cBCBCBB,
                        fontSize: 13.w,
                        fontFamily: "SF Pro",
                      ),
                ),
              ],
            ),
            UIHelper.verticalSpace(24.h),

            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard(
                  icon: Image.asset(
                    'assets/icons/calender_icon.png',
                    width: 16.w,
                    height: 16.w,
                    color: Colors.white,
                  ),
                  value: "12",
                  label: "Event",
                ),
                _buildStatCard(
                  icon: Image.asset(
                    'assets/icons/point_icon.png',
                    width: 16.w,
                    height: 16.w,
                    color: Colors.orange,
                  ),
                  value: "4.9",
                  label: "Rating",
                ),
                _buildStatCard(
                  icon: Icon(
                    Icons.attach_money_rounded,
                    color: AppColors.c59B53E,
                    size: 16.w,
                  ),
                  value: "12.4K",
                  valueColor: AppColors.c59B53E,
                  label: "Revenue",
                ),
              ],
            ),
            UIHelper.verticalSpace(32.h),

            // Form Fields
            _buildTextField(label: "Business Name", value: "Kimberly Gilbert"),
            UIHelper.verticalSpace(24.h),

            _buildTextField(
              label: "Business Descriptions",
              value:
                  "Experience unmatched comfort with NIKE Men's Sneakers. Crafted for durability, they feature a breathable upper and cushioned sole, ensuring you stay light on your feet. The stylish design seamlessly blends with any outfit, making them a versatile choice for any occasion.",
              maxLines: null,
            ),
            UIHelper.verticalSpace(24.h),

            _buildTextField(label: "Location", value: "Bali Arts Center"),
            UIHelper.verticalSpace(24.h),

            // Event Category
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Event Category",
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            UIHelper.verticalSpace(12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Wrap(
                spacing: 8.w,
                runSpacing: 12.h,
                children: [
                  _buildChip("Music & Nightlife"),
                  _buildChip("Arts & Culture"),
                  _buildChip("Food Festival"),
                  _buildChip("Health & Wellness"),
                  _buildChip("Education"),
                  _buildChip("Sports"),
                  _buildChip("Fashion"),
                ],
              ),
            ),
            UIHelper.verticalSpace(40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEditAction() {
    return GestureDetector(
      onTap: () {
        NavigationService.navigateTo(Routes.editProfileScreen);
      },
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF1E222B),
        ),
        child: Image.asset('assets/icons/edit_icon.png', color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard({
    required Widget icon,
    required String value,
    Color valueColor = Colors.white,
    required String label,
  }) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: GradientContainer(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  UIHelper.horizontalSpace(4.w),
                  Text(
                    value,
                    style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: valueColor,
                    ),
                  ),
                ],
              ),
              UIHelper.verticalSpace(8.h),
              Text(
                label,
                style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                  fontSize: 12.sp,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
            color: AppColors.cBCBCBB,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        UIHelper.verticalSpace(8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(bottom: 12.h, top: 4.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
            ),
          ),
          child: Text(
            value,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.cC6C6C6,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(179, 229, 136, 0.20),
            Color.fromRGBO(248, 255, 245, 0.20),
          ],
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Text(
        label,
        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
          fontSize: 12.sp,
          color: Colors.white.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}
