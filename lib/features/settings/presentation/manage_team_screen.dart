import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_textform_field.dart';
import 'package:teamstreakpromo/common_widgets/gradient_container.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class ManageTeamScreen extends StatelessWidget {
  const ManageTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CustomBackButton(),
            title: Text(
              "Manage Team",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E222B),
                          borderRadius: BorderRadius.circular(100.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                            width: 1.w,
                          ),
                        ),
                        padding: EdgeInsets.only(left: 16.w, right: 6.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white.withValues(alpha: 0.5),
                              size: 24.sp,
                            ),
                            UIHelper.horizontalSpace(12.w),
                            Expanded(
                              child: TextField(
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextFontStyle
                                      .textStyle14cFFFFFFSFProRounded400
                                      .copyWith(
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    UIHelper.verticalSpace(32.h),

                    // Table
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color(0xFF262829),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                            width: 1.w,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            GradientContainer(
                              height: 56.h,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.r),
                                topRight: Radius.circular(16.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _buildHeaderText("Username"),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildHeaderText("Ticket ID"),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: _buildHeaderText("Event Name"),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: _buildHeaderText("Date & Time"),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Center(
                                      child: _buildHeaderText("Action"),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // List of items
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 6, // Show some dummy items
                              itemBuilder: (context, index) {
                                return _buildTableRow(
                                  "Matthew",
                                  "#2530",
                                  "Ella's Creative Showcase",
                                  "Aug 15, 2026\n10 am",
                                  index.isOdd, // Alternating valid/invalid
                                  index != 5, // Hide divider on last item
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Add New Member Button at the bottom
            Padding(
              padding: EdgeInsets.all(20.w),
              child: CustomGradientButton(
                onPressed: () => _showAddMemberBottomSheet(context),
                borderRadius: BorderRadius.circular(100.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: const Color(0xFF191F24),
                      size: 24.sp,
                    ),
                    UIHelper.horizontalSpace(8.w),
                    Text(
                      "Add New Member",
                      style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF191F24),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "SF Pro Rounded",
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTableRow(
    String username,
    String id,
    String name,
    String date,
    bool isValid,
    bool showDivider,
  ) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2B2F32),
            borderRadius: showDivider
                ? null
                : BorderRadius.only(
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  username,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 10.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  id,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 10.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  name,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 10.sp,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  date,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 10.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: isValid
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    child: Text(
                      isValid ? "Valid" : "Invalid",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: isValid
                            ? Colors.greenAccent[400]
                            : Colors.redAccent[400],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: Colors.white.withValues(alpha: 0.1),
            thickness: 1.h,
            height: 1.h,
          ),
      ],
    );
  }

  void _showAddMemberBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const _AddMemberBottomSheet(),
        );
      },
    );
  }
}

class _AddMemberBottomSheet extends StatefulWidget {
  const _AddMemberBottomSheet();

  @override
  State<_AddMemberBottomSheet> createState() => _AddMemberBottomSheetState();
}

class _AddMemberBottomSheetState extends State<_AddMemberBottomSheet> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.c171A20,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
            ),
          ),
          UIHelper.verticalSpace(16.h),

          // Header with Title and Close Icon
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Invite New Team Member",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 24.sp,
                  ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(16.h),

          Text(
            "Please ensure an this input field for this\ninvitation a new member.",
            textAlign: TextAlign.center,
            style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
          UIHelper.verticalSpace(24.h),

          Divider(color: Colors.white.withValues(alpha: 0.1), thickness: 1.h),
          UIHelper.verticalSpace(24.h),

          // Form Fields
          CustomTextFormField(
            controller: _userNameController,
            hintText: "User Name",
            borderRadius: BorderRadius.circular(100.r),
          ),
          UIHelper.verticalSpace(16.h),
          CustomTextFormField(
            controller: _emailController,
            hintText: "Email",
            borderRadius: BorderRadius.circular(100.r),
          ),
          UIHelper.verticalSpace(16.h),
          CustomTextFormField(
            controller: _passwordController,
            hintText: "Password",
            isPassword: true,
            borderRadius: BorderRadius.circular(100.r),
          ),
          UIHelper.verticalSpace(16.h),
          CustomTextFormField(
            controller: _confirmPasswordController,
            hintText: "Confirm Password",
            isPassword: true,
            borderRadius: BorderRadius.circular(100.r),
          ),
          UIHelper.verticalSpace(24.h),

          // Info Text
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 20.sp),
              UIHelper.horizontalSpace(12.w),
              Expanded(
                child: Text(
                  "This invitation will remain just 24 hours. After this time is end this invitation link is not working.",
                  style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                      .copyWith(
                        color: Colors.orange,
                        fontSize: 12.sp,
                        height: 1.5,
                      ),
                ),
              ),
            ],
          ),
          UIHelper.verticalSpace(24.h),

          CustomGradientButton(
            onPressed: () {
              Navigator.pop(context); // Close for now
            },
            title: "Invite New Member",
          ),
          UIHelper.verticalSpace(24.h),
        ],
      ),
    );
  }
}
