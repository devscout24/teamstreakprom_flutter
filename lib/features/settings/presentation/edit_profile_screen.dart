import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common_widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../common_widgets/custom_toast.dart';
import '../../../gen/assets.gen.dart';
import '../../../gen/colors.gen.dart';
import '../../host_features/auth/widget/custom_selector_field.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../../networks/api_acess.dart';
import '../../../helpers/ui_helpers.dart';
import '../../../networks/endpoints.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  String? _profileImageUrl;
  bool _isLoading = true;
  bool _isUpdating = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      await userProfileRxObj.fetchUserProfile();
      final profile = userProfileRxObj.userProfileData.valueOrNull;
      if (profile?.data != null && mounted) {
        setState(() {
          _nameController.text = profile!.data!.name ?? "";
          _emailController.text = profile.data!.email ?? "";
          _phoneController.text = profile.data!.phoneNumber ?? "";
          String? pImage = profile.data!.profileImage;
          if (pImage != null && pImage.isNotEmpty && !pImage.startsWith('http')) {
            _profileImageUrl = url + pImage;
          } else {
            _profileImageUrl = pImage;
          }
          if (profile.data!.businessProfile != null) {
            _businessNameController.text = profile.data!.businessProfile!.businessName ?? "";
            _businessDescriptionController.text = profile.data!.businessProfile!.businessDescription ?? "";
            _locationController.text = profile.data!.businessProfile!.location ?? "";
          }
        });
      }
    } catch (e) {
      debugPrint("Failed to fetch profile: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  final List<String> _categories = [
    "Music",
    "Comedy",
    "Sports",
    "Arts & Theatre",
    "Festivals",
    "Others",
  ];

  void _showCategoryBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Event Category",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              UIHelper.verticalSpace(16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1.h,
                  ),
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    final isSelected = _selectedCategory == cat;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        cat,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 16.sp,
                          color: isSelected
                              ? AppColors.primaryColorFirst
                              : Colors.white,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check,
                              color: AppColors.primaryColorFirst,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _businessNameController.dispose();
    _businessDescriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFF1E222B),
        highlightColor: Colors.white.withValues(alpha: 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E222B),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            UIHelper.verticalSpace(32.h),
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            UIHelper.verticalSpace(16.h),
            Container(
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1E222B),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      customToastMessage(
        "Validation Error",
        "Name cannot be empty",
        isError: true,
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final Map<String, dynamic> dataMap = {
        "name": name,
        if (_phoneController.text.trim().isNotEmpty)
          "phoneNumber": _phoneController.text.trim(),
        if (_businessNameController.text.trim().isNotEmpty)
          "businessName": _businessNameController.text.trim(),
        if (_businessDescriptionController.text.trim().isNotEmpty)
          "businessDescription": _businessDescriptionController.text.trim(),
        if (_locationController.text.trim().isNotEmpty)
          "location": _locationController.text.trim(),
      };

      if (_imageFile != null) {
        dataMap["profileImage"] = await MultipartFile.fromFile(
          _imageFile!.path,
          filename: _imageFile!.path.split('/').last.split('\\').last,
        );
      }

      FormData formData = FormData.fromMap(dataMap);
      final result = await userProfileRxObj.updateProfile(formData);

      customToastMessage(
        "Success",
        result.message ?? "Profile updated successfully",
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      customToastMessage(
        "Error",
        "Failed to update profile: $e",
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountType = appData.read(kAccountType)?.toString();
    final profileRole =
        userProfileRxObj.userProfileData.valueOrNull?.data?.role?.toUpperCase();

    final isHostOrBP =
        accountType == "AccountType.host" ||
        accountType == "AccountType.businessPartner" ||
        accountType == "HOST" ||
        accountType == "BUSINESS" ||
        accountType == "host" ||
        accountType == "business" ||
        profileRole == "HOST" ||
        profileRole == "BUSINESS";

    final isHost =
        accountType == "AccountType.host" ||
        accountType == "host" ||
        accountType == "HOST" ||
        profileRole == "HOST";

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "Personal Info"),
      body: _isLoading 
          ? _buildShimmerLoading()
          : SingleChildScrollView(
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
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                height: 100.w,
                                width: 100.w,
                                fit: BoxFit.cover,
                              )
                            : (_profileImageUrl != null &&
                                    _profileImageUrl!.isNotEmpty)
                                ? AppNetworkImage(
                                    imageUrl: _profileImageUrl!,
                                    height: 100.w,
                                    width: 100.w,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    Assets.images.placeholderImage.path,
                                    height: 100.w,
                                    width: 100.w,
                                    fit: BoxFit.cover,
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
                          child: Icon(
                            Icons.edit_outlined,
                            color: Colors.black,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            UIHelper.verticalSpace(32.h),

            // Full Name
            CustomTextFormField(
              controller: _nameController,
              hintText: "Full Name",
              labelText: "Full Name",
            ),
            UIHelper.verticalSpace(16.h),

            // Email (read-only)
            CustomTextFormField(
              controller: _emailController,
              hintText: "Email",
              labelText: "Email",
              readOnly: true,
            ),
            UIHelper.verticalSpace(16.h),

            // Phone
            CustomTextFormField(
              controller: _phoneController,
              hintText: "Phone Number",
              labelText: "Phone Number",
              keyboardType: TextInputType.phone,
            ),
            UIHelper.verticalSpace(16.h),

            // Host Specific Fields
            if (isHostOrBP) ...[
              CustomTextFormField(
                controller: _businessNameController,
                hintText: "Business Name",
                labelText: "Business Name",
              ),
              UIHelper.verticalSpace(16.h),

              CustomTextFormField(
                controller: _businessDescriptionController,
                hintText: "Business Description",
                labelText: "Business Description",
                maxLines: 4,
                borderRadius: BorderRadius.circular(24.r),
              ),
              UIHelper.verticalSpace(16.h),

              CustomTextFormField(
                controller: _locationController,
                hintText: "Location",
                labelText: "Location",
              ),
              UIHelper.verticalSpace(16.h),

              if (isHost) ...[
                CustomSelectorField(
                  value: _selectedCategory,
                  hintText: "Event Category",
                  labelText: "Event Category",
                  onTap: _showCategoryBottomSheet,
                  validator: (value) => null,
                ),
                UIHelper.verticalSpace(16.h),
              ],
            ],

            UIHelper.verticalSpace(32.h),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomGradientButton(
          onPressed: _isUpdating ? null : _updateProfile,
          title: _isUpdating ? null : "Update Profile",
          height: 50.h,
          borderRadius: BorderRadius.circular(100.r),
          child: _isUpdating
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
