import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common_widgets/custom_app_bar.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common_widgets/app_network_image.dart';
import '../../../common_widgets/custom_gradient_button.dart';
import '../../../common_widgets/custom_textform_field.dart';
import '../../../gen/colors.gen.dart';
import '../../host_features/auth/widget/custom_selector_field.dart';
import '../../../constants/app_constants.dart';
import '../../../helpers/di.dart';
import '../../../helpers/ui_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _businessDescriptionController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  String? _selectedCategory;
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

  @override
  Widget build(BuildContext context) {
    final accountType = appData.read(kAccountType);
    final isHostOrBP =
        accountType == "AccountType.host" ||
        accountType == "AccountType.businessPartner";
    final isHost = accountType == "AccountType.host" || accountType == "host";

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: const CustomAppBar(title: "Personal Info"),
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
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                height: 100.w,
                                width: 100.w,
                                fit: BoxFit.cover,
                              )
                            : AppNetworkImage(
                                imageUrl: "https://i.pravatar.cc/150?img=11",
                                height: 100.w,
                                width: 100.w,
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

            // Email (hide for host if we want to match mockup, but let's keep it conditionally)
            if (!isHostOrBP) ...[
              CustomTextFormField(
                controller: _emailController,
                hintText: "Email",
                labelText: "Email",
              ),
              UIHelper.verticalSpace(16.h),
            ],

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
