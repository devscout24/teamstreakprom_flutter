import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_app_bar.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import 'widgets/reward_wizard_progress_indicator.dart';
import 'widgets/reward_wizard_step_one.dart';
import 'widgets/reward_wizard_step_two.dart';
import 'widgets/reward_wizard_step_three.dart';
import '../../../../../helpers/navigation_service.dart';
import '../../../../helpers/all_routes.dart';
import '../../../../common_widgets/custom_toast.dart';
import 'package:dio/dio.dart' as dio;
import '../data/rx_get_reward_categories/rx.dart';
import '../data/rx_post_marketplace/rx.dart';
class BusinessPartnerCreateRewardScreen extends StatefulWidget {
  final bool isEdit;
  const BusinessPartnerCreateRewardScreen({super.key, this.isEdit = false});

  @override
  State<BusinessPartnerCreateRewardScreen> createState() =>
      _BusinessPartnerCreateRewardScreenState();
}

class _BusinessPartnerCreateRewardScreenState
    extends State<BusinessPartnerCreateRewardScreen> {
  int _currentStep = 1;

  final GlobalKey<FormState> _formKeyStep1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyStep2 = GlobalKey<FormState>();

  String? _selectedCategoryId;
  String? _selectedSubcategoryId;
  String? _selectedCategoryName;
  String? _selectedSubcategoryName;

  // Controllers for Step 1
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // Controllers for Step 2
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<String> _rewardPhotoPaths = [];

  // State for Step 3
  bool _agreedToTerms = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getRewardCategoriesRx.getRewardCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _pointsController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_formKeyStep1.currentState!.validate()) return;
    } else if (_currentStep == 2) {
      if (!_formKeyStep2.currentState!.validate()) return;
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      NavigationService.navigatorKey.currentState?.pop();
    }
  }

  String _formatToIsoDateTime(String dateStr, String timeStr) {
    try {
      int year = DateTime.now().year;
      int month = DateTime.now().month;
      int day = DateTime.now().day;

      if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          day = int.parse(parts[0]);
          month = int.parse(parts[1]);
          year = int.parse(parts[2]);
        }
      } else if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        if (parts.length == 3) {
          year = int.parse(parts[0]);
          month = int.parse(parts[1]);
          day = int.parse(parts[2]);
        }
      }

      int hour = 0;
      int minute = 0;
      if (timeStr.isNotEmpty) {
        final isPM = timeStr.toUpperCase().contains('PM');
        final isAM = timeStr.toUpperCase().contains('AM');
        final cleanTime = timeStr.replaceAll(RegExp(r'[^0-9:]'), '').trim();
        final timeParts = cleanTime.split(':');
        if (timeParts.length >= 2) {
          hour = int.parse(timeParts[0]);
          minute = int.parse(timeParts[1]);
          if (isPM && hour < 12) hour += 12;
          if (isAM && hour == 12) hour = 0;
        }
      }

      final dt = DateTime(year, month, day, hour, minute);
      return dt.toUtc().toIso8601String();
    } catch (e) {
      return DateTime.now().toUtc().toIso8601String();
    }
  }

  Future<void> _onPost() async {
    if (_isLoading) return;
    if (!_agreedToTerms) {
      customToastMessage(
        "Notice",
        "Please accept the Terms & Conditions to proceed.",
        isError: true,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint("--- Post Reward Data ---");
      debugPrint("Title: ${_titleController.text}");
      debugPrint("Description: ${_descriptionController.text}");
      debugPrint("Location: ${_locationController.text}");
      debugPrint("Category ID: $_selectedCategoryId");
      debugPrint("Subcategory ID: $_selectedSubcategoryId");
      debugPrint("Start Date: ${_startDateController.text}");
      debugPrint("Start Time: ${_startTimeController.text}");
      debugPrint("End Date: ${_endDateController.text}");
      debugPrint("End Time: ${_endTimeController.text}");
      debugPrint("Points: ${_pointsController.text}");
      debugPrint("Quantity: ${_quantityController.text}");
      debugPrint("Photos: $_rewardPhotoPaths");
      debugPrint("Agreed to terms: $_agreedToTerms");
      debugPrint("------------------------");

      if (_rewardPhotoPaths.isEmpty) {
        customToastMessage(
          "Photos Required",
          "Please select at least one reward photo.",
          isError: true,
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      List<dio.MultipartFile> photoFiles = [];
      for (String path in _rewardPhotoPaths) {
        if (path.isNotEmpty) {
          photoFiles.add(await dio.MultipartFile.fromFile(
            path,
            filename: path.split('/').last.split('\\').last,
          ));
        }
      }

      final Map<String, dynamic> dataMap = {
        "title": _titleController.text.trim(),
        "description": _descriptionController.text.trim(),
        "categoryId": _selectedCategoryId ?? "",
        "location": _locationController.text.trim(),
        "latitude": 40.7128,
        "longitude": -74.006,
        "startDateTime": _formatToIsoDateTime(
          _startDateController.text.trim(),
          _startTimeController.text.trim(),
        ),
        "endDateTime": _formatToIsoDateTime(
          _endDateController.text.trim(),
          _endTimeController.text.trim(),
        ),
        "points": int.tryParse(_pointsController.text.trim()) ?? 0,
        "quantity": int.tryParse(_quantityController.text.trim()) ?? 0,
      };

      if (_selectedSubcategoryId != null &&
          _selectedSubcategoryId!.isNotEmpty) {
        dataMap["subCategoryId"] = _selectedSubcategoryId;
      }

      if (photoFiles.isNotEmpty) {
        dataMap["photos"] = photoFiles;
      }

      final formData = dio.FormData.fromMap(dataMap);

      final response = await postMarketplaceRx.postMarketplace(formData);

      if (response.success == true ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        customToastMessage(
          "Success",
          response.message ?? "Marketplace item created successfully",
        );
        NavigationService.navigateToUntilReplacement(
          Routes.businessPartnerNavbarScreen,
        );
      } else {
        customToastMessage(
          "Error",
          response.message ?? "Failed to create marketplace item",
          isError: true,
        );
      }
    } catch (e) {
      debugPrint("Error creating marketplace item: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // --- Step 2 Methods ---
  final ImagePicker _picker = ImagePicker();

  Future<void> _onAddPhotos() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        setState(() {
          for (var img in images) {
            if (_rewardPhotoPaths.length < 6) {
              _rewardPhotoPaths.add(img.path);
            }
          }
        });
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  void _onRemovePhoto(int index) {
    setState(() {
      if (index == -1) {
        _rewardPhotoPaths.clear();
      } else {
        _rewardPhotoPaths.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 1,
      onPopInvokedWithResult: (didPop, dynamic result) {
        if (!didPop) {
          _previousStep();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        appBar: CustomAppBar(
          title: widget.isEdit ? "Edit Reward" : "Create Reward",
          showRightIcon: false,
          onBack: _previousStep,
          customAction: IconButton(
            icon: const Icon(Icons.close, color: Colors.transparent),
            onPressed: () {},
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RewardWizardProgressIndicator(currentStep: _currentStep),
              UIHelper.verticalSpace(24.h),
              if (_currentStep == 1)
                Form(
                  key: _formKeyStep1,
                  child: RewardWizardStepOne(
                    titleController: _titleController,
                    descriptionController: _descriptionController,
                    locationController: _locationController,
                    onNextStep: _nextStep,
                    onCategoryChanged: (val) {
                      _selectedCategoryId = val;
                    },
                    onCategorySelected: (id, name) {
                      _selectedCategoryId = id;
                      _selectedCategoryName = name;
                    },
                    onSubcategoryChanged: (val) {
                      _selectedSubcategoryId = val;
                    },
                    onSubcategorySelected: (id, name) {
                      _selectedSubcategoryId = id;
                      _selectedSubcategoryName = name;
                    },
                  ),
                )
              else if (_currentStep == 2)
                Form(
                  key: _formKeyStep2,
                  child: RewardWizardStepTwo(
                    startDateController: _startDateController,
                    startTimeController: _startTimeController,
                    endDateController: _endDateController,
                    endTimeController: _endTimeController,
                    pointsController: _pointsController,
                    quantityController: _quantityController,
                    rewardPhotoPaths: _rewardPhotoPaths,
                    onAddPhotos: _onAddPhotos,
                    onRemovePhoto: _onRemovePhoto,
                    onNextStep: _nextStep,
                  ),
                )
              else if (_currentStep == 3)
                RewardWizardStepThree(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  locationController: _locationController,
                  categoryName: _selectedCategoryName,
                  subcategoryName: _selectedSubcategoryName,
                  startDateController: _startDateController,
                  startTimeController: _startTimeController,
                  endDateController: _endDateController,
                  endTimeController: _endTimeController,
                  pointsController: _pointsController,
                  quantityController: _quantityController,
                  rewardPhotoPaths: _rewardPhotoPaths,
                  agreedToTerms: _agreedToTerms,
                  isLoading: _isLoading,
                  onAgreedToTermsChanged: (value) {
                    setState(() {
                      _agreedToTerms = value;
                    });
                  },
                  onEdit: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                  onPost: _onPost,
                )
            ],
          ),
        ),
      ),
    );
  }
}
