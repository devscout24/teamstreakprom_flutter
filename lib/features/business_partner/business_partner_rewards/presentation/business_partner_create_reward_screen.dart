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

  void _onPost() {
    // Final post action
    NavigationService.navigatorKey.currentState?.popUntil((route) => route.isFirst);
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
                RewardWizardStepOne(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  locationController: _locationController,
                  onNextStep: _nextStep,
                )
              else if (_currentStep == 2)
                RewardWizardStepTwo(
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
                )
              else if (_currentStep == 3)
                RewardWizardStepThree(
                  titleController: _titleController,
                  descriptionController: _descriptionController,
                  endDateController: _endDateController,
                  quantityController: _quantityController,
                  rewardPhotoPaths: _rewardPhotoPaths,
                  agreedToTerms: _agreedToTerms,
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
