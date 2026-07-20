import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_back_button.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../constants/text_font_style.dart';
import '../../../gen/colors.gen.dart';
import '../../../helpers/ui_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: "Kimberly Gilbert",
  );
  final TextEditingController _emailController = TextEditingController(
    text: "kimberlygil052@gmail.com",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "+88014788582852895",
  );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

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
              "Account Settings",
              style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image
            Center(
              child: SizedBox(
                width: 100.w,
                height: 100.w,
                child: Stack(
                  children: [
                    Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: ClipOval(
                        child: AppNetworkImage(
                          imageUrl: "https://i.pravatar.cc/150?img=11",
                          height: 100.w,
                          width: 100.w,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(32.h),

            // Full Name
            Text(
              "Full Name",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            CustomTextFormField(
              controller: _nameController,
              hintText: "Enter your full name",
            ),
            UIHelper.verticalSpace(24.h),

            // Email
            Text(
              "Email",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            CustomTextFormField(
              controller: _emailController,
              hintText: "Enter your email",
            ),
            UIHelper.verticalSpace(24.h),

            // Phone
            Text(
              "Phone",
              style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
            UIHelper.verticalSpace(8.h),
            CustomTextFormField(
              controller: _phoneController,
              hintText: "Enter your phone",
              keyboardType: TextInputType.phone,
            ),
            UIHelper.verticalSpace(48.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomGradientButton(
          onPressed: () {
            // Update profile action
          },
          title: "Update Profile",
          height: 50.h,
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
