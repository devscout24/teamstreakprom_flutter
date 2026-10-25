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
import 'package:intl/intl.dart';
import '../../../../networks/api_acess.dart';
import '../data/rx_get_reward_categories/rx.dart';
import '../data/rx_get_reward_subcategories/rx.dart';
import '../data/rx_post_marketplace/rx.dart';
import '../data/rx_update_marketplace/rx.dart';
import '../model/get_marketplace_details_model.dart';

class BusinessPartnerCreateRewardScreen extends StatefulWidget {
  final bool isEdit;
  final MarketplaceDetailsData? rewardData;
  final String? rewardId;

  const BusinessPartnerCreateRewardScreen({
    super.key,
    this.isEdit = false,
    this.rewardData,
    this.rewardId,
  });

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
    _populateEditData();
  }

  void _populateEditData() {
    if (widget.isEdit && widget.rewardData != null) {
      final data = widget.rewardData!;
      _titleController.text = data.title ?? "";
      _descriptionController.text = data.description ?? "";
      _locationController.text = data.location ?? "";

      if (data.category != null) {
        _selectedCategoryId = data.category!.id;
        _selectedCategoryName = data.category!.name;
        if (_selectedCategoryId != null && _selectedCategoryId!.isNotEmpty) {
          getRewardSubcategoriesRx.getRewardSubcategories(_selectedCategoryId!);
        }
      }

      if (data.subCategory != null) {
        _selectedSubcategoryId = data.subCategory!.id;
        _selectedSubcategoryName = data.subCategory!.name;
      }

      if (data.startDateTime != null) {
        final startDt = data.startDateTime!.toLocal();
        _startDateController.text =
            "${startDt.day.toString().padLeft(2, '0')}/${startDt.month.toString().padLeft(2, '0')}/${startDt.year}";
        _startTimeController.text = DateFormat("hh:mm a").format(startDt);
      }

      if (data.endDateTime != null) {
        final endDt = data.endDateTime!.toLocal();
        _endDateController.text =
            "${endDt.day.toString().padLeft(2, '0')}/${endDt.month.toString().padLeft(2, '0')}/${endDt.year}";
        _endTimeController.text = DateFormat("hh:mm a").format(endDt);
      }

      if (data.points != null) {
        _pointsController.text = data.points.toString();
      }

      if (data.quantity != null) {
        _quantityController.text = data.quantity.toString();
      }

      if (data.photos != null && data.photos!.isNotEmpty) {
        _rewardPhotoPaths.addAll(data.photos!);
      }
    }
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

  DateTime? _parseDate(String text) {
    if (text.trim().isEmpty) return null;
    try {
      if (text.contains('/')) {
        final parts = text.trim().split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      } else if (text.contains('-')) {
        final parts = text.trim().split('-');
        if (parts.length == 3) {
          final year = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final day = int.parse(parts[2]);
          return DateTime(year, month, day);
        }
      }
    } catch (_) {}
    return null;
  }

  TimeOfDay? _parseTime(String text) {
    if (text.trim().isEmpty) return null;
    try {
      final clean = text.trim().toUpperCase();
      final isPM = clean.contains('PM');
      final isAM = clean.contains('AM');
      final digits = clean.replaceAll(RegExp(r'[^0-9:]'), '');
      final parts = digits.split(':');
      if (parts.length >= 2) {
        int hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        if (isPM && hour < 12) hour += 12;
        if (isAM && hour == 12) hour = 0;
        return TimeOfDay(hour: hour, minute: minute);
      }
    } catch (_) {}
    return null;
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_formKeyStep1.currentState!.validate()) return;
    } else if (_currentStep == 2) {
      if (!_formKeyStep2.currentState!.validate()) return;
      final start = _parseDate(_startDateController.text);
      final end = _parseDate(_endDateController.text);
      if (start != null && end != null && start.isAfter(end)) {
        customToastMessage(
          "Invalid Date",
          "Start date must be set before end date.",
          isError: true,
        );
        return;
      }
      if (start != null && end != null && start.isAtSameMomentAs(end)) {
        final sTime = _parseTime(_startTimeController.text);
        final eTime = _parseTime(_endTimeController.text);
        if (sTime != null && eTime != null) {
          final startMinutes = sTime.hour * 60 + sTime.minute;
          final endMinutes = eTime.hour * 60 + eTime.minute;
          if (endMinutes <= startMinutes) {
            customToastMessage(
              "Invalid Time",
              "End time must be after start time on the same date.",
              isError: true,
            );
            return;
          }
        }
      }
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
      List<String> existingPhotos = [];
      for (String path in _rewardPhotoPaths) {
        if (path.isNotEmpty) {
          if (path.startsWith('http')) {
            existingPhotos.add(path);
          } else {
            photoFiles.add(await dio.MultipartFile.fromFile(
              path,
              filename: path.split('/').last.split('\\').last,
            ));
          }
        }
      }

      final formData = dio.FormData();

      formData.fields.add(MapEntry("title", _titleController.text.trim()));
      formData.fields.add(MapEntry("description", _descriptionController.text.trim()));
      formData.fields.add(MapEntry("categoryId", _selectedCategoryId ?? ""));
      formData.fields.add(MapEntry("location", _locationController.text.trim()));
      formData.fields.add(const MapEntry("latitude", "40.7128"));
      formData.fields.add(const MapEntry("longitude", "-74.006"));
      formData.fields.add(MapEntry(
        "startDateTime",
        _formatToIsoDateTime(
          _startDateController.text.trim(),
          _startTimeController.text.trim(),
        ),
      ));
      formData.fields.add(MapEntry(
        "endDateTime",
        _formatToIsoDateTime(
          _endDateController.text.trim(),
          _endTimeController.text.trim(),
        ),
      ));
      formData.fields.add(MapEntry(
        "points",
        (int.tryParse(_pointsController.text.trim()) ?? 0).toString(),
      ));
      formData.fields.add(MapEntry(
        "quantity",
        (int.tryParse(_quantityController.text.trim()) ?? 0).toString(),
      ));

      if (_selectedSubcategoryId != null &&
          _selectedSubcategoryId!.isNotEmpty) {
        formData.fields.add(MapEntry("subCategoryId", _selectedSubcategoryId!));
      }

      // Handle photos as per backend PATCH /api/marketplaces/{id} documentation:
      // - To keep existing photos: Send existing image URL string(s) in form-data text fields ('photos')
      // - To add new image files: Attach binary image file(s) to form-data field 'photos'
      // - To delete ALL images: Send an empty JSON array string "[]" to the 'photos' field
      if (widget.isEdit) {
        if (existingPhotos.isEmpty && photoFiles.isEmpty) {
          formData.fields.add(const MapEntry("photos", "[]"));
        } else {
          for (String url in existingPhotos) {
            formData.fields.add(MapEntry("photos", url));
          }
          for (var file in photoFiles) {
            formData.files.add(MapEntry("photos", file));
          }
        }
      } else {
        for (var file in photoFiles) {
          formData.files.add(MapEntry("photos", file));
        }
      }

      final dynamic response;
      final String? targetId = widget.rewardId ?? widget.rewardData?.id;
      if (widget.isEdit && targetId != null && targetId.isNotEmpty) {
        response = await updateMarketplaceRx.updateMarketplace(targetId, formData);
      } else {
        response = await postMarketplaceRx.postMarketplace(formData);
      }

      if (response.success == true ||
          response.statusCode == 200 ||
          response.statusCode == 201) {
        customToastMessage(
          "Success",
          response.message ??
              (widget.isEdit
                  ? "Marketplace item updated successfully"
                  : "Marketplace item created successfully"),
        );
        getMyMarketplacesRxObj.fetchMyMarketplaces();
        if (widget.isEdit && targetId != null) {
          getMarketplaceDetailsRxObj.fetchMarketplaceDetails(targetId);
        }
        if (widget.isEdit) {
          if (mounted) {
            Navigator.of(context).pop(true);
          }
        } else {
          NavigationService.navigateToUntilReplacement(
            Routes.businessPartnerNavbarScreen,
          );
        }
      } else {
        customToastMessage(
          "Error",
          response.message ?? "Failed to save marketplace item",
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
                    initialCategoryId: _selectedCategoryId,
                    initialSubcategoryId: _selectedSubcategoryId,
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
                  isEdit: widget.isEdit,
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
                ),
            ],
          ),
        ),
        bottomNavigationBar: _currentStep == 3
            ? RewardWizardStepThreeBottomBar(
                agreedToTerms: _agreedToTerms,
                isLoading: _isLoading,
                isEdit: widget.isEdit,
                onAgreedToTermsChanged: (value) {
                  setState(() {
                    _agreedToTerms = value;
                  });
                },
                onPost: _onPost,
              )
            : null,
      ),
    );
  }
}
