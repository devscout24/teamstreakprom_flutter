import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_textform_field.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';

class HostEmployeeProfileScreen extends StatefulWidget {
  final VoidCallback? onBackTapped;

  const HostEmployeeProfileScreen({super.key, this.onBackTapped});

  @override
  State<HostEmployeeProfileScreen> createState() =>
      _HostEmployeeProfileScreenState();
}

class _HostEmployeeProfileScreenState extends State<HostEmployeeProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  File? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(16.h),
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  CustomBackButton(onTap: widget.onBackTapped),
                  Expanded(
                    child: Text(
                      "Personal Info",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 40.w), // Balance for CustomBackButton
                ],
              ),
            ),
            UIHelper.verticalSpace(32.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // Profile Image
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: _selectedImage != null
                                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                : const AppNetworkImage(
                                    imageUrl:
                                        "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=200&q=80",
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(100),
                                    ),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.scaffoldColor,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.black,
                                size: 16.w,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    UIHelper.verticalSpace(48.h),

                    // Text Fields
                    CustomTextFormField(
                      controller: _fullNameController,
                      hintText: "Full Name",
                    ),
                    UIHelper.verticalSpace(16.h),
                    CustomTextFormField(
                      controller: _emailController,
                      hintText: "Email",
                    ),
                    UIHelper.verticalSpace(16.h),
                    CustomTextFormField(
                      controller: _userNameController,
                      hintText: "User Name",
                    ),

                    UIHelper.verticalSpace(32.h),
                  ],
                ),
              ),
            ),

            // Update Button Fixed at Bottom
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              child: CustomGradientButton(
                onPressed: () {},
                title: "Update Profile",
              ),
            ),
            UIHelper.verticalSpace(20.h),
          ],
        ),
      ),
    );
  }
}
