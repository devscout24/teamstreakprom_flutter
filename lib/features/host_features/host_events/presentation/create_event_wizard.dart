import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teamstreakpromo/features/host_features/host_events/model/event_model.dart';
import 'package:teamstreakpromo/gen/colors.gen.dart';
import 'package:teamstreakpromo/helpers/ui_helpers.dart';
import '../widget/wizard_progress_indicator.dart';
import '../widget/wizard_step_one.dart';
import '../widget/wizard_step_two.dart';
import '../widget/wizard_step_three.dart';
import '../widget/wizard_step_four.dart';
import '../widget/wizard_step_five.dart';
import '../widget/wizard_step_six.dart';


class CreateEventWizard extends StatefulWidget {
  const CreateEventWizard({super.key});

  @override
  State<CreateEventWizard> createState() => _CreateEventWizardState();
}

class _CreateEventWizardState extends State<CreateEventWizard> {
  int _currentStep = 1; // 1 to 5 represent wizard steps, 6 represents Overview page
  final _formKey = GlobalKey<FormState>();

  // Image Picker
  final ImagePicker _picker = ImagePicker();

  // Step 1 Controllers
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSubcategory;
  final TextEditingController _locationController = TextEditingController();

  // Step 2 Controllers
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final List<String> _eventPhotoPaths = [];
  String? _selectedAgeRestriction = "18+";

  // Step 3 Controllers (Artist Dynamic Forms list)
  final List<ArtistFormModel> _artistForms = [];

  // Step 4 & 5 Controllers (Rewards)
  final TextEditingController _rewardTitleController = TextEditingController();
  final TextEditingController _rewardDescController = TextEditingController();
  final List<String> _rewardPhotoPaths = [];
  final TextEditingController _rewardQuantityController = TextEditingController();
  final List<Map<String, dynamic>> _rewards = [];

  @override
  void initState() {
    super.initState();
    // Pre-populate mock values for demonstration matching mockup
    _eventNameController.text = "";
    _locationController.text = "";
    _priceController.text = "";
    _capacityController.text = "";

    _rewardTitleController.text = "";
    _rewardQuantityController.text = "";

    // Pre-populate dynamic artist list with 1 complete artist & social links
    _artistForms.add(
      ArtistFormModel(
        defaultName: "",
        defaultRole: "",
        defaultSocialLinks: [
          SocialLinkModel(platform: "Facebook", defaultUrl: "https://m.me/v/3aWzhSWinH"),
        ],
      ),
    );

    // Set default mockup reward inside list for Step 5 & Overview
    _rewards.add({
      "title": "Adidas Courtblock Shoes",
      "desc": "adidas is a leading athletic shoe brand known for innovation and quality.",
      "image": "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop",
      "qty": 30,
    });
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _priceController.dispose();
    _capacityController.dispose();
    for (var artist in _artistForms) {
      artist.dispose();
    }
    _rewardTitleController.dispose();
    _rewardDescController.dispose();
    _rewardQuantityController.dispose();
    super.dispose();
  }

  // Show a dialog to let the user add a custom age restriction
  void _showCustomAgeDialog() {
    final TextEditingController customAgeController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            "Enter Custom Age Restriction",
            style: TextStyle(
              fontFamily: "SF Pro Rounded",
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          content: TextField(
            controller: customAgeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "e.g. 21+ or Under 10",
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryColorFirst),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                final text = customAgeController.text.trim();
                if (text.isNotEmpty) {
                  setState(() {
                    _selectedAgeRestriction = text;
                  });
                }
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColorFirst,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: const Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper bottom sheets for CustomSelectorField selection
  void _showSelectorBottomSheet({
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const Divider(color: Colors.white24, height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        onSelected(option);
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

  // Handle file picker actions for multiple image support (Browse Files removed)
  void _showFileSourceOptions(BuildContext context, ValueChanged<List<String>> onPicked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                title: Text("Take Photo", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) onPicked([image.path]);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
                title: Text("Choose from Gallery (Multiple)", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                onTap: () async {
                  Navigator.pop(context);
                  final List<XFile> images = await _picker.pickMultiImage();
                  if (images.isNotEmpty) {
                    onPicked(images.map((img) => img.path).toList());
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Single file picker source for Artist (Browse Files removed)
  void _showSingleFileSourceOptions(BuildContext context, ValueChanged<String?> onPicked) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E222B),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                title: Text("Take Photo", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if (image != null) onPicked(image.path);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
                title: Text("Choose from Gallery", style: TextStyle(color: Colors.white, fontSize: 16.sp)),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                  if (image != null) onPicked(image.path);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePostEvent() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF1E222B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColorSecond.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline_rounded,
                    color: AppColors.primaryColorSecond,
                    size: 50.w,
                  ),
                ),
                UIHelper.verticalSpace(20),
                Text(
                  "Success!",
                  style: TextStyle(
                    fontFamily: "SF Pro Rounded",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                UIHelper.verticalSpace(10),
                Text(
                  "Your event has been created and is now live on the platform.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "SF Pro",
                    fontSize: 14.sp,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.4,
                  ),
                ),
                UIHelper.verticalSpace(24),
                GestureDetector(
                  onTap: () {
                    // Pop dialog
                    Navigator.pop(context);
                    // Pop wizard to return back to Events list screen!
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFF28F31),
                          Color(0xFF72E84F),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Done",
                      style: TextStyle(
                        fontFamily: "SF Pro Rounded",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final showIndicator = _currentStep <= 5;
    final isOverview = _currentStep == 6;

    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      body: SafeArea(
        child: Column(
          children: [
            UIHelper.verticalSpace(20),
            // Header Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: _buildHeader(),
            ),
            UIHelper.verticalSpace(16),

            // Step Indicator (only on steps 1-5)
            if (showIndicator) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 21.w),
                child: WizardProgressIndicator(currentStep: _currentStep),
              ),
              UIHelper.verticalSpace(24),
            ],

            // Content body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: _formKey,
                  child: isOverview ? _buildOverviewContent() : _buildStepContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isOverview = _currentStep == 6;
    final canSkip = _currentStep == 3 || _currentStep == 4 || _currentStep == 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Chevron Button
        GestureDetector(
          onTap: () {
            if (_currentStep > 1) {
              setState(() {
                _currentStep--;
              });
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1E222B),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 20.w,
            ),
          ),
        ),

        // Title
        Text(
          isOverview ? "Create Event" : "Create Event",
          style: TextStyle(
            fontFamily: "SF Pro Rounded",
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),

        // Dynamic Right side button (Skip or Edit Info)
        if (isOverview)
          GestureDetector(
            onTap: () {
              setState(() {
                _currentStep = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColorFirst,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                "Edit Info",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          )
        else if (canSkip)
          GestureDetector(
            onTap: () {
              setState(() {
                _currentStep++;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColorFirst,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Text(
                "Skip",
                style: TextStyle(
                  fontFamily: "SF Pro Rounded",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          )
        else
          SizedBox(width: 40.w), // Spacer to balance layout
      ],
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return WizardStepOne(
          eventNameController: _eventNameController,
          eventDescController: _eventDescController,
          selectedCategory: _selectedCategory,
          selectedSubcategory: _selectedSubcategory,
          locationController: _locationController,
          onCategoryTap: () {
            _showSelectorBottomSheet(
              title: "Choose Categories",
              options: const ["Music Concert", "Art Festival", "Food Expo", "Techno Rave"],
              onSelected: (val) => setState(() => _selectedCategory = val),
            );
          },
          onSubcategoryTap: () {
            _showSelectorBottomSheet(
              title: "Choose Subcategories",
              options: const ["Rock & Pop", "Rave & Electronic", "Fine Art Gallery", "Gourmet Tasting"],
              onSelected: (val) => setState(() => _selectedSubcategory = val),
            );
          },
          onContinue: () {
            if (_formKey.currentState!.validate()) {
              setState(() => _currentStep = 2);
            }
          },
        );
      case 2:
        return WizardStepTwo(
          startDateController: _startDateController,
          startTimeController: _startTimeController,
          endDateController: _endDateController,
          endTimeController: _endTimeController,
          priceController: _priceController,
          capacityController: _capacityController,
          eventPhotoPaths: _eventPhotoPaths,
          onAddPhotos: () => _showFileSourceOptions(context, (paths) => setState(() => _eventPhotoPaths.addAll(paths))),
          onRemovePhoto: (index) {
            setState(() {
              if (index == -1) {
                _eventPhotoPaths.clear();
              } else {
                _eventPhotoPaths.removeAt(index);
              }
            });
          },
          selectedAgeRestriction: _selectedAgeRestriction,
          onAgeRestrictionTap: () {
            _showSelectorBottomSheet(
              title: "Select restriction",
              options: const ["All ages", "12+", "16+", "18+", "+ Custom Age"],
              onSelected: (val) {
                if (val == "+ Custom Age") {
                  _showCustomAgeDialog();
                } else {
                  setState(() => _selectedAgeRestriction = val);
                }
              },
            );
          },
          onContinue: () {
            if (_formKey.currentState!.validate()) {
              setState(() => _currentStep = 3);
            }
          },
        );
      case 3:
        return WizardStepThree(
          artistForms: _artistForms,
          onAddArtist: () => setState(() => _artistForms.add(ArtistFormModel())),
          onRemoveArtist: (index) => setState(() {
            _artistForms[index].dispose();
            _artistForms.removeAt(index);
          }),
          onAddSocialLink: (index) => setState(() => _artistForms[index].socialLinks.add(SocialLinkModel())),
          onRemoveSocialLink: (artistIdx, linkIdx) => setState(() {
            _artistForms[artistIdx].socialLinks[linkIdx].dispose();
            _artistForms[artistIdx].socialLinks.removeAt(linkIdx);
          }),
          onArtistPhotoTap: (index) => _showSingleFileSourceOptions(context, (path) => setState(() => _artistForms[index].photoPath = path)),
          onArtistPhotoRemove: (index) => setState(() => _artistForms[index].photoPath = null),
          onSocialPlatformTap: (artistIdx, linkIdx) {
            _showSelectorBottomSheet(
              title: "Platform",
              options: const ["Facebook", "Instagram", "Twitter", "Youtube"],
              onSelected: (val) => setState(() => _artistForms[artistIdx].socialLinks[linkIdx].platform = val),
            );
          },
          onContinue: () => setState(() => _currentStep = 4),
        );
      case 4:
        return WizardStepFour(
          rewardTitleController: _rewardTitleController,
          rewardDescController: _rewardDescController,
          rewardPhotoPaths: _rewardPhotoPaths,
          onAddPhotos: () => _showFileSourceOptions(context, (paths) => setState(() => _rewardPhotoPaths.addAll(paths))),
          onRemovePhoto: (index) {
            setState(() {
              if (index == -1) {
                _rewardPhotoPaths.clear();
              } else {
                _rewardPhotoPaths.removeAt(index);
              }
            });
          },
          rewardQuantityController: _rewardQuantityController,
          onAddReward: () {
            if (_rewardTitleController.text.isNotEmpty) {
              setState(() {
                _rewards.add({
                  "title": _rewardTitleController.text,
                  "desc": _rewardDescController.text,
                  "image": _rewardPhotoPaths.isNotEmpty ? List<String>.from(_rewardPhotoPaths) : "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop",
                  "qty": int.tryParse(_rewardQuantityController.text) ?? 200,
                });
                _rewardTitleController.clear();
                _rewardDescController.clear();
                _rewardPhotoPaths.clear();
                _rewardQuantityController.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reward added successfully!")));
            }
          },
          onContinue: () {
            if (_rewardTitleController.text.isNotEmpty) {
              _rewards.add({
                "title": _rewardTitleController.text,
                "desc": _rewardDescController.text,
                "image": _rewardPhotoPaths.isNotEmpty ? List<String>.from(_rewardPhotoPaths) : "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop",
                "qty": int.tryParse(_rewardQuantityController.text) ?? 200,
              });
              _rewardTitleController.clear();
              _rewardDescController.clear();
              _rewardPhotoPaths.clear();
              _rewardQuantityController.clear();
            }
            setState(() => _currentStep = 5);
          },
        );
      case 5:
        return WizardStepFive(
          rewards: _rewards,
          onRemoveReward: (index) => setState(() => _rewards.removeAt(index)),
          rewardTitleController: _rewardTitleController,
          rewardDescController: _rewardDescController,
          rewardPhotoPaths: _rewardPhotoPaths,
          onAddPhotos: () => _showFileSourceOptions(context, (paths) => setState(() => _rewardPhotoPaths.addAll(paths))),
          onRemovePhoto: (index) {
            setState(() {
              if (index == -1) {
                _rewardPhotoPaths.clear();
              } else {
                _rewardPhotoPaths.removeAt(index);
              }
            });
          },
          rewardQuantityController: _rewardQuantityController,
          onAddReward: () {
            if (_rewardTitleController.text.isNotEmpty) {
              setState(() {
                _rewards.add({
                  "title": _rewardTitleController.text,
                  "desc": _rewardDescController.text,
                  "image": _rewardPhotoPaths.isNotEmpty ? List<String>.from(_rewardPhotoPaths) : "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop",
                  "qty": int.tryParse(_rewardQuantityController.text) ?? 200,
                });
                _rewardTitleController.clear();
                _rewardDescController.clear();
                _rewardPhotoPaths.clear();
                _rewardQuantityController.clear();
              });
            }
          },
          onContinue: () {
            if (_rewardTitleController.text.isNotEmpty) {
              _rewards.add({
                "title": _rewardTitleController.text,
                "desc": _rewardDescController.text,
                "image": _rewardPhotoPaths.isNotEmpty ? List<String>.from(_rewardPhotoPaths) : "https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=300&auto=format&fit=crop",
                "qty": int.tryParse(_rewardQuantityController.text) ?? 200,
              });
              _rewardTitleController.clear();
              _rewardDescController.clear();
              _rewardPhotoPaths.clear();
              _rewardQuantityController.clear();
            }
            setState(() => _currentStep = 6);
          },
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildOverviewContent() {
    return WizardStepSix(
      eventName: _eventNameController.text,
      location: _locationController.text,
      eventDesc: _eventDescController.text,
      artistForms: _artistForms,
      selectedAgeRestriction: _selectedAgeRestriction,
      rewards: _rewards,
      onPostEvent: _handlePostEvent,
    );
  }
}
