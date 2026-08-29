import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/common_widgets/custom_textform_field.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/common_widgets/app_network_image.dart';

class BusinessPartnerEmployeeProfile extends StatefulWidget {
  final VoidCallback? onBackTapped;

  const BusinessPartnerEmployeeProfile({super.key, this.onBackTapped});

  @override
  State<BusinessPartnerEmployeeProfile> createState() =>
      _BusinessPartnerEmployeeProfileState();
}

class _BusinessPartnerEmployeeProfileState
    extends State<BusinessPartnerEmployeeProfile> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
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
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    UIHelper.verticalSpace(32.h),
                    // Profile Avatar with Edit Badge
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.r),
                              child: _imageFile != null
                                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                                  : const AppNetworkImage(
                                      imageUrl:
                                          "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80",
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
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  "assets/icons/edit_icon.png", // Using the edit icon
                                  width: 14.w,
                                  height: 14.w,
                                  color: Colors
                                      .black, // Dark icon inside white badge
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    UIHelper.verticalSpace(40.h),

                    // Text Fields
                    CustomTextFormField(
                      hintText: "Full Name",
                      controller: _fullNameController,
                    ),
                    UIHelper.verticalSpace(16.h),
                    CustomTextFormField(
                      hintText: "Email",
                      controller: _emailController,
                    ),
                    UIHelper.verticalSpace(16.h),
                    CustomTextFormField(
                      hintText: "User Name",
                      controller: _userNameController,
                    ),

                    const Spacer(),

                    // Update Profile Button
                    CustomGradientButton(
                      onPressed: () {
                        // Handle update profile
                      },

                      title: "Update Profile",
                    ),
                    UIHelper.verticalSpace(24.h),
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
