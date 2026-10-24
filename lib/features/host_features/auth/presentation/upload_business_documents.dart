import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:teamstreakpromo/common_widgets/custom_back_button.dart';
import 'package:teamstreakpromo/common_widgets/custom_gradient_button.dart';
import 'package:teamstreakpromo/constants/text_font_style.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/auth_progress_indicator.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/document_upload_widget.dart';
import 'package:teamstreakpromo/features/host_features/auth/widget/custom_selector_field.dart';
import 'package:teamstreakpromo/helpers/navigation_service.dart';
import 'package:teamstreakpromo/helpers/all_routes.dart';
import 'package:teamstreakpromo/helpers/di.dart';
import 'package:teamstreakpromo/constants/app_constants.dart';
import 'package:teamstreakpromo/features/auth/presentation/choose_account_type_screen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:teamstreakpromo/networks/api_acess.dart';
import 'package:teamstreakpromo/common_widgets/custom_toast.dart';
import 'package:teamstreakpromo/gen/assets.gen.dart';

class UploadBusinessDocumentsScreen extends StatefulWidget {
  const UploadBusinessDocumentsScreen({super.key});

  @override
  State<UploadBusinessDocumentsScreen> createState() =>
      _UploadBusinessDocumentsScreenState();
}

class _UploadBusinessDocumentsScreenState
    extends State<UploadBusinessDocumentsScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _args = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _args = Map.from(args);
    }
  }

  String? _frontLicenceName;
  String? _backLicenceName;
  String? _selectedDocumentType;
  final List<String> _documentTypes = [
    "Business license",
    "Certificate of good standing",
    "Article of organization",
    "Business registration certificate",
  ];
  bool _agreedToTerms = false;
  bool _showCheckboxError = false;
  bool _isLoading = false;

  void _showDocumentTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please select specific document",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                UIHelper.verticalSpace(16),
                ...List.generate(_documentTypes.length, (index) {
                  final type = _documentTypes[index];
                  final isSelected = _selectedDocumentType == type;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      type,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primaryColorFirst
                            : Colors.white,
                        fontFamily: "SF Pro",
                        fontSize: 15.sp,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primaryColorFirst,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedDocumentType = type;
                      });
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _TermsAndConditionsDialog(
        onAgreed: () {
          setState(() {
            _agreedToTerms = true;
            _showCheckboxError = false;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

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
                "Upload ${_selectedDocumentType ?? 'Document'}",
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

  void _submitForm() async {
    setState(() {
      _showCheckboxError = !_agreedToTerms;
    });

    if (_formKey.currentState!.validate() && _agreedToTerms) {
      // Setup is fully complete!
      debugPrint("=========================================");
      debugPrint("         UPLOAD BUSINESS DOCUMENTS       ");
      debugPrint("=========================================");
      debugPrint("Front Licence: $_frontLicenceName");
      debugPrint("Back Licence: $_backLicenceName");
      debugPrint("Agreed to terms: $_agreedToTerms");

      Map<String, dynamic> businessProfile = {
        "businessName": _args["businessName"],
        "businessDescription": _args["businessDescription"],
        if (_args.containsKey("einNumber")) "einNumber": _args["einNumber"],
        "location": _args["location"],
        "govtIdFrontImage": _args["govtIdFrontImage"],
        "govtIdBackImage": _args["govtIdBackImage"],
        "businessLicenseFrontImage": _frontLicenceName,
        "businessLicenseBackImage": _backLicenceName,
        if (_selectedDocumentType != null)
          "documentType": _selectedDocumentType,
      };

      String? storedType = appData.read(kAccountType);
      String role = "USER";
      if (storedType == "HOST" ||
          storedType == AccountType.host.name ||
          storedType == AccountType.host.toString() ||
          storedType == "AccountType.host") {
        role = "HOST";
      } else if (storedType == "BUSINESS" ||
          storedType == AccountType.businessPartner.name ||
          storedType == AccountType.businessPartner.toString() ||
          storedType == "AccountType.businessPartner") {
        role = "BUSINESS";
      }

      Map<String, dynamic> body = {
        "name": _args["name"],
        "email": _args["email"],
        "password": _args["password"],
        "confirmPassword": _args["confirmPassword"],
        "role": role,
        "isAgeOver18": true,
        "agreesToTerms": _agreedToTerms,
        "businessProfile": businessProfile,
      };

      dio.FormData formData = dio.FormData.fromMap(body);

      debugPrint("---------- Final JSON Body ----------");
      debugPrint(const JsonEncoder.withIndent('  ').convert(body));
      debugPrint("=========================================");

      setState(() {
        _isLoading = true;
      });

      try {
        bool result = await signUpRxObj.signUp(formData);
        debugPrint("Sign up API call successful, result: $result");

        setState(() {
          _isLoading = false;
        });

        if (!mounted) return;

        if (result) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                backgroundColor: const Color(0xFF1E222B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 28.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryColorFirst,
                              AppColors.primaryColorSecond,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.black,
                          size: 26,
                        ),
                      ),
                      UIHelper.verticalSpace(20),
                      Text(
                        "Please be patient as our team is verifying your account as we speak! This process takes 24-48 hours. Welcome to Streak! Rooted in community !",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "SF Pro Rounded",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          height: 1.45,
                        ),
                      ),
                      UIHelper.verticalSpace(20),
                      Image.asset(
                        Assets.icons.splashLogo.path,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.contain,
                      ),
                      UIHelper.verticalSpace(24),
                      CustomGradientButton(
                        title: "Got it",
                        height: 46.h,
                        onPressed: () {
                          final accountRole = (role == "BUSINESS")
                              ? AccountType.businessPartner.name
                              : AccountType.host.name;
                          appData.write(kAccountType, accountRole);
                          Navigator.pop(context);
                          NavigationService.navigateToWithArgs(
                            Routes.otpScreen,
                            {
                              "type": (role == "BUSINESS")
                                  ? "business"
                                  : "host",
                              "email": _args["email"],
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          customToastMessage(
            "Sign Up Failed",
            "Could not complete registration.",
            isError: true,
          );
        }
      } catch (e) {
        debugPrint("Sign up API call failed: $e");
        setState(() {
          _isLoading = false;
        });
      }
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
                        "Please upload two forms of business documentation",
                        style: TextFontStyle.textStyle24cFFFFFFSFPro590
                            .copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "SF Pro Rounded",
                            ),
                      ),
                      UIHelper.verticalSpace(8),

                      // Subtitle
                      Text(
                        "Ensure Compliance by Submitting Necessary Business Documentation",
                        style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                            .copyWith(
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

                      // Document Type Selector Tab
                      CustomSelectorField(
                        labelText: "Please select specific document",
                        hintText: "Select document type",
                        value: _selectedDocumentType,
                        onTap: _showDocumentTypeBottomSheet,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please specify document";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(24),

                      // Document upload components
                      DocumentUploadWidget(
                        label: "Front of Document",
                        fileName: _frontLicenceName,
                        onTap: () => _pickDocument(true),
                        onRemove: () {
                          setState(() {
                            _frontLicenceName = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Front of Document is required";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(24),

                      DocumentUploadWidget(
                        label:
                            "Back of Document (If there is no back to the document, please upload the front once more)",
                        fileName: _backLicenceName,
                        onTap: () => _pickDocument(false),
                        onRemove: () {
                          setState(() {
                            _backLicenceName = null;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Back of Document is required (or upload front again)";
                          }
                          return null;
                        },
                      ),
                      UIHelper.verticalSpace(24),

                      // Checkbox: Terms & Conditions
                      GestureDetector(
                        onTap: () {
                          if (_agreedToTerms) {
                            setState(() {
                              _agreedToTerms = false;
                            });
                          } else {
                            _showTermsAndConditionsDialog();
                          }
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
                                            : Colors.white.withValues(
                                                alpha: 0.4,
                                              )),
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
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
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
                onPressed: _isLoading ? null : _submitForm,
                title: "Confirm",
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsAndConditionsDialog extends StatefulWidget {
  final VoidCallback onAgreed;
  const _TermsAndConditionsDialog({required this.onAgreed});

  @override
  State<_TermsAndConditionsDialog> createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<_TermsAndConditionsDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 20) {
        if (!_isScrolledToBottom) {
          setState(() {
            _isScrolledToBottom = true;
          });
        }
      }
    });
    // Check if content is smaller than screen initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent <= 0) {
        setState(() {
          _isScrolledToBottom = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
      backgroundColor: AppColors.scaffoldColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Terms and Conditions",
                  style: TextFontStyle.textStyle24cFFFFFFSFPro590.copyWith(
                    fontSize: 20.sp,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            UIHelper.verticalSpace(16),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Text(
                    "Welcome to Team Streak Promo!\n\n"
                    "These terms and conditions outline the rules and regulations for the use of our app.\n\n"
                    "By accessing this app we assume you accept these terms and conditions. Do not continue to use the app if you do not agree to take all of the terms and conditions stated on this page.\n\n"
                    "1. Introduction\n"
                    "By using our app you accept these terms and conditions in full; accordingly, if you disagree with these terms and conditions or any part of these terms and conditions, you must not use our app.\n\n"
                    "2. License to use app\n"
                    "Unless otherwise stated, we or our licensors own the intellectual property rights in the app and material on the app. Subject to the license below, all these intellectual property rights are reserved.\n\n"
                    "3. Acceptable use\n"
                    "You must not use our app in any way that causes, or may cause, damage to the app or impairment of the availability or accessibility of the app; or in any way which is unlawful, illegal, fraudulent or harmful, or in connection with any unlawful, illegal, fraudulent or harmful purpose or activity.\n\n"
                    "4. Restricted access\n"
                    "Access to certain areas of our app is restricted. We reserve the right to restrict access to other areas of our app, or indeed our whole app, at our discretion.\n\n"
                    "5. User content\n"
                    "In these terms and conditions, “your user content” means material (including without limitation text, images, audio material, video material and audio-visual material) that you submit to our app, for whatever purpose.\n\n"
                    "6. Limited warranties\n"
                    "We do not warrant the completeness or accuracy of the information published on this app; nor do we commit to ensuring that the app remains available or that the material on the app is kept up-to-date.\n\n"
                    "7. Breaches of these terms and conditions\n"
                    "Without prejudice to our other rights under these terms and conditions, if you breach these terms and conditions in any way, we may take such action as we deem appropriate to deal with the breach, including suspending your access to the app, prohibiting you from accessing the app.\n\n"
                    "8. Variation\n"
                    "We may revise these terms and conditions from time to time. Revised terms and conditions will apply to the use of our app from the date of the publication of the revised terms and conditions on our app.\n\n"
                    "9. Assignment\n"
                    "We may transfer, sub-contract or otherwise deal with our rights and/or obligations under these terms and conditions without notifying you or obtaining your consent.\n\n"
                    "10. Severability\n"
                    "If a provision of these terms and conditions is determined by any court or other competent authority to be unlawful and/or unenforceable, the other provisions will continue in effect.\n\n"
                    "Please scroll to the bottom to agree to the terms.",
                    style: TextFontStyle.textStyle14cFFFFFFSFProRounded400
                        .copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ),
              ),
            ),
            UIHelper.verticalSpace(16),
            Opacity(
              opacity: _isScrolledToBottom ? 1.0 : 0.5,
              child: CustomGradientButton(
                onPressed: _isScrolledToBottom ? widget.onAgreed : null,
                child: Text(
                  "I have read and agree",
                  textAlign: TextAlign.center,
                  style: TextFontStyle.textStyle16c000000SFPro590.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                    color: AppColors.c262824,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
