import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/auth_progress_indicator.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/document_upload_widget.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';

class UploadBusinessDocumentsScreen extends StatefulWidget {
  const UploadBusinessDocumentsScreen({super.key});

  @override
  State<UploadBusinessDocumentsScreen> createState() =>
      _UploadBusinessDocumentsScreenState();
}

class _UploadBusinessDocumentsScreenState
    extends State<UploadBusinessDocumentsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _frontLicenceName;
  String? _backLicenceName;
  bool _agreedToTerms = false;
  bool _showCheckboxError = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDocument(bool isFront) async {
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
                "Upload Business Licence",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              UIHelper.verticalSpace(16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E222B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                ),
                title: const Text(
                  "Take Photo",
                  style: TextStyle(color: Colors.white, fontFamily: "SF Pro"),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? photo =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      setState(() {
                        if (isFront) {
                          _frontLicenceName = photo.name;
                        } else {
                          _backLicenceName = photo.name;
                        }
                      });
                    }
                  } catch (e) {
                    debugPrint("Error picking image from camera: $e");
                  }
                },
              ),
              Divider(color: Colors.white.withValues(alpha: 0.1)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E222B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_outlined, color: Colors.white),
                ),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Colors.white, fontFamily: "SF Pro"),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      setState(() {
                        if (isFront) {
                          _frontLicenceName = image.name;
                        } else {
                          _backLicenceName = image.name;
                        }
                      });
                    }
                  } catch (e) {
                    debugPrint("Error picking image from gallery: $e");
                  }
                },
              ),
              Divider(color: Colors.white.withValues(alpha: 0.1)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E222B),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.folder_open_outlined, color: Colors.white),
                ),
                title: const Text(
                  "Browse Files",
                  style: TextStyle(color: Colors.white, fontFamily: "SF Pro"),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
                    );
                    if (result != null &&
                        result.files.single.name.isNotEmpty) {
                      setState(() {
                        if (isFront) {
                          _frontLicenceName = result.files.single.name;
                        } else {
                          _backLicenceName = result.files.single.name;
                        }
                      });
                    }
                  } catch (e) {
                    debugPrint("Error picking file: $e");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitForm() {
    setState(() {
      _showCheckboxError = !_agreedToTerms;
    });

    if (_formKey.currentState!.validate() && _agreedToTerms) {
      // Setup is fully complete!
      debugPrint("Front Licence: $_frontLicenceName");
      debugPrint("Back Licence: $_backLicenceName");

      showDialog(
        context: context,
        builder: (context) {
          final gradient = LinearGradient(
            colors: [
              AppColors.primaryColorFirst,
              AppColors.primaryColorSecond,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

          return AlertDialog(
            backgroundColor: const Color(0xFF1E222B),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            title: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
                UIHelper.horizontalSpace(12),
                Text(
                  "Setup Complete",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            content: Text(
              "Your host administrative account has been set up successfully. We will review your documents shortly.",
              style: TextStyle(
                fontFamily: "SF Pro",
                fontSize: 14.sp,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  // Navigate to Login
                  NavigationService.navigateToUntilReplacement(
                    Routes.signInScreen,
                  );
                },
                child: Text(
                  "Finish",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColorSecond,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpace(16),
                      // Back Button
                      const CustomBackButton(),
                      UIHelper.verticalSpace(32),

                      // Title
                      Text(
                        "Upload Business Documents",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "SF Pro Rounded",
                        ),
                      ),
                      UIHelper.verticalSpace(8),

                      // Subtitle
                      Text(
                        "Ensure Compliance by Submitting Necessary Business Documentation",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400.copyWith(
                          color: AppColors.cFFFFFF.withValues(alpha: 0.6),
                          fontFamily: "SF Pro",
                        ),
                      ),
                      UIHelper.verticalSpace(24),

                      // Progress Indicator (Step 4 of 4)
                      const AuthProgressIndicator(
                        currentStep: 4,
                        totalSteps: 4,
                      ),
                      UIHelper.verticalSpace(36),

                      // Document upload components
                      DocumentUploadWidget(
                        label: "Business licence (Front)",
                        fileName: _frontLicenceName,
                        onTap: () => _pickDocument(true),
                        onRemove: () {
                          setState(() {
                            _frontLicenceName = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Front of Business Licence is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(24),

                      DocumentUploadWidget(
                        label: "Business licence (Back)",
                        fileName: _backLicenceName,
                        onTap: () => _pickDocument(false),
                        onRemove: () {
                          setState(() {
                            _backLicenceName = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Back of Business Licence is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(24),

                      // Checkbox: Terms & Conditions
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                            if (_agreedToTerms) {
                              _showCheckboxError = false;
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: _agreedToTerms
                                    ? AppColors.primaryColorFirst
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: _agreedToTerms
                                      ? AppColors.primaryColorFirst
                                      : (_showCheckboxError
                                          ? Colors.redAccent
                                          : Colors.white.withValues(alpha: 0.4)),
                                  width: 2.w,
                                ),
                              ),
                              child: _agreedToTerms
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                            UIHelper.horizontalSpace(12),
                            RichText(
                              text: TextSpan(
                                text: "I agree to all ",
                                style: TextFontStyle
                                    .textStyle14cFFFFFFSFProRounded400
                                    .copyWith(
                                      fontSize: 12.sp,
                                      fontFamily: "SF Pro",
                                      color: Colors.white.withValues(alpha: 0.8),
                                    ),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions",
                                    style: TextStyle(
                                      fontFamily: "SF Pro",
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryColorSecond,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_showCheckboxError)
                        Padding(
                          padding: EdgeInsets.only(left: 32.w, top: 6.h),
                          child: Text(
                            "You must agree to the Terms & Conditions to proceed",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      UIHelper.verticalSpace(40),
                    ],
                  ),
                ),
              ),
            ),
            // Floating bottom Confirm button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: CustomGradientButton(
                onPressed: _submitForm,
                title: "Confirm",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
