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

class VerifyIdentityScreen extends StatefulWidget {
  const VerifyIdentityScreen({super.key});

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _args = {};
  bool _isDetailsExpanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _args = Map.from(args);
    }
  }

  String? _frontIdName;
  String? _backIdName;

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
                "Upload Document",
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
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Take Photo",
                  style: TextStyle(color: Colors.white, fontFamily: "SF Pro"),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? photo = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (photo != null) {
                      setState(() {
                        if (isFront) {
                          _frontIdName = photo.name;
                        } else {
                          _backIdName = photo.name;
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
                  child: const Icon(
                    Icons.photo_library_outlined,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Colors.white, fontFamily: "SF Pro"),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      setState(() {
                        if (isFront) {
                          _frontIdName = image.name;
                        } else {
                          _backIdName = image.name;
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
                  child: const Icon(
                    Icons.folder_open_outlined,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Browse Files",
                  style: TextStyle(color: Colors.white, fontFamily: "SF Pro"),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final FilePickerResult? result = await FilePicker.platform
                        .pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
                        );
                    if (result != null && result.files.single.name.isNotEmpty) {
                      setState(() {
                        if (isFront) {
                          _frontIdName = result.files.single.name;
                        } else {
                          _backIdName = result.files.single.name;
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
    if (_formKey.currentState!.validate()) {
      // Form is valid, route to Step 4
      debugPrint("Front ID: $_frontIdName");
      debugPrint("Back ID: $_backIdName");

      _args["govtIdFrontImage"] = _frontIdName;
      _args["govtIdBackImage"] = _backIdName;

      NavigationService.navigateToWithArgs(
        Routes.uploadBusinessDocumentsScreen,
        _args,
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
            // Fixed Top Appbar / Back Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UIHelper.verticalSpace(12),

                      // Title
                      Text(
                        "Identity Verification",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro Rounded",
                            ),
                      ),
                      UIHelper.verticalSpace(8),

                      // Subtitle
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "These uploaded documents help to ensure that our platform is kept safe and transparent. All personal information is kept on file with Streak Promoter LLC otherwise known as Streak. We use this information to verify every business that uses our platform. Here at Streak, Safety and authenticity are our number one priority. Please refer to our terms and conditions document or contact our support team if you have any questions. Please be assured that all legal documents submitted to our platform are handled with the highest level of confidentiality. We do not distribute, share, or disclose your documents to any external parties without your explicit consent.",
                              maxLines: _isDetailsExpanded ? null : 3,
                              overflow: _isDetailsExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: TextFontStyle
                                  .textStyle14cFFFFFFSFProRounded400
                                  .copyWith(
                                    color: AppColors.cFFFFFF.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontFamily: "SF Pro",
                                    height: 1.4,
                                  ),
                            ),
                            UIHelper.verticalSpace(6),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isDetailsExpanded = !_isDetailsExpanded;
                                });
                              },
                              borderRadius: BorderRadius.circular(4.r),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _isDetailsExpanded
                                          ? "Read less"
                                          : "Read more",
                                      style: TextFontStyle
                                          .textStyle14cFFFFFFSFProRounded400
                                          .copyWith(
                                            color: AppColors.primaryColorFirst,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "SF Pro",
                                          ),
                                    ),
                                    UIHelper.horizontalSpace(4),
                                    Icon(
                                      _isDetailsExpanded
                                          ? Icons.keyboard_arrow_up_rounded
                                          : Icons.keyboard_arrow_down_rounded,
                                      color: AppColors.primaryColorFirst,
                                      size: 18.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      UIHelper.verticalSpace(16),

                      // Government ID Instruction
                      Text(
                        "Please upload a government ID. This ensures that we will be able to properly verify the individual setting up this account. These credentials also allow us to understand who is setting up the account, whether this individual is a business owner or a representative on behalf for the business.",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
                              color: AppColors.cFFFFFF.withValues(alpha: 0.8),
                              fontFamily: "SF Pro",
                              height: 1.4,
                            ),
                      ),
                      UIHelper.verticalSpace(24),

                      // Progress Indicator (Step 3 of 4)
                      const AuthProgressIndicator(
                        currentStep: 3,
                        totalSteps: 4,
                      ),
                      UIHelper.verticalSpace(36),

                      // Document upload components
                      DocumentUploadWidget(
                        label: "Government ID (Front)",
                        fileName: _frontIdName,
                        onTap: () => _pickDocument(true),
                        onRemove: () {
                          setState(() {
                            _frontIdName = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Front of Government ID is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(24),

                      DocumentUploadWidget(
                        label: "Government ID (Back)",
                        fileName: _backIdName,
                        onTap: () => _pickDocument(false),
                        onRemove: () {
                          setState(() {
                            _backIdName = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Back of Government ID is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(40),
                    ],
                  ),
                ),
              ),
            ),
            // Floating bottom Continue button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: CustomGradientButton(
                onPressed: _submitForm,
                title: "Continue",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
